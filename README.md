# embedded-modules

![Made With: C/C++](https://img.shields.io/badge/made_with-C%2FC%2B%2B-red?style=for-the-badge&logo=c%2B%2B)
[![Made With: Python](https://img.shields.io/badge/made_with-python-blue?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Compiled With: GCC](https://img.shields.io/badge/compiled_with-gcc-purple?style=for-the-badge&logo=gnu)](https://gcc.gnu.org/)
![Python Version: 3.12](https://img.shields.io/badge/python_version-3.12-darkgreen?style=for-the-badge)
[![Code style: Black](https://img.shields.io/badge/code_style-black-black?style=for-the-badge)](https://github.com/psf/black)

This is a collection of embedded modules written in C/C++ for Arm Cortex-M microcontrollers.

## Architecture
This architecture will concist of common code used by different MCUs so each project can be quickly converted amoungst MCUs. Each project will concist of two parts a boot and a main. All main projects must be position independent so firmware can be updated Over-The-Air. Memory map will be written in .h so values can be used in c/c++ and linker.
### Folder Structure
```
├── arch
|   ├── sdk
|   ├── include
|   |   ├── boot
|   |   ├── common
|   |   └── main
|   └── src
|       ├── boot
|       ├── common
|       └── main
├── build
├── setup
|   └── setup.sh
└── projects
    ├── boot_{mcu}
    ├── main_{project}_{mcu}
    .
    .
    .
```

## Project Requirements
All projects must have the below:
- Technical Requirements
- Schematics
- I/O Mapping

## Required Software
- Embedded Eclipse C/C++
- Python IDE (Pycharm, VS Code)
- Arm GNU Toolchain

## Reference Material
https://eclipse-embed-cdt.github.io/ <br>
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
