//
//  Person.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 10/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation

class Person {
	
	var id: String!
	var name: String!
	var avatarUrl: String!
	var info: [(String, String)]!
	
	init() {
		info = []
	}
	
	convenience init(dict: NSDictionary) {
		self.init()
		
		id = dict["id"] as String
		name = dict["name"] as String
		avatarUrl = dict["avatar"] as String
		
		let infoDicts = dict["info"] as NSArray
		for infoDict in infoDicts {
			info.append((infoDict["label"] as String, infoDict["text"] as String))
		}
	}
}
