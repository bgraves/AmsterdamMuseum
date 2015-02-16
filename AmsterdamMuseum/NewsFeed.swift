//
//  NewsFeed.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 10/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation

class NewsFeed {
	
	let requestURL = "http://hearushere.nl/cards.json"
	
	var cards: [Card]!
	var people: Dictionary<String, Person>!
	var friends: Dictionary<String, Person>!
	
	init() {
		cards = []
		people = Dictionary()
		friends = Dictionary()
	}
	
	func load(completionHandler:(NSError?) -> Void) {
		var request : NSMutableURLRequest = NSMutableURLRequest()
		request.URL = NSURL(string: self.requestURL)
		request.HTTPMethod = "GET"
		
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
			completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
			if error != nil {
				completionHandler(error)
			} else {
				let responseStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
				println("RESPONSE: " + responseStr!)
				
				var error: NSError?
				var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
				
				var cardDicts: NSArray = dict["cards"] as NSArray
				for cardDict in cardDicts {
					let card = Card(dict: cardDict as NSDictionary)
					self.cards.append(card)
				}
				
				var peopleDicts: NSArray = dict["people"] as NSArray
				for personDict in peopleDicts {
					let person = Person(dict: personDict as NSDictionary)
					self.people[person.id] = person
				}
				
				completionHandler(nil)
			}
		})
	}
}
