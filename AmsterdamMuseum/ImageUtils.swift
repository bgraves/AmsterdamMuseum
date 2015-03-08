//
//  ImageUtils.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 24/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class ImageUtils {
	class func getImage(imageStr: String) -> UIImage? {
		
		// If imageStr is user.png then return user's avatar - JBG
		if imageStr == "user.png" {
			if let avatar = Avatar.getAvatar() {
				return avatar
			} else {
				return UIImage(named: "DefaultAvatar")
			}
		}
		
		var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
		if let dirPath = paths[0] as? String {
			let filePath = dirPath.stringByAppendingPathComponent(imageStr)
			return UIImage(contentsOfFile: filePath)
		}
		return nil
	}
}
