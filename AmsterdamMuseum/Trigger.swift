//
//  Trigger.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 10/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation

class Trigger {
	
	var time: Int?
	var zone: String?
	var friend: String?
	
	convenience init(dict: NSDictionary) {
		self.init()
		time = dict["time"] as? Int
		zone = dict["zone"] as? String
		friend = dict["friend"] as? String
	}
	
}