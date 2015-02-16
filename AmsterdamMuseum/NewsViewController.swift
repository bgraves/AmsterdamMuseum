//
//  NewsFeedViewController.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 26-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

let xSpacer: CGFloat = 10
let ySpacer: CGFloat = 20
let yPadding: CGFloat = 8

extension UIView {
	class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil, owner: AnyObject? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
			).instantiateWithOwner(owner, options: nil)[0] as? UIView
	}
}

class NewsViewController : UIViewController {
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var shieldView: ShieldView!
	
	@IBOutlet var avatarView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	
	var newsFeed: NewsFeed!
	var friends: Dictionary<String, Person>!
	var zones: [String]!
	var time = 0
	
	var cardViews: [UIView]!
	
	override func viewDidLoad() {
		friends = Dictionary()
		cardViews = []
		zones = []
		
		avatarView.image = Avatar.getAvatar()
		nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("name")!.uppercaseString
	}
	
	override func viewDidAppear(animated: Bool) {
		// Reset the feed - JBG
		reset()
		
		// Reload - JBG
		addShieldView()
		newsFeed = NewsFeed()
		newsFeed.load({ (error: NSError?) in
			if error != nil {
				self.shieldView.setMessage("ERROR LOADING NEWS FEED :(")
			} else {
				self.evaluateCards()
			}
		})
	}
	
	// Add custom views based on cards - JBG
	
	func addCardView(card: Card) {
		var cardView = CardView(frame: CGRectMake(
			xSpacer,
			(self.scrollView.contentSize.height - self.scrollView.frame.size.height) + ySpacer,
			scrollView.frame.size.width - (xSpacer * 2),
			0))
		cardView.card = card
		self.scrollView.addSubview(cardView)
		
		cardView.addHeaderView()
		cardView.addUserView()
		cardView.addLikeViews(friends)
		cardView.addImageViews()
		
		if let friendRequest = card.friendRequest {
			cardView.addActionView(self, action: "addFriend:")
		}
		
		addDropShadow(cardView)
		
		adjustContentSize(cardView)
		moveShieldView()
		
		cardViews.append(cardView)
	}
	
	func addDropShadow(view: UIView) {
		var layer = view.layer
		layer.shadowColor = UIColor.darkGrayColor().CGColor
		layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 1.0).CGPath
		layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
		layer.masksToBounds = true
		view.clipsToBounds = false
	}
	
	func addEventView(card: Card) {
		var eventView = UIView.loadFromNibNamed("EventView") as EventView
		self.scrollView.addSubview(eventView)
		
		for i in 1...3 {
			var personView = PersonView.loadFromNibNamed("PersonView") as PersonView
			eventView.addPersonView(personView)
		}
		
		eventView.frame = CGRectMake(
			eventView.frame.origin.x + xSpacer,
			shieldView.frame.origin.y + ySpacer,
			scrollView.frame.size.width - (xSpacer * 2),
			eventView.frame.size.height)
		
		addDropShadow(eventView)
		
		adjustContentSize(eventView)
		moveShieldView()
		
		cardViews.append(eventView)
	}
	

	func addProfileView() {
		var profileView = UIView.loadFromNibNamed("ProfileView") as ProfileView
		self.scrollView.addSubview(profileView)
		
		profileView.frame = CGRectMake(
			profileView.frame.origin.x + xSpacer,
			shieldView.frame.origin.y + ySpacer,
			scrollView.frame.size.width - (xSpacer * 2),
			profileView.frame.size.height)

		for i in 1...3 {
			profileView.addKeyValue("\(i)", value: "\(i)")
		}
		
		adjustContentSize(profileView)
		moveShieldView()
		
		cardViews.append(profileView)
	}
	
	func addShieldView() {
		self.shieldView = CardView.loadFromNibNamed("ShieldView") as ShieldView
		self.scrollView.addSubview(self.shieldView)
		self.shieldView.frame = view.frame
		cardViews.append(shieldView)
	}
	
	// Actions - JBG
	
	func addFriend(sender: AnyObject?) {
//		if let personId = cardView.card?.friendRequest {
//			if let person = newsFeed.people[personId] {
//				newsFeed.friends[personId] = person
//			}
//		}
//		var name = cardView.card?.title
		//sender.updateActionButton("View \(name)'s timeline", target: self, action: "toTimeline:")
		(sender as UIButton).setTitle("WTF", forState: UIControlState.Normal)
	}
	
	func toTimeline(cardView: CardView) {
		// TODO : push filtered news feed - JBG
	}
	
	@IBAction func toSettings(sender: UIButton) {
		self.performSegueWithIdentifier("toSettings", sender: sender)
	}
	
	// Helper functions - JBG
	
	func adjustContentSize(view: UIView) {
		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
			self.scrollView.contentSize.height + view.frame.size.height + ySpacer)
	}
	
	func evaluateCards() {
		dispatch_async(dispatch_get_main_queue(), {
			for card: Card in self.newsFeed.cards {
				// Determine if a card is visable - JBG
				if !card.show(self.friends, zones: self.zones, time: self.time) {
					continue
				}
				switch card.layout as CardLayout {
				case .Event:
					self.addEventView(card)
				default:
					self.addCardView(card)
				}
			}
			self.view.setNeedsLayout()
		})
	}
	
	func moveShieldView() {
		// Move the shield view - JBG
		self.shieldView.frame = CGRectMake(
			self.shieldView.frame.origin.x,
			self.scrollView.contentSize.height - self.shieldView.frame.size.height,
			self.shieldView.frame.size.width,
			self.shieldView.frame.size.height)
	}
	
	func reset() {
		for view in cardViews {
			view.removeFromSuperview()
		}
		self.scrollView.frame = view.frame
		self.scrollView.contentSize = self.scrollView.frame.size
	}
	
}