# Vernier toolbox

Matlab plugin to communicate with Vernier Go!Link devices.

## Install

Copy the @dynamometer folder on your computer in a place accessible by Matlab. You can also install the toolbox as a git submodule in your project.
Note: *Do not* add the @dynamometer folder itself to your path with ```addpath('/path_to/vernier-toolbox/@dynanometer')```.
Only add the parent folder if needed: ```addpath('/path_to/vernier-toolbox')```.

### /!\ Important: Linux

If the toolbox manages to find the handgrip but fails to open it ("Not enough devices available" error although one is plugged in), it might be due to lack of access right to the USB channel. You could try running Matlab as root to see if it solves the problem. A more permanent solution is to create a rule to grant access to the device to other users.

As root:

- Create the file `/etc/udev/rules.d/vernier-dynamometer.rules`
- Edit this file to add the line: `SUBSYSTEM=="usb", ATTRS{idVendor}=="08f7", ATTRS{idProduct}=="0003", MODE="0666"`
- Restart the computer or run `sudo udevadm control --reload`

Another common issue comes from conflicting USB drivers (eg. USB Abstract Control Model) that can disconnect the device after a successfull initialization. A solution is to simply blacklist the incriminated driver, although this might have other side effects...

- As root, edit `/etc/modprobe.d/blacklist.conf`
- Add instruction to blacklist the conflicting driver:
  ```
   #MicroChip
   blacklist cdc_acm
   ```
- Restart the computer
  
## How to use

Have a look to `dynamometer_example.m` for a minimal working script.

Useful functions are:

- `dyn = dynamometer`
    > create a dynamometer handle and connect to the device
- `dyn.start`
    > start recording
- `dyn.read`
    > update the internal buffer and return the current value
- `dyn.stop`
    > stop recording and return the whole recorded data since `dyn.start`
- `dyn.get_buffer`
    > return the whole recorded data since `dyn.start`
- `dyn.calibrate`
    > optional reset of the baseline. This done automatically when the dynamometer is created.
    
## System

This code has been tested on Mac OS X, Windows 10, and Ubuntu 18.04, but should work on older 64bits systems.
If you need to run this toolbox on older or alternative system, you will need to recompile the [Vernier SDK](https://github.com/VernierST/GoIO_SDK) and the .mex files of the toolbox. More precisely:

1. Follow the instructions in the vernier-SDK folder to compile the library. Note that the provided copy here has been slightly altered to be able to be compiled on more recent Ubuntu version. Then, copy the the resulting shared library (.dylib, .so, .lib and .dll) in place of the one found in the `@dynamometer/private` folder.

2. Check the `@dynamometer/private/src` README to see how to recompile the mex files.
