classdef dynamometer < handle
    
    properties (SetAccess = private)
        sensorNumber;
        recording = false; % is the sensor recording
    end
    
    properties (SetAccess = private, GetAccess = private, Hidden = true)
        GoIOhDevice = NaN; % handle to the sensor
        buffer; % buffer of measurements
    end
    
    %% ====================================================================
    % Static methods
    %  ====================================================================
    methods (Access = public, Hidden = false, Static = true)
        
        function num_devices = count_dyn (action)
            persistent number_devices ;
            if isempty (number_devices)
                number_devices = 0;
            end
            
            if exist ('action')
                switch action
                    case 'add'
                        number_devices = number_devices + 1;
                    case 'remove'
                        number_devices = number_devices - 1;
                end
            end
            num_devices = number_devices;
        end
        
    end
    
    %% ====================================================================
    % Private methods
    %  ====================================================================
    methods (Access = private, Hidden = true)
        
        function dy = open (dy, sensorNumber)
            dy.GoIOhDevice = GoIO_Open (sensorNumber - 1);
            GoIO_SwitchLED (dy.GoIOhDevice, 'G');
        end
        
        function dy = close (dy)
            if ~ isnan(dy.GoIOhDevice)
                GoIO_SwitchLED (dy.GoIOhDevice, 'O');
                GoIO_Close (dy.GoIOhDevice);
            end
        end
        
    end
    
    %% ====================================================================
    % Public methods
    %% ====================================================================
    methods
        
        function dy = dynamometer (sensorNumber)
            if ~ exist ('sensor_num', 'var')
                sensorNumber = 1;
            end
            dy.sensorNumber = sensorNumber;

            if dy.count_dyn () == 0
                GoIO_Init ();
            end
            dy = dy.open (dy.sensorNumber);
            dy.count_dyn ('add');
        end
        
        function delete(dy)
            dy.close ();
            dy.count_dyn ('remove');
            
            if dy.count_dyn () == 0
                GoIO_Uninit ();
            end
        end

        function start (dy)

            if dy.recording
                error ('*** Cannot start recording (sensor already started)');
            end
            
            dy.buffer = [];
            % start recording
            GoIO_Start (dy.GoIOhDevice);
            GoIO_SwitchLED (dy.GoIOhDevice, 'R');
            dy.recording = true;
        end
        
        function values = get_buffer (dy)
            values = dy.buffer;
        end
        
        function  stop (dy)
            if dy.recording
                dy.read ();
                GoIO_Stop (dy.GoIOhDevice);
                GoIO_SwitchLED (dy.GoIOhDevice, 'G');
                dy.recording = false;
            else
                error('*** Cannot stop recording (sensor already stopped)');
            end
        end
        
        function value = read (dy)
            dy.buffer = [dy.buffer GoIO_Read(dy.GoIOhDevice)] ;
            value = dy.buffer (end);
        end   
    end
    
end
