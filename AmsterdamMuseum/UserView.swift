//
//  UserView.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 28-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class UserView : UIView {
	
	var nibName = "UserView"
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		var view: UIView = UINib(
			nibName: nibName,
			bundle: nil
			).instantiateWithOwner(self, options: nil)[0] as UIView
		view.frame = bounds
		view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

		addSubview(view)
	}
	
}
