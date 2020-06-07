#  ImageGrid

Displays a grid of images from an API feed.

structured in 3 targets:
- ImageGrid - The iOS "app" which only displays the images as a Collection View - FlowLayout, with preload and caching.
- FeedLoaderiOS - the network layer for iOS, as an iOS framework. 
   It includes an extension of UIImageView which loads and caches images from an URL.
- FeedLoader - the network part, except the UIImageView extension, as a MacOS framework.

All targets have their own tests, the tests for FeedLoader actually compile and work for both iOS and MacOS.
Rationale: it is faster to test on a Mac than it is on a iOS simulator.
There is a single Back to End test, which relies on the network: This is not ideal, and will need to be improved.
Tests execution is quick, less than a second, the Back to End takes most of the time :-)

TODOS:
- adding more tests
- refactoring the UIImageView extension.
- improving caching, e.g: explicit time limit on cachin policy, tune caching allocation (too much right now, and for feeds alone)
- shipping the App with preloaded images
- integrating Reachability
- retry policy, behaviour of app in case Internet is not reachable (e.g: loading as soon as Internet is available, not loading more than once a day)
- more decoupling, right now the Feed is supposed to return a Result of [User] and an Error, the type returned could be more generic, with a mapping.
- The Remote client is just a wrapper on URLSession, could be wrapped inside a more sophisticated "chain of responsibility" or similar pattern
- refactoring tests 
- instantiating a diffable CollectionView on iOS13

