//
//  EventView.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 30-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class EventView: UIView {
	
	@IBOutlet var titleLabel: UILabel!
	
	func addPersonView(personView: PersonView) {
		
		personView.frame = CGRectMake(
			personView.frame.origin.x,
			self.frame.size.height,
			personView.frame.size.width,
			personView.frame.size.height)
		
		
		self.frame = CGRectMake(
			self.frame.origin.x,
			self.frame.origin.y,
			self.frame.size.width,
			self.frame.size.height + personView.frame.size.height)
		
		self.addSubview(personView)
		
	}
	

}