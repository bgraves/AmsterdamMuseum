//
//  CacheUtils.swift
//  WhyNot
//
//  Created by James Bryan Graves on 22/02/15.
//  Copyright (c) 2015 WhyNot. All rights reserved.
//

import Foundation

class CacheUtils : NSObject, NSFileManagerDelegate {
	
	var zipFilename = "amsterdammuseum.zip"
	var requestURLStr = "http://37.139.22.242/"
	
	private func copyURLsToCache(fileURLS: [NSURL]) {
		let fileManager = NSFileManager()
		fileManager.delegate = self
		var error: NSError?
		var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
		if let dirPath = paths[0] as? String {
			for url in fileURLS {
				let data = NSData(contentsOfURL: url)
				let destPath = dirPath + "/" + url.lastPathComponent!
				data?.writeToFile(destPath, atomically: true)
			}
		}
	}
	
	func clearCache() {
		var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
		if let dirPath = paths[0] as? String {
			var error: NSError?
			let fileStrs = NSFileManager.defaultManager().contentsOfDirectoryAtPath(dirPath, error: &error) as [String]
			for fileStr in fileStrs {
				NSFileManager.defaultManager().removeItemAtPath(fileStr, error: &error)
			}
		}
	}
	
	func initializeCache(fileTypes: [String]) {
		for fileType in fileTypes  {
			let fileURLS = NSBundle.mainBundle().URLsForResourcesWithExtension(fileType, subdirectory: nil) as [NSURL]
			copyURLsToCache(fileURLS)
		}
	}
	
	func downloadZip(completionHandler: (Bool) -> Void) {
		var request : NSMutableURLRequest = NSMutableURLRequest()
		request.URL = NSURL(string: requestURLStr + zipFilename)
		request.HTTPMethod = "GET"
		request.cachePolicy = .ReloadIgnoringLocalCacheData
		
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
			completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
				var success = false
				if error == nil {
					var filename = self.zipFilename
					
					// Write data to file - JBG
					var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
					if let dirPath = paths[0] as? String {
						let filePath = dirPath.stringByAppendingPathComponent(filename)
						self.clearCache()
						if data.writeToFile(filePath, atomically: true) {
							var error: NSError?
							success = SSZipArchive.unzipFileAtPath(filePath, toDestination: dirPath, overwrite: true, password: nil, error: &error)
							success = success && error == nil
						}
					}
				}
				completionHandler(success)
		})
	}
	
	// NSFileManagerDelegate - JBG
	
	func fileManager(fileManager: NSFileManager, shouldProceedAfterError error: NSError, movingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
		if error.code == NSFileWriteFileExistsError {
			return true
		} else {
			return false
		}
	}
}