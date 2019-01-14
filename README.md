vernier-toolbox
===============

Matlab plugin to communicate with Vernier devices

### How to install

- if not already done, install a compiler on your machine. 
See [the matlab website](http://fr.mathworks.com/support/compilers/R2015b/index.html) for more details.
Be carefull to get a version of the compiler compatible with your version of Matlab...
- setup matlab to use the compiler by running the command ```mex -setup```
- copy the @dynamometer folder on your computer in a place accessible by Matlab. You can also install the toolbox as a git submodule in your project. 
Note: *Do not* add the @dynamometer folder itself to your path with ```addpath('/path_to/vernier-toolbox/@dynanometer')```. 
Only add the parent folder if needed: ```addpath('/path_to/vernier-toolbox')```.

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

- [x] Detection of multiple devices
- [ ] automatic treatment of asynchrony with multiple devices



