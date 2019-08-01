# cmake-dfetch

CMake module for fetching external project dependencies.

- fetches archive
- verifies hash
- unpacks
- includes to CMake context

Usage example:
```
include(DownloadDependency)

download_dependency(googletest
    URL "https://github.com/google/googletest/archive/release-1.8.1.zip"
    HASH SHA1=7b41ea3682937069e3ce32cb06619fead505795e
)
```
