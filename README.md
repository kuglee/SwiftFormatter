# Swift-format
Xcode extension for [swift-format](https://github.com/apple/swift-format).

It only supports macOS Catalina (10.15).

## How to install
Build from source or download the [latest version](https://github.com/kuglee/Swift-format/releases/latest).
 
## Building from source
1. Download the swift-toolchain version `swift-DEVELOPMENT-SNAPSHOT-2020-01-29-a`.
1. From the command line build `swift-format` using the following commands:
```
git clone https://github.com/kuglee/Swift-format.git
cd Swift-format
git clone https://github.com/apple/swift-format.git
cd swift-format
TOOLCHAINS="org.swift.50202001291a" swift build
```
3. Build the project in Xcode.