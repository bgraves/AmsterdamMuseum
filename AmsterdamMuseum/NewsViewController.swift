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
	class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
		return UINib(
			nibName: nibNamed,
			bundle: bundle
			).instantiateWithOwner(nil, options: nil)[0] as? UIView
	}
}

class NewsViewController : UIViewController {
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var shieldView: ShieldView!
	
	@IBOutlet var avatarView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	
	override func viewDidLoad() {
		avatarView.image = Avatar.getAvatar()
		nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("name")!.uppercaseString
	}
	
	override func viewDidLayoutSubviews() {
		addShieldView()
		addProfileView()
		addCardViews()
		addEventView()
	}
	
	func addCardViews() {
		
		// TODO: Loop through cards - JBG
		for i in 1...3 {
			addCardView()
		}
		// TODO: End loop - JBG
	
	}
	
	func addCardView() {
		var cardView = CardView.loadFromNibNamed("CardView") as CardView
		
		cardView.frame = CGRectMake(
			xSpacer,
			(self.scrollView.contentSize.height - self.scrollView.frame.size.height) + ySpacer,
			scrollView.frame.size.width - (xSpacer * 2),
			cardView.frame.size.height)

		self.scrollView.addSubview(cardView)
		
		cardView.addImageViews()
		cardView.addActionView()
		cardView.addLikeView()
		
		addDropShadow(cardView)
		
		adjustContentSize(cardView)
		moveShieldView()
		
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
	
	func addEventView() {
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
		
	}
	
	func addShieldView() {
		self.shieldView = CardView.loadFromNibNamed("ShieldView") as ShieldView
		self.shieldView.frame = CGRectMake(
			xSpacer,
			self.view.frame.origin.y,
			self.view.frame.size.width - (xSpacer * 2),
			self.view.frame.size.height);
		self.scrollView.addSubview(self.shieldView)
		
		adjustContentSize(shieldView)
	}
	
	func adjustContentSize(view: UIView) {
		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
			self.scrollView.contentSize.height + view.frame.size.height + ySpacer)
	}
	
	func moveShieldView() {
		// Move the shield view - JBG
		self.shieldView.frame = CGRectMake(
			self.shieldView.frame.origin.x,
			self.scrollView.contentSize.height - self.shieldView.frame.size.height,
			self.shieldView.frame.size.width,
			self.shieldView.frame.size.height)
	}
	
}