vernier-toolbox
===============

Matlab plugin to communicate with Vernier devices

### How to install

- copy the @dynamometer folder on your computer and add it to your Matlab path

### How to use

Have a look to `dynamometer_example.m` for a minimal working script.

Useful functions are:

- `dyn = dynamometer`
    > connect to the device create the handle
- `dyn.start`
    > start recording
- `dyn.read` 
    > update the buffer and return the current value
-  `dyn.stop`
    > stop recording and return the whole recorded data since `dyn.start`
- `dyn.get_buffer`
    > return the whole recorded data since `dyn.start`

### Roadmap

- Detection of multiple devices



