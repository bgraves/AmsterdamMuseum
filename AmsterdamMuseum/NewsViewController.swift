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
let ySpacer: CGFloat = 40
let yPadding: CGFloat = 8

class NewsViewController : UIViewController {
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var shieldView: UIView!
	
	override func viewDidAppear(animated: Bool) {
		
		addCardViews()
		
	}
	
	func addCardViews() {
		var y: CGFloat = ySpacer
		var count = 1
		
		// TODO: Loop through cards - JBG
		
		// TODO : Card stuff - JBG
		var actionable = false
		
		
		var cardView:CardView = NSBundle.mainBundle().loadNibNamed("CardView", owner: nil, options: nil)[0] as CardView
		var cardHeight:CGFloat = 0
		
		if actionable {
			cardHeight = cardView.actionButton.frame.origin.y + cardView.actionButton.frame.size.height + yPadding
		} else {
			cardHeight = cardView.actionButton.frame.origin.y - yPadding
			cardView.actionButton.hidden = true
		}
		
		cardView.frame = CGRectMake(
			xSpacer,
			y,
			scrollView.frame.size.width - (xSpacer * 2),
			cardHeight)
		
		self.scrollView.addSubview(cardView)
		
		// TODO: End loop - JBG
		
		self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
			((y + cardView.frame.size.height) * CGFloat(count)) + y);
	}
	
}