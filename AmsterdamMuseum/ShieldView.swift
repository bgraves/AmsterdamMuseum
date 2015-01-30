//
//  ShieldView.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 28-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class ShieldView : UIView {
	
	@IBOutlet var label: UILabel!
	
	func setMessage(str: String) {
		self.label.text = str;
	}
	
}