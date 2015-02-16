//
//  SettingsViewController.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 16/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController {
	
	override func viewDidLoad() {
		addHeaderView()
		addFooterView()
		self.tableView.rowHeight = 97
	}
	
	override func viewDidAppear(animated: Bool) {
	
	}
	
	func addFooterView() {
		var footerView = UIView.loadFromNibNamed("SponsorsView") as UIView?
		self.tableView.tableFooterView = footerView
	}
	
	func addHeaderView() {
		var profileView = UIView.loadFromNibNamed("SettingsProfileView") as ProfileView
		
		profileView.avatarView.layer.masksToBounds = true
		profileView.avatarView.layer.cornerRadius = profileView.avatarView.frame.size.height / 2
		
		profileView.avatarView.image = Avatar.getAvatar()
		profileView.nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("name")!.uppercaseString
		
		self.tableView.tableHeaderView = profileView
	}
	
	// UITableViewControllerDataSource & UITableViewControllerDelegate - JBG
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Your network"
		default:
			return "Settings"
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 3
		default:
			return 1
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
			return cell
		default:
			let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as UITableViewCell
			(cell.viewWithTag(1) as UIImageView).image = Avatar.getAvatar()
			(cell.viewWithTag(2) as UILabel).text = NSUserDefaults.standardUserDefaults().stringForKey("name")?.uppercaseString
			(cell.viewWithTag(3) as UILabel).text = NSUserDefaults.standardUserDefaults().stringForKey("email")?.uppercaseString
			return cell
		}
		
	}
	
}