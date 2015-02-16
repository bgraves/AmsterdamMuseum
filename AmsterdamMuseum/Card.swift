//
//  Card.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 10/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation

enum CardLayout : Int {
	case Default
	case Event
}

class Card {
	
	var layout: CardLayout!
	var title: String!
	var subtitle: String?
	var date: String!
	var avatarUrl: String?
	var images: [String]
	var likes: [String]!
	
	var friendRequest: String?
	
	var trigger: Trigger?
	
	init() {
		images = []
		likes = []
	}
	
	convenience init(dict: NSDictionary) {
		self.init()
		switch dict["layout"] as String {
			case "event":
				layout = .Event
			default:
				layout = .Default
		}
		
		title = dict["title"] as String
		subtitle = dict["subtitle"] as? String
		date = dict["date"] as String
		avatarUrl = dict["avatar"] as? String
		
		if let images = dict["images"] as? NSArray {
			for urlStr in images {
				self.images.append(urlStr as String)
			}
		}
		
		if let triggerDict = dict["triggers"] as? NSDictionary {
			trigger = Trigger(dict: triggerDict)
		}
	
		if let name = dict["friend-request"] as? String {
			self.friendRequest = name
		}
	}
	
	func show(friends: Dictionary<String, Person>, zones: [String], time: Int) -> Bool {
		var show = true
		if let trigger = self.trigger {
//			if let t = trigger.time {
//				show = show && time > t
//			}
//			
//			if let friend = trigger.friend {
//				show = show && friends[friend] != nil
//			}
//			
//			if let zone = trigger.zone {
//				show = show && contains(zones, zone)
//			}
		}
		
		return show
	}
}
