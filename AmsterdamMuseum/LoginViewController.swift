//
//  ViewController.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 22-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet var loginForm: UIView!
	@IBOutlet var loginView: UIView!
	@IBOutlet var startView: UIView!
	@IBOutlet var nameField: UITextField!
	@IBOutlet var emailField: UITextField!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		self.loginView.frame = CGRectMake(
			self.loginView.frame.origin.x,
			self.view.frame.size.height - self.startView.frame.size.height,
			self.loginView.frame.size.width,
			self.loginView.frame.size.height + self.startView.frame.size.height)
	}
	
	@IBAction func start() {
		UIView.animateWithDuration(0.5, animations: {
			self.loginView.frame = CGRectMake(
				self.loginView.frame.origin.x,
				-self.startView.frame.size.height,
				self.loginView.frame.size.width,
				self.loginView.frame.size.height)
		})
	}
	
	@IBAction func go() {
		self.loginView.hidden = true
		self.performSegueWithIdentifier("toNews", sender: self)
	}
}

