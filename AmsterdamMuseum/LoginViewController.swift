//
//  ViewController.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 22-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet var loginViewConstraint: NSLayoutConstraint!
	@IBOutlet var loginForm: UIView!
	@IBOutlet var loginView: UIView!
	@IBOutlet var startView: UIView!
	@IBOutlet var nameField: UITextField!
	@IBOutlet var emailField: UITextField!
	@IBOutlet var validEmail: UIView!
	@IBOutlet var validName: UIView!
	
	@IBOutlet var selfieView: UIImageView!
	@IBOutlet var takeSelfieView: UIView!
	@IBOutlet var changeSelfieView: UIButton!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
		let name = NSUserDefaults.standardUserDefaults().stringForKey("name")

		
		emailField.text = email
		nameField.text = name
		
		// Validate fields - JBG
		textChanged(emailField)
		textChanged(nameField)
		
		var image = Avatar.getAvatar()
		if image != nil {
			showAvatar(image!)
		}
		
		self.loginViewConstraint.constant = self.view.frame.size.height - self.startView.frame.size.height
		UIView.animateWithDuration(0.5, animations: { () in
			self.view.layoutIfNeeded()
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func start() {
		self.loginViewConstraint.constant = -self.startView.frame.size.height
		UIView.animateWithDuration(0.5, animations: { () in
			self.view.layoutIfNeeded()
		})
	}
	
	@IBAction func textChanged(sender: AnyObject) {
		if sender as NSObject == emailField {
			validEmail.hidden = !validEmail(emailField.text)
		} else {
			validName.hidden = !validName(nameField.text)
		}
	}
	
	@IBAction func go() {
		if validName(nameField.text) && validEmail(emailField.text) {
			NSUserDefaults.standardUserDefaults().setObject(emailField.text, forKey: "email")
			NSUserDefaults.standardUserDefaults().setObject(nameField.text, forKey: "name")
			self.loginView.hidden = true
			self.performSegueWithIdentifier("toNews", sender: self)
		}
	}
	
	@IBAction func takeSelfie() {
		var imagePicker = UIImagePickerController()
		imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
		imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
		imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
		imagePicker.delegate = self
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func showAvatar(image: UIImage) {
		self.selfieView.image = image
		self.selfieView.hidden = false
		self.takeSelfieView.hidden = true
		self.changeSelfieView.hidden = false
	}
	
	func validEmail(emailStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		let result = emailTest?.evaluateWithObject(emailStr)
		return result!
	}
	
	func validName(nameStr:String) -> Bool {
		let nameRegEx = "[A-Z0-9a-z._%+-]+"
		var nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
		let result = nameTest?.evaluateWithObject(nameStr)
		return result!
	}
	
	// UIImagePickerControllerDelegate - JBG
	func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
		var image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
		self.dismissViewControllerAnimated(true, completion: {
			self.showAvatar(image)
			Avatar.saveAvatar(image)
		})
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

