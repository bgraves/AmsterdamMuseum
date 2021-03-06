//
//  AppDelegate.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 22-01-15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BeaconTrackerDelegate {

	var window: UIWindow?
	
	// Manange cache & zip - JBG
	let cacheUtils = CacheUtils()
	
	// Monitor for beacons - JBG
	var beaconTracker: BeaconTracker = BeaconTracker()
	
	// State stuff - JBG
	var currentZone: BeaconZone?
	var friends: Dictionary<String, Person> = Dictionary()
	var zones: Dictionary<String, BeaconZone> = Dictionary()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		Fabric.with([Crashlytics()])
		
		var cacheInitialized = NSUserDefaults.standardUserDefaults().boolForKey("cacheInitialized")
		if !cacheInitialized {
			cacheUtils.initializeCache(["png", "json"])
			NSUserDefaults.standardUserDefaults().setObject(true, forKey: "cacheInitialized")
		}
	
		// Override point for customization after application launch.
		beaconTracker.delegate = self
		
		cacheUtils.downloadZip({ (success: Bool) in
			println("Updated cache: \(success)")
		})
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	// BeaconTrackerDelegate - JBG
	
	func inZone(zone: BeaconZone?) -> Void {
		if let zoneName = zone?.name {
			if let currentZoneName = currentZone?.name {
				if zoneName != currentZoneName {
					println("Exit \(currentZoneName), Enter \(zoneName)")
					if var time = currentZone?.times.last {
						time.endTime = NSDate()
					}
					
					var presence = BeaconZonePresence()
					presence.startTime = NSDate()
					zone?.times.append(presence)
					currentZone = zone
				}
			} else {
				var presence = BeaconZonePresence()
				presence.startTime = NSDate()
				zone?.times.append(presence)
				currentZone = zone
			}
		}
	}
}

