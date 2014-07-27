classdef dynamometer < handle
    
    %%
    properties (SetAccess = private)
        frequency=200;
        working = false;
        recording=false;
    end
    
    properties (Hidden = true, SetAccess = private)
        
    end
    
    properties (Hidden = true, SetAccess = private, GetAccess = private)
        vernier = VernierDictionary ;
        GoIOhDevice ;
        buffer ;
        buffer_t ;
    end
    
    %% ====================================================================
    % Private methods
    %% ====================================================================
    methods (Access = private, Hidden = true)
        
        
        % load the dynamic library
        % -----------------------------------------------------------------
        function load_library(dy)
            warning off MATLAB:loadlibrary:TypeNotFoundForStructure
            if not(libisloaded('GoIO_DLL'))
                % add 'GSkipCommExt' to access structures definition
                loadlibrary('GoIO_DLL','GoIO_DLL_interface.h','addheader','GSkipCommExt');
            end
        end
        
        % unload the dynamic library
        % -----------------------------------------------------------------
        function unload_library(dy)
            if libisloaded('GoIO_DLL')
                unloadlibrary('GoIO_DLL');
            end
        end
        
        % init the GoIO library
        % -----------------------------------------------------------------
        function init_GoIO(dy)
            retValue = calllib('GoIO_DLL','GoIO_Init');
            if retValue ~= dy.vernier.SKIP_STATUS_SUCCESS
                error('*** Could not initialise the GoIO library.');
            else
                %Version de la DLL
                [~, MajorVersion, MinorVersion] = calllib('GoIO_DLL','GoIO_GetDLLVersion',0,0);
                fprintf('GoIO lib version %d.%d loaded.\n', MajorVersion, MinorVersion);
            end
        end
        
        % uninit the GoIO library
        % -----------------------------------------------------------------
        function uninit_GoIO(dy)
            calllib('GoIO_DLL','GoIO_Uninit');
        end
        
        % connect to the sensor
        % -----------------------------------------------------------------
        function connect_sensor(dy)
            
            % find device name
            GoIOnumSkips = calllib('GoIO_DLL','GoIO_UpdateListOfAvailableDevices', ...
                dy.vernier.VERNIER_DEFAULT_VENDOR_ID, dy.vernier.SKIP_DEFAULT_PRODUCT_ID);
            if GoIOnumSkips < 1
                error('*** No GoLink connected!');
            end
            fprintf('Found %d GoLink(s)\n',GoIOnumSkips);
            
            
            % get the identifier
            [retValue, GoIOdeviceName] = calllib('GoIO_DLL','GoIO_GetNthAvailableDeviceName', ...
                blanks(dy.vernier.GOIO_MAX_SIZE_DEVICE_NAME), dy.vernier.GOIO_MAX_SIZE_DEVICE_NAME, ...
                dy.vernier.VERNIER_DEFAULT_VENDOR_ID, dy.vernier.SKIP_DEFAULT_PRODUCT_ID, ...
                0); % <- the last paramter is the device number
            if retValue == -1
                error('*** Could not identify the device.');
            end
            
            % open the device
            
            [dy.GoIOhDevice] = calllib('GoIO_DLL','GoIO_Sensor_Open',GoIOdeviceName, ...
                dy.vernier.VERNIER_DEFAULT_VENDOR_ID, dy.vernier.SKIP_DEFAULT_PRODUCT_ID, 0);
            if isNull(dy.GoIOhDevice)
                error('*** Cannot connect to sensor.');
            end
            
            %recupere l'identification du capteur
            [retValue, ~, GoIOsensorId]=calllib('GoIO_DLL','GoIO_Sensor_DDSMem_GetSensorNumber', dy.GoIOhDevice,0, 0, dy.vernier.SKIP_TIMEOUT_MS_DEFAULT);
            [retValue, ~, GoIOsensorName] = calllib('GoIO_DLL','GoIO_Sensor_DDSMem_GetLongName', dy.GoIOhDevice, blanks(100), 100);
            if isempty(GoIOsensorName)
                error('*** Cannot connect to sensor.');
            end
            fprintf('Found a ''%s'' sensor (%d).\n', GoIOsensorName,GoIOsensorId);
            
            calllib('GoIO_DLL','GoIO_Sensor_SetMeasurementPeriod', dy.GoIOhDevice, 1/dy.frequency, dy.vernier.SKIP_TIMEOUT_MS_DEFAULT); %5 milliseconds measurement period.
            fprintf('Sampling rate set to %dHz.\n',dy.frequency);
            
        end
        
        
        % disconnect to the sensor
        % -----------------------------------------------------------------
        function disconnect_sensor(dy)
            try calllib('GoIO_DLL','GoIO_Sensor_Close',dy.GoIOhDevice); end
            dy.GoIOhDevice=libpointer('doublePtr',[]);
        end
        
        
        % LEDS
        % -----------------------------------------------------------------
        function switch_led(dy,color)
            %Led Verte
            switch color
                case 'green'
                    ledParameters = struct('color', dy.vernier.kLEDGreen, 'brightness', dy.vernier.kSkipMaxLedBrightness);
                case 'red'
                    ledParameters = struct('color', dy.vernier.kLEDRed, 'brightness', dy.vernier.kSkipMaxLedBrightness);
                case 'orange'
                    ledParameters = struct('color', dy.vernier.kLEDOrange, 'brightness', dy.vernier.kSkipOrangeLedBrightness);
            end
            ledParametersPtr=libpointer('GSkipSetLedStateParams',ledParameters); % requires GSkipCommExt
            calllib('GoIO_DLL','GoIO_Sensor_SendCmdAndGetResponse', dy.GoIOhDevice, dy.vernier.SKIP_CMD_ID_SET_LED_STATE, ledParametersPtr, 2, 0, 0, dy.vernier.SKIP_TIMEOUT_MS_DEFAULT);
            clear ledParametersPtr; %requis pour pouvoir faire le unloadlibrary (ne peux pas quitter si structures encore en mem)
            
        end
        
        function delete(dy)
            dy.close();
        end
        
    end
    
    methods
        
        
        
        function dy = open(dy)
            
            try
                dy.close ;
                dy.load_library ;
                dy.init_GoIO ;
                dy.connect_sensor ;
                
            catch e
                dy.disconnect_sensor ;
                dy.uninit_GoIO;
                dy.unload_library;
                rethrow(e) ;
            end
            
            
            
            % lock device
            
            dy.switch_led('green')
            
            dy.working = true;
        end
        
        
        function dy=close(dy)
            try dy.switch_led('orange'); end
            % closing the sensor
            try calllib('GoIO_DLL','GoIO_Sensor_Close',dy.GoIOhDevice); end
            % unitialize the GoIO
            try calllib('GoIO_DLL','GoIO_Uninit'); end
            % unload the DLL
            try unloadlibrary('GoIO_DLL'); end
            
            dy.working = false;
        end
        
        function dy = dynamometer(frequency)
            
            if nargin > 0
                dy.frequency = max(min(frequency,dy.frequency),1);
            end
            
            dy = dy.open();
        end
        
        function start(dy)
            if ~dy.working
                error('*** Cannot start recording (sensor not initialized)');
            end
            if dy.recording
                fprintf('Already recording...\n');
            else
                dy.buffer = [];
                dy.buffer_t = 0;
                % clear buffer
                calllib('GoIO_DLL','GoIO_Sensor_ClearIO', dy.GoIOhDevice);
                % start recording
                calllib('GoIO_DLL','GoIO_Sensor_SendCmdAndGetResponse', dy.GoIOhDevice, dy.vernier.SKIP_CMD_ID_START_MEASUREMENTS, 0, 0, 0, 0, dy.vernier.SKIP_TIMEOUT_MS_DEFAULT);
                dy.recording = true;
                dy.switch_led('red');
            end
        end
        
        function values = get_buffer(dy)
            values = dy.buffer(1:dy.buffer_t);
        end
        
        function results = stop(dy)
            if dy.recording
                calllib('GoIO_DLL','GoIO_Sensor_SendCmdAndGetResponse', dy.GoIOhDevice, dy.vernier.SKIP_CMD_ID_STOP_MEASUREMENTS, 0, 0, 0, 0, dy.vernier.SKIP_TIMEOUT_MS_DEFAULT);
                dy.recording = false;
                dy.switch_led('green');
                results = dy.get_buffer;
            else
                fprintf('Already stopped\n');
            end
        end
        
        function value = read(dy)
            % read device
            MAX_NUM_MEASUREMENTS = 10*dy.frequency; % 10s buffer
            persistent rawMeasurements ;
            if isempty(rawMeasurements)
                %buffer size, need to be preallocated, need to be a multiple of 6(?)
                rawMeasurements=zeros(1,MAX_NUM_MEASUREMENTS,'int32');
            end
            [numMeasurements, ~, rawMeasurements] = calllib('GoIO_DLL','GoIO_Sensor_ReadRawMeasurements', dy.GoIOhDevice, rawMeasurements, MAX_NUM_MEASUREMENTS);
            % convert values in Newtons
            for t=1:numMeasurements
                volts = calllib('GoIO_DLL','GoIO_Sensor_ConvertToVoltage', dy.GoIOhDevice, rawMeasurements(t)) ;
                measure = calllib('GoIO_DLL','GoIO_Sensor_CalibrateData', dy.GoIOhDevice, volts);
                dy.buffer_t = dy.buffer_t + 1 ;
                dy.buffer(dy.buffer_t) = measure ;
            end
            
            value = dy.buffer(dy.buffer_t);
            
        end
        
    end
    
end
