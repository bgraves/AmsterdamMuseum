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
	
	func addActionView() {
		var buttonFrame = CGRectMake(
			0,
			frame.size.height,
			frame.size.width,
			45)
		
		var button = UIButton(frame: buttonFrame)
		button.setTitle("Accept Invitation", forState: UIControlState.Normal)
		button.setTitleColor(UIColor(white: 78.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
		button.titleLabel!.font = UIFont(name: "OpenSans-Light", size: 17)

		addSubview(button)
		
		frame = CGRectMake(
			frame.origin.x,
			frame.origin.y,
			frame.size.width,
			frame.size.height + button.frame.size.height)
	}
	
	func addImageViews() {
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
		
		// TODO : Handle single images - JBG
		for i in 0...2 {
			var imageFrame = CGRectMake(
				CGFloat(i) * scrollView.frame.size.width - 10,
				0,
				scrollView.frame.size.width,
				scrollView.frame.size.height)
			var imageView = UIImageView(frame: imageFrame)
			scrollView.addSubview(imageView)
			
			var randomNumber : CGFloat = CGFloat(rand()) % (255 - 1)
			imageView.backgroundColor = UIColor(white: randomNumber/255, alpha: 1.0)
			
		}
		
		scrollView.contentSize = CGSizeMake(
			3 * scrollView.frame.size.width - 10,
			scrollView.frame.size.height)
	}
	
	func addLikeView() {
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
		addSubview(likeView)
		
		
	}
	
}
