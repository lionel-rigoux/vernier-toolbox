# Vernier GoIO SDK

This repo is a fork of the official [GoIO SDK](https://github.com/VernierST/GoIO_SDK) from Vernier.

The compiled library is already compiled for Windows (GoIO_DLL.dll and GoIO_DLL.lib) and Mac OS (libGoIO.dylib).
The library for Linux (Ubuntu 18.04) can be compiled using the Docker as following:

```
docker build -t vernier-sdk .
docker run --rm -v "$PWD:/opt/mount" vernier-sdk
```
