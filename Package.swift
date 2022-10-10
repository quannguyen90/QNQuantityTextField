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
       )
   ]
)


//let package = Package(
//    name: "Alamofire",
//    products: [
//        .library(
//            name: "Alamofire",
//            targets: ["Alamofire"])
//    ],
//    targets: [
//        .target(
//            name: "Alamofire",
//            path: "Source")
//    ],
//    swiftLanguageVersions: [.v4, .v5]
//)
