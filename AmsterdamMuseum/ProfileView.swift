//
//  ProfileView.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 30-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class ProfileView : UIView {
	
	let labelHeight:CGFloat = 21.0
	
	@IBOutlet var keyValueViews: UIView!
	
	func addKeyValue(key: String, value: String) {
		keyValueViews.backgroundColor = UIColor.whiteColor()
		
		keyValueViews.frame = CGRectMake(
			keyValueViews.frame.origin.x,
			keyValueViews.frame.origin.y,
			self.frame.size.width,
			keyValueViews.frame.size.height + labelHeight)
		
		var keyLabel = UILabel(frame: CGRectMake(
			0.0,
			keyValueViews.frame.size.height - labelHeight,
			keyValueViews.frame.size.width / 3,
			labelHeight))
		keyLabel.text = key
		keyLabel.textAlignment = .Right
		keyValueViews.addSubview(keyLabel)
		
		var valueLabel = UILabel(frame: CGRectMake(
			keyLabel.frame.size.width + (xSpacer * 2),
			keyValueViews.frame.size.height - labelHeight,
			((keyValueViews.frame.size.width / 3) * 2) - (xSpacer * 2),
			labelHeight))
		valueLabel.text = value
		keyValueViews.addSubview(valueLabel)
		

		
		self.frame = CGRectMake(
			self.frame.origin.x,
			self.frame.origin.y,
			self.frame.size.width,
			self.frame.size.height + labelHeight)
	}
}