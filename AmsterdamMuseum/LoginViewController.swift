//
//  ViewController.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 22-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	@IBOutlet var scrollView: UIScrollView!
	
	var loginView: LoginView!
	var splashView: SplashView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		let email = NSUserDefaults.standardUserDefaults().stringForKey("email")
		let name = NSUserDefaults.standardUserDefaults().stringForKey("name")
		
		splashView = SplashView.loadFromNibNamed("SplashView", bundle: nil, owner: self) as SplashView
		scrollView.addSubview(splashView)
		
		splashView.frame = CGRectMake(
			splashView.frame.origin.x,
			0,
			splashView.frame.size.width,
			splashView.frame.size.height)
		
		loginView = LoginView.loadFromNibNamed("LoginView", bundle: nil, owner: self) as LoginView
		scrollView.addSubview(loginView)
		
		loginView.frame = CGRectMake(
			loginView.frame.origin.x,
			view.frame.size.height,
			loginView.frame.size.width,
			loginView.frame.size.height)
		
		scrollView.contentSize = CGSizeMake(view.frame.size.width,
			view.frame.size.height * 2)

		loginView.emailField.text = email
		loginView.nameField.text = name
		
		// Validate fields - JBG
		textChanged(loginView.emailField)
		textChanged(loginView.nameField)
		
		if let image = Avatar.getAvatar() {
			showAvatar(image)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		self.view.hidden = false
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.view.hidden = true
	}
	
	@IBAction func textChanged(sender: AnyObject) {
		if sender as NSObject == loginView.emailField {
			loginView.validEmail.hidden = !validEmail(loginView.emailField.text)
		} else {
			loginView.validName.hidden = !validName(loginView.nameField.text)
		}
	}
	
	@IBAction func start() {
		if validName(loginView.nameField.text) && validEmail(loginView.emailField.text) {
			NSUserDefaults.standardUserDefaults().setObject(loginView.emailField.text, forKey: "email")
			NSUserDefaults.standardUserDefaults().setObject(loginView.nameField.text, forKey: "name")
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
		loginView.selfieView.layer.masksToBounds = true
		loginView.selfieView.layer.cornerRadius = loginView.selfieView.frame.size.height / 2
		
		loginView.selfieView.image = image
		loginView.selfieView.hidden = false
		loginView.takeSelfieView.hidden = true
		loginView.changeSelfieView.hidden = false
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

	// UITextFieldDelegate - JBG
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField == loginView.nameField {
			loginView.emailField.becomeFirstResponder()
		} else {
			loginView.emailField.resignFirstResponder()
		}
		return true
	}
}

