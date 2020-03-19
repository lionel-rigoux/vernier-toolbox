# vernier-toolbox

Matlab plugin to communicate with Vernier devices

## How to install

- if not already done, install a compiler on your machine.
See [the matlab website](http://fr.mathworks.com/support/compilers/R2015b/index.html) for more details.
Be carefull to get a version of the compiler compatible with your version of Matlab...
- setup matlab to use the compiler by running the command ```mex -setup```
- copy the @dynamometer folder on your computer in a place accessible by Matlab. You can also install the toolbox as a git submodule in your project.
Note: *Do not* add the @dynamometer folder itself to your path with ```addpath('/path_to/vernier-toolbox/@dynanometer')```.
Only add the parent folder if needed: ```addpath('/path_to/vernier-toolbox')```.

### Linux

This toolbox comes with binaries compiled for Ubuntu 18.04. If you are running another Linux system and encounter problems using this toolbox, try compiling the official [Vernier SDK](https://github.com/VernierST/GoIO_SDK) and copy the library as `@dynamometer/GoIO_DLL.so`.

If the toolbox manages to find the handgrip but fails to open it, it might be due to lack of access right to the USB channel. You could try running Matlab as root to see if it solves the problem. A more permanent solution is to create a rule to grant access to the device to other users.

As root:

- Create the file `/etc/udev/rules.d/vernier-dynamometer.rules`
- Edit this file to add the line: `SUBSYSTEM=="usb", ATTRS{idVendor}=="08f7", ATTRS{idProduct}=="0003", MODE="0666"
`
- Restart the computer or run `sudo udevadm control --reload`

## How to use

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

## Roadmap

- [x] Detection of multiple devices
- [ ] automatic treatment of asynchrony with multiple devices
