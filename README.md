﻿# Librum

Librum is an application designed to make reading <b>enjoyable</b> and <b>straightforward</b> for everyone.

It's not **just** an e-book reader. With Librum, you can manage your own online library and access it from any device anytime, anywhere. It has features like note-taking, bookmarking, and highlighting, while offering customization to make it as personal as you want!
 
Librum also provides free access to over 70,000 books and personal reading statistics while being free and completely open source.


# Preview

A simple and modern interface

![image](https://github.com/Librum-Reader/Librum/assets/69865187/bf1d0401-62bd-4f4e-b008-523fb2efd275)

<br>

Setup and manage your own library

![HomeScreenDark](https://github.com/Librum-Reader/Librum/assets/69865187/ea94fc68-1bf0-4933-8d80-43a57c6590c5)

<br>

Customize Librum to make it personal to you

![image](https://github.com/Librum-Reader/Librum/assets/69865187/b8995cf1-a0e6-4993-8c8b-92f7f8e79ebd)


<br>

# How can I get Librum?

Simply go to https://librumreader.com to download Librum.

If you want to build Librum from source, follow the instructions [here](#build-guide).

<br>

# Documentation

For documentation go to [Librum's GitHub-wiki](https://github.com/Librum-Reader/Librum/wiki)

<br>

# Donations

If you like the Librum project, consider donating to the opensource developers at https://www.patreon.com/librumreader.<br><br>
As a team of opensource developers we rely on donations to continue working on projects like Librum. All help is greatly appreciated.

<br>

# Contributing

If you are interested in contributing, feel free to contact us on either:<br>
1. Discord (m_david#0631)
2. Email (contact@librumreader.com)
<br>
We are following a pull request workflow where every contribution is sent as a pull request and merged into the dev/develop branch for testing. <br>
Please make sure to run clang format, keep to the conventions used throughout the application and ensure that all tests pass, before submitting any pull request.

<br>
<br>

# Contact


For questions, you can reach us under: help@librumreader.com
<br>
For business related contact, reach out to us here: contact@librumreader.com

<br>

# Details

### Supported platforms
Part of Librum's aim is to work on **any** platform. No matter where you are or which device you use, you can always continue your book with Librum, as it is <b>cross platform</b>.<br>
We support:
- Windows
- GNU/Linux
- MacOS
- IOS (Coming Soon)
- Android (Coming Soon)
<br>

### Supported formats
Librum is the best choice for all kinds of books, since Librum supports <b>all</b> major book formats<br>
including:
- PDF
- EPUB
- CBZ (Comic books)
- XPS
- PS
- All plain text formats
- Images


<br>

### Features
Librum's objective is to make your reading more <b>productive</b>; to that end, we provide you with a variety of features that you can access via a <b>simple</b> and <b>straightforward</b> interface.<br>
These features include:
- A modern e-reader
- A personalized and customizable library
- Book meta-data editing
- A free in-app bookstore with more than 70.000 books
- Book syncing across all of your devices
- Highlighting
- Bookmarking
- Text search
- Unlimited customization
- Note-taking (Coming Soon)
- TTS (Coming Soon)
- Personalized reading statistics (Coming Soon)
- No-login book reading (Coming Soon)

Want a new feature? Feel free to leave a feature request ticket!

<br><br>

# Build Guide

Follow this guide to build Librum from source.
<br>


## For GNU/Linux

### Prerequisites
- cmake                             (https://cmake.org/download)
- make                              (http://ftp.gnu.org/gnu/make)
- g++                               (https://gcc.gnu.org)
- python3-venv                      (on ubuntu use `sudo apt install python3-venv`)
- Qt 6.5                            (https://www.qt.io/download-open-source)

### Installation
The installation is straight forward, just follow the steps below:

<br>

1. Clone the repository.
    ```sh
    git clone https://github.com/Librum-Reader/Librum.git --recursive
    ```
2. Step into the cloned project folder.
    ```sh
    cd Librum
    ```
3. Create the build folder and step into it.
    ```sh
    mkdir build-Release
    cd build-Release
    ```
4. Run cmake.
    ```sh
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=Off -DCMAKE_PREFIX_PATH=/home/<username>/Qt/<version>/gcc_64 ..
    ```
    `CMAKE_PREFIX_PATH` needs to be set to the Qt install path. Qt is usually installed at /home/name/Qt, so an example might be:
    ```sh
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=Off -DCMAKE_PREFIX_PATH=/home/john/Qt/6.5.1/gcc_64 ..
    ```
6. Build the project
    ```sh
    cmake --build . -j $(nproc)
    ```
7. Install Librum
    ```sh
    cmake --install .
    ```
<br>

### Troubleshooting
Here are solutions to some common errors. If your error is not listed here, please open an issue.
<br>

- Error: `Failed to find required Qt component "Quick".`<br>
- Solution: Install the libGL mesa dev package, on ubuntu its `sudo apt install libgl1-mesa-dev` and on fedora its `sudo dnf install mesa-libGL-devel`.

<br>


## For Windows
### Prerequisites
- cmake                             (https://cmake.org/download)
- Visual Studio <b>19</b>           (https://visualstudio.microsoft.com/de/vs/older-downloads)
- Python                            (https://www.python.org/downloads)
- Qt 6.5                            (https://www.qt.io/download-open-source)

### Installation
To build Librum on windows, run the following commands in the Powershell:

<br>

1. Clone the repository.
    ```sh
    git clone https://github.com/Librum-Reader/Librum.git --recursive
    ```
2. Step into the cloned project folder.
    ```sh
    cd Librum
    ```
3. Create the build folder and step into it.
    ```sh
    mkdir build
    cd build
    ```
4. Run cmake.
    ```sh
    cmake -DBUILD_TESTS=Off -DCMAKE_PREFIX_PATH=<Drive>\\Qt\\<version>\\msvc2019_64 ..
    ```
    `CMAKE_PREFIX_PATH` needs to be set to the Qt install path, for example:
    ```sh
    cmake -DBUILD_TESTS=Off -DCMAKE_PREFIX_PATH=C:\\Qt\\6.5.1\\msvc2019_64 ..
    ```
6. Build the project
    ```sh
    cmake --build . --config Release
    ```
7. Run the app
    ```sh
    ./librum
    ```

### Additional Info
Here are some things to keep in mind during the build process.
<br>

- Make sure to add cmake and the Qt binaries to the `PATH` environment variable
- You need Visual Studio 2019, newer versions will **not** work
- For the Qt installation, you **only** need to choose "MSVC 2019 64-bit", you can untick everything else to reduce the download size

<br>

## For macOS
Support coming soon!
