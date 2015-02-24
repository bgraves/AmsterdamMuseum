//
//  Trigger.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 10/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation

class Trigger {
	
	var time: NSTimeInterval? = nil
	var zone: String? = nil
	var friend: String? = nil
	
	convenience init(dict: NSDictionary) {
		self.init()
		time = dict["time"] as? NSTimeInterval
		zone = dict["zone"] as? String
		
		if let friend = dict["friend"] as? String {
			if countElements(friend) > 0 {
				self.friend = friend
			}
		}
	}
}