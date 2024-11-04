// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription



let package = Package(
	name: "Dawn",
	
	platforms: [
		.macOS(.v13)
	],
	

	products: [
		.library(
			name: "Dawn",
			targets: [
				"Dawn"
			]),
	],
	targets: [

		.target(
			name: "Dawn",
			/* include all targets where .h contents need to be accessible to swift */
			dependencies: ["DawnObjc","DawnFramework"],
			path: "./DawnSwift"
		),
		
		.binaryTarget(
					name: "DawnFramework",
					path: "Dawn/Dawn.xcframework"
					//url: "https://github.com/NewChromantics/PopH264/releases/download/v1.3.41/PopH264.xcframework.zip",
					//checksum: "8a378470a2ab720f2ee6ecf4e7a5e202a3674660c31e43d95d672fe76d61d68c"
				),
		
		.target(
			name: "DawnObjc",
			dependencies: [],
			path: "./DawnObjc",
			//publicHeadersPath: ".",	//	not using include/ seems to have some errors resolving symbols? (this may before my extern c's)
			cxxSettings: [
				.headerSearchPath("./"),	//	this allows headers in same place as .cpp
				//.headerSearchPath("../PopCameraDevice.xcframework/ios-arm64/LibCpp.framework/Headers"),
				.headerSearchPath("Dawn/Dawn.xcframework/macos-arm64/Headers"),
			]
		)
		,
/*
		.testTarget(
			name: "PopH264Tests",
			dependencies: ["PopH264"]
		),
 */
	]
)
