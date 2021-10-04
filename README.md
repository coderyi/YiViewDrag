# YiViewDrag

[![CI Status](https://img.shields.io/travis/coderyi/YiViewDrag.svg?style=flat)](https://travis-ci.org/coderyi/YiViewDrag)
[![Version](https://img.shields.io/cocoapods/v/YiViewDrag.svg?style=flat)](https://cocoapods.org/pods/YiViewDrag)
[![License](https://img.shields.io/cocoapods/l/YiViewDrag.svg?style=flat)](https://cocoapods.org/pods/YiViewDrag)
[![Platform](https://img.shields.io/cocoapods/p/YiViewDrag.svg?style=flat)](https://cocoapods.org/pods/YiViewDrag)


## Installation

YiViewDrag is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YiViewDrag'
```

## Usage 

enable drag

```
view.vd_enableDrag()
```

The movement area can be restricted to a given rect:

```swift
view.vd_cagingArea = CGRect(x: 0, y: 0, width: 300, height: 300)
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License

YiViewDrag is available under the MIT license. See the LICENSE file for more info.
