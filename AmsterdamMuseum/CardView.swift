//
//  CardView.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 26-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
	
	var card: Card!
	
	var actionButton: UIButton?
	
	func addActionView(target: AnyObject?, action: Selector, title: String) {
		var buttonFrame = CGRectMake(
			0,
			frame.size.height,
			frame.size.width,
			45)
		
		var button = UIButton(frame: buttonFrame)
		
		button.setTitleColor(UIColor(white: 78.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
		button.titleLabel!.font = UIFont(name: "OpenSans-Light", size: 17)
		
		self.actionButton = button
		
		switch action {
			default:
				button.setTitle(title, forState: UIControlState.Normal)
				button.addTarget(target, action: action, forControlEvents:.TouchUpInside)
		}

		addSubview(button)
		
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + button.frame.size.height)
	}
	
	func addHeaderView() {
		var headerView = UIView.loadFromNibNamed("CardHeaderView") as CardHeaderView
		headerView.dateLabel.text = card?.date
		headerView.frame = CGRectMake(
			0,
			0,
			frame.size.width,
			headerView.frame.size.height)
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + headerView.frame.size.height)
		addSubview(headerView)
	}
	
	func addImageViews() {
		// Just return if there are no images - JBG
		if card.images.count == 0 { return }
		
		var scrollFrame = CGRectMake(
			0,
			frame.size.height,
			frame.size.width,
			247)
		var scrollView = UIScrollView(frame: scrollFrame)
		scrollView.backgroundColor = UIColor.blackColor()
		scrollView.pagingEnabled = true
		
		addSubview(scrollView)
		
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + scrollView.frame.size.height)
		
		// Add images - JBG
		if let images = card?.images {
			var padding: CGFloat = (images.count > 1 ? 10.0 : 0.0)
			for (i, urlStr) in enumerate(images) {
				var imageFrame = CGRectMake(
					CGFloat(i) * scrollView.frame.size.width - padding,
					0,
					scrollView.frame.size.width,
					scrollView.frame.size.height)
				var imageView = UIImageView(frame: imageFrame)
				
				// Load the image - JBG
				if let imageStr = urlStr.pathComponents.last {
					imageView.image = UIImage(named: imageStr)
				}
				
				scrollView.addSubview(imageView)
			}
			scrollView.contentSize = CGSizeMake(
				CGFloat(images.count) * scrollView.frame.size.width - padding,
				scrollView.frame.size.height)
		}
	}
	
	func addLikeViews(friends: Dictionary<String, Person>) {
		if let likes = card?.likes {
			for personId in likes {
				if let person = friends[personId] {
					addLikeView(person)
				}
			}
		}
	}
	
	private func addLikeView(person: Person) {
		let likeHeight = CGFloat(60)
		var x: CGFloat = frame.size.width / 3;
		var likeView = UIView.loadFromNibNamed("LikeView") as LikeView
		likeView.frame = CGRectMake(
			x,
			frame.size.height,
			x * 2,
			likeHeight)
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + likeHeight)
		
		// Load the image - JBG
		if let data = NSData(contentsOfURL: NSURL(string: person.avatarUrl)!) {
			likeView.avatarView.image = UIImage(data: data)
		}
		
		likeView.titleLabel.text = person.name + "likes this"
		addSubview(likeView)
	}
	
	func addUserView() {
		var userView = UIView.loadFromNibNamed("UserView") as UserView
		userView.frame = CGRectMake(
			0,
			frame.size.height,
			frame.size.width,
			userView.frame.size.height)
		
		userView.titleLabel.text = card?.title.uppercaseString
		userView.subtitleLabel.text = card?.subtitle
		
		userView.avatarView.layer.masksToBounds = true
		userView.avatarView.layer.cornerRadius = userView.avatarView.frame.size.height / 2

		if let imageStr = card?.avatarUrl {
			userView.avatarView.image = UIImage(named: imageStr)
		}
		
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + userView.frame.size.height)
		
		addSubview(userView)
	}
}
