// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QNQuantityTextField",
    products: [
       .library(name: "QNQuantityTextField", targets: ["QNQuantityTextField"])
   ],
   targets: [
       .target(
           name: "QNQuantityTextField",
           path: "QNQuantityTextField"
//           resources: [.process("/Assets/Media.xcassets")]
//           resources: [.process("/Assets/Media.xcassets")]
       )
   ]
)
