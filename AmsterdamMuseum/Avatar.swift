//
//  Avatar.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 02-02-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class Avatar {
	
	class func getAvatar() -> UIImage? {
		let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
		var path = documentsPath.stringByAppendingPathComponent("avatar.jpg")
		var image = UIImage(contentsOfFile: path)
		return image
	}
	
	class func saveAvatar(image: UIImage) {
		let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
		var path = documentsPath.stringByAppendingPathComponent("avatar.jpg")
		
		var data = UIImageJPEGRepresentation(image, 1)
		data.writeToFile(path, atomically: true)
	}
}