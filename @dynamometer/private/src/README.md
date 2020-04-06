# GoIO interface

To compile the .mex files for your system, you will first need to install a Matlab compatible compiler (see list [here](https://de.mathworks.com/support/requirements/supported-compilers.html)). Then, in the Matlab command window, move to this forlder and run:

```Matlab
mex -setup c++
compile_GoIO()
```
## Linux

If you're on Linux, you will need to install an additional tool, [patchelf](https://github.com/NixOS/patchelf), to ensure the shared library are linked with the proper path.
To do so, open a terminal a run:

```sh
# This isn't needed if you already installed the compiler for Matlab
sudo apt-get install build-essential
sudo apt-get install autoconf
sudo apt-get install git

git clone https://github.com/NixOS/patchelf.git
cd patchelf

./bootstrap.sh
./configure
make
sudo make install

cd ..
rm -rf patchelf
```
