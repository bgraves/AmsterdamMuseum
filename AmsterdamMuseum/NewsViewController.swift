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
	
	@IBOutlet var avatarView: UIImageView?
	@IBOutlet var nameLabel: UILabel?
	
	var cardViews: [UIView]!
	var displayedCards: NSMutableArray!
	var newsFeed: NewsFeed!
	var profileView: ProfileView?
	
	// Handle User specific timelines - JBG
	var user: Person?
	var viewFriend: Person?
	
	// Card timer - JBG
	var timer: NSTimer?

	override func viewDidLoad() {
		
		cardViews = []
		displayedCards = NSMutableArray()
		
		if let avatarView = self.avatarView {
			avatarView.layer.masksToBounds = true
			avatarView.layer.cornerRadius = avatarView.frame.size.height / 2
			avatarView.image = Avatar.getAvatar()
		}
		
		if let nameLabel = self.nameLabel {
			nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("name")!.uppercaseString
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		if self.cardViews.count == 0 {
			// Reset the feed - JBG
			reset()
			
			// Reload - JBG
			addShieldView()
			newsFeed = NewsFeed()
			newsFeed.load({ (error: NSError?) in
				if error != nil {
					self.shieldView.setMessage("ERROR LOADING NEWS FEED :(")
				} else {
					if let user = self.user {
						self.addProfileView(user)
					}
					self.evaluateCards()
				}
				
				// Start tracking the beacons - JBG
				(UIApplication.sharedApplication().delegate as AppDelegate).beaconTracker.start(self.newsFeed.zones)
			})
		} else {
			self.evaluateCards()
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		timer?.invalidate()
	}
	
	// Add custom views based on cards - JBG
	
	func addCardView(card: Card, position: CGFloat) {
		var cardView = CardView(frame: CGRectMake(
			xSpacer,
			position,
			scrollView.frame.size.width - (xSpacer * 2),
			0))
		cardView.card = card
		self.scrollView.addSubview(cardView)
		
		let friends = (UIApplication.sharedApplication().delegate as AppDelegate).friends
		
		cardView.addHeaderView()
		cardView.addUserView()
		cardView.addLikeViews(friends)
		cardView.addImageViews()
		
		if user == nil {
			if let friendRequest = card.friendRequest {
				if let friend = friends[friendRequest] {
					cardView.addActionView(self, action: "toTimeline:", title: "View \(card.title)'s timeline")
				} else {
					cardView.addActionView(self, action: "addFriend:", title: "Accept Invitation")
				}
			}
		}
		addDropShadow(cardView)
		
		shiftViews(cardView.frame.size.height + ySpacer)
		adjustContentSize(cardView)
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
	
	func addEventView(card: Card, position: CGFloat) {
		var eventView = UIView.loadFromNibNamed("EventView") as EventView
		self.scrollView.addSubview(eventView)
		
		for i in 1...3 {
			var personView = PersonView.loadFromNibNamed("PersonView") as PersonView
			eventView.addPersonView(personView)
		}

		eventView.frame = CGRectMake(
			eventView.frame.origin.x + xSpacer,
			position,
			scrollView.frame.size.width - (xSpacer * 2),
			eventView.frame.size.height)
		
		addDropShadow(eventView)
		
		shiftViews(eventView.frame.size.height + ySpacer)
		adjustContentSize(eventView)
		cardViews.append(eventView)
	}
	

	func addProfileView(user: Person!) {
		var profileView = UIView.loadFromNibNamed("ProfileView") as ProfileView
		self.scrollView.addSubview(profileView)
		
		profileView.frame = CGRectMake(
			profileView.frame.origin.x + xSpacer,
			ySpacer,
			scrollView.frame.size.width - (xSpacer * 2),
			profileView.frame.size.height)
		
		profileView.nameLabel.text = user.name
		
		profileView.avatarView.image = UIImage(named: user.avatarUrl)
		profileView.avatarView.layer.masksToBounds = true
		profileView.avatarView.layer.cornerRadius = profileView.avatarView.frame.size.height / 2

		for (key, val) in user.info {
			profileView.addKeyValue("\(key)", value: "\(val)")
		}
		
		shiftViews(profileView.frame.size.height + ySpacer)
		adjustContentSize(profileView)
		self.profileView = profileView
	}
	
	func addShieldView() {
		shieldView = CardView.loadFromNibNamed("ShieldView") as ShieldView
		scrollView.addSubview(self.shieldView)
		shieldView.frame = view.frame
		cardViews.append(shieldView)
	}
	
	// Actions - JBG
	
	func addFriend(sender: AnyObject?) {
		if let button = sender as? UIButton {
			if let cardView = button.superview as? CardView {
				if let personId = cardView.card?.friendRequest {
					if let person = newsFeed.people[personId] {
						(UIApplication.sharedApplication().delegate as AppDelegate).friends[personId] = person
						println("NEW FRIEND: \(personId)")
					}
				}
				if let name = cardView.card?.title {
					button.setTitle("View \(name)'s timeline", forState: UIControlState.Normal)
					button.addTarget(self, action: "toTimeline:", forControlEvents: .TouchUpInside)
				}
			}
		}
	}
	
	// Handle friend news feeds - JBG
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toUserFeed" {
			(segue.destinationViewController as NewsViewController).user = viewFriend
		}
	}
	
	func toTimeline(sender: UIButton) {
		if let cardView = sender.superview as? CardView {
			if let friendId = cardView.card.friendRequest {
				if let user = newsFeed.people[friendId] {
					viewFriend = user
					performSegueWithIdentifier("toUserFeed", sender: self)
				}
			}
		}
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
		println("evaluateCards")
		dispatch_async(dispatch_get_main_queue(), { [unowned self] in
			let startTime = (UIApplication.sharedApplication().delegate as AppDelegate).startTime
			let zones = (UIApplication.sharedApplication().delegate as AppDelegate).zones
			
			var friends = (UIApplication.sharedApplication().delegate as AppDelegate).friends
			
			// If we are trying view a user timeline, just show his cards - JBG
			if let user = self.user {
				friends = [user.id: user]
			}
			
			let time = NSDate().timeIntervalSinceDate(startTime)
			for card: Card in self.newsFeed.cards {
				if self.displayedCards.containsObject(card) ||
					!card.show(friends, zones: zones, time: time) {
					continue
				}
				
				var position = ySpacer
				if let profileView = self.profileView {
					position += profileView.frame.size.height + ySpacer
				}
				
				switch card.layout as CardLayout {
				case .Event:
					self.addEventView(card, position: position)
				default:
					self.addCardView(card, position: position)
				}
				self.displayedCards.addObject(card)
			}
			self.view.setNeedsLayout()
			self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "evaluateCards", userInfo: nil, repeats: false)
		})
	}
	
	func shiftViews(amount: CGFloat) {
		for cardView in cardViews {
			cardView.frame = CGRectMake(
				cardView.frame.origin.x,
				cardView.frame.origin.y + amount,
				cardView.frame.size.width,
				cardView.frame.size.height
			)
		}
	}
	
	func reset() {
		displayedCards.removeAllObjects()
		for view in cardViews {
			view.removeFromSuperview()
		}
		self.scrollView.frame = view.frame
		self.scrollView.contentSize = self.scrollView.frame.size
	}
	
}