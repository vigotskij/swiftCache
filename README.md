# swiftCache
Volatile and Persistent cache interfaces and implementation

## Usage
You have to build the project and then put the framework inside your own project.

After that, you can use it importing the framework and initializing a specialized Cache, for example:  
```
 import CacheManager
 class SomeClass {
  // You can use only the RAM Cache
  let volatileCache: VolatileCacheable = Cache<String, YourObject>()
  // or Persistent which includes Volatile
  let persistentCache: PersistentCacheable = Cache<String, YourObject>()
  // or, just the Cache class, which has a few default values on the function signatures.
  // Using the Cache class will load both Volatile and Persistent Cache
  let cache: Cache = .init()
 }
 ```

For persistent cache, using the `.cachesDirectory` allows the system to clean the files as its own rules. A valid alternative is to use `.documentsDirectory` which will allow you to store the data, as long as your app exists, by your own terms.

## What is done
* Volatile cache set, get, remove, get keys, and subscript functions
* Persistent cache persist to file and load from file to Volatile cache functions
* Volatile tests for set, get, remove, get keys functions
* Volatile performance tests for set, get, remove and get keys functions
* Persistent parcial tests for both persist and load functions
* Added basic error handling for persist and load functions

## TODO
* PersistentCacheable full test coverage for persist and load functions
* PersistentCacheable performance tests
* Make CacheManager Framework accesible from Cocoapods/Carthage

## References
This was created inspired by the [work](https://www.swiftbysundell.com/articles/caching-in-swift/) of [John Sundell](https://github.com/JohnSundell).

And also using Apple's related documentation:
- [NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [FileManager](https://developer.apple.com/documentation/foundation/filemanager)
