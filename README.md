# swiftCache
Volatile and Persistent cache interfaces and implementation

## Usage
This works just by adding the protocol files and implementation to your project.

For persistent cache, using the `.cachesDirectory` allows the system to clean the files as its own rules. A valid alternative is to use `.documentsDirectory` which will allow you to store the data, as long as your app exists, by your own terms.

## TODO
I've left the errors' handling section empty because its implementation will depend on the project requirements.

## References
This was created inspired by the [work](https://www.swiftbysundell.com/articles/caching-in-swift/) of [John Sundell](https://github.com/JohnSundell).

And also using Apple's related documentation:
- [NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [FileManager](https://developer.apple.com/documentation/foundation/filemanager)
