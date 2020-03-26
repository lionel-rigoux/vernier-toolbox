classdef dynamometer < handle
    
    properties (SetAccess = private)
        deviceNumber; % identifier of the device
        recording = false; % is the sensor recording
        baseline = 0;
    end
    
    properties (SetAccess = private, GetAccess = private, Hidden = true)
        GoIOhDevice = NaN; % GoIO handle to the sensor
        buffer; % internal buffer of measurements
    end
    
    %% ====================================================================
    % Static methods
    %  ====================================================================
    methods (Access = public, Hidden = false, Static = true)
 
        % List devices that are alread open
        % -------------------------------------------------------------
        function list = list_open_devices (action, sensorNumber)
            % Persistent list of open devices
            % `````````````````````````````````````````````````````````````
            persistent deviceList;
            if isempty (deviceList)
                deviceList = [];
            end
            % Add or remove a device from the list, if requested
            % `````````````````````````````````````````````````````````````
            if exist ('action','var')
                switch action
                    case 'add'
                        deviceList = union (deviceList, sensorNumber);
                    case 'remove'
                        deviceList = setdiff(deviceList, sensorNumber);
                end
            end
            % Return list
            % `````````````````````````````````````````````````````````````
            list = deviceList;
        end
        
        % List devices that could be open
        % -------------------------------------------------------------
        function list = list_available_devices ()
            list = setdiff (1 : GoIO_CountDevices(), dynamometer.list_open_devices());
        end
        
    end
    
    %% ====================================================================
    % Public methods
    %% ====================================================================
    methods
        
        % Creator.
        % -------------------------------------------------------------
        function dy = dynamometer (deviceNumberList)
          % If no devices open yet, initialise the GoIO library
            % `````````````````````````````````````````````````````````````
            if isempty (dynamometer.list_open_devices ())
                GoIO_Init ();
            end
            % by default, open all available devices
            % `````````````````````````````````````````````````````````````
            if nargin == 0
                deviceNumberList = dynamometer.list_available_devices ();
            end
            if isempty (deviceNumberList)
                error('*** dynamometer: no devices available.');
            end
            % deal with multiple devices
            % `````````````````````````````````````````````````````````````
            if numel (deviceNumberList) > 1
                dy = arrayfun (@(deviceNumber) dynamometer(deviceNumber), deviceNumberList);
                return;
            end
            % Store device identifier
            % `````````````````````````````````````````````````````````````
            dy.deviceNumber = deviceNumberList;
            % check that we are not trying to reopen an existing device
            % `````````````````````````````````````````````````````````````
            if ismember (dy.deviceNumber, dynamometer.list_open_devices())
                error('*** dynamometer: device %d is already in use.', dy.deviceNumber);
            end
            % Add device to internal list
            % `````````````````````````````````````````````````````````````
            dynamometer.list_open_devices ('add', dy.deviceNumber);
            % Open device, store handle and switch LED
            % `````````````````````````````````````````````````````````````
            % mex starts counting devices from 0
            dy.GoIOhDevice = GoIO_Open (dy.deviceNumber - 1); 
            GoIO_SwitchLED (dy.GoIOhDevice, 'G');
            % Calibrate device
            % `````````````````````````````````````````````````````````````
            dy.calibrate ();
        end
        
        % Destructor.
        % -------------------------------------------------------------
        function delete (dys)
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            for dy = dys
                % Close device
                % `````````````````````````````````````````````````````````````
                % handle might not be set if opening failed
                if ~ isnan(dy.GoIOhDevice) 
                    GoIO_SwitchLED (dy.GoIOhDevice, 'O');
                    GoIO_Close (dy.GoIOhDevice);
                end  
                % Remove from list of open devices
                % ````````````````````````````````````````````````````````````` 
                dy.list_open_devices ('remove', dy.deviceNumber);   
                % If last device, uninitialise the GoIO library
                % ````````````````````````````````````````````````````````````` 
                if isempty (dynamometer.list_open_devices ())
                    GoIO_Uninit ();
                end
            end
        end

        % Start recording.
        % -------------------------------------------------------------
        function start (dys)
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            for dy = dys
                % Cannot start an already recording device
                % `````````````````````````````````````````````````````````````
                if dy.recording
                    error ('*** Cannot start recording (sensor already started)');
                end
                % Reset internal buffer
                % `````````````````````````````````````````````````````````````
                dy.buffer = [];
                % Start recording
                % `````````````````````````````````````````````````````````````
                GoIO_Start (dy.GoIOhDevice);
                GoIO_SwitchLED (dy.GoIOhDevice, 'R');
                dy.recording = true;
            end
        end
 
        % Stop recording.
        % -------------------------------------------------------------
        function  stop (dys)
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            for dy = dys
                % Cannot stop an already stopped device
                % `````````````````````````````````````````````````````````````
                if ~dy.recording
                	error('*** Cannot stop recording (sensor already stopped)');
                end
                % Get last measurments before stopping
                % `````````````````````````````````````````````````````````````
                dy.read ();
                % Stop device
                % `````````````````````````````````````````````````````````````
                GoIO_Stop (dy.GoIOhDevice);
                GoIO_SwitchLED (dy.GoIOhDevice, 'G');
                dy.recording = false; 
            end
        end
       
        % Get measurements frmo Go!Link buffer.
        % -------------------------------------------------------------        
        function value = read (dys)
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            if numel(dys) > 1
                value = arrayfun (@(dy) dy.read (), dys);
                return;
            end
            % Concatenate new measurement to internal buffer
            % `````````````````````````````````````````````````````````````
            dys.buffer =  cat (2, ...
                    dys.buffer, ...
                    GoIO_Read(dys.GoIOhDevice) - dys.baseline ...
                );
            % Return most recent value
            % `````````````````````````````````````````````````````````````
            value = dys.buffer (end);
        end
        
        % Return internal buffer
        % -------------------------------------------------------------        
        function buffer = get_buffer (dys)
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            if numel(dys) > 1
                buffer = arrayfun (@(dy) dy.get_buffer (), dys, 'UniformOutput', false);
                return;
            end
            buffer = dys.buffer;
        end
        
        % Calibration
        % -------------------------------------------------------------        
        function calibrate (dys, duration)
            if nargin < 2
                duration = 0.100;
            end
            % Do a short recording
            % `````````````````````````````````````````````````````````````
            dys.start ();
            pause (duration);
            dys.stop ();
            % Deal with multiple devices
            % `````````````````````````````````````````````````````````````
            for dy = dys
                dy.baseline = mean (dy.get_buffer ());
            end
        end

    end
    
end
