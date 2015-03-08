//
//  BeaconTracker.swift
//  AmsterdamMuseum
//
//  Created by James Bryan Graves on 19/02/15.
//  Copyright (c) 2015 James Bryan Graves. All rights reserved.
//

import CoreLocation
import Foundation

class Beacon {
	var uuid: String!
	var major: String!
	var minor: String!
	
	convenience init(dict: NSDictionary) {
		self.init()
		uuid = dict["uuid"] as String
		major = dict["major"] as String
		minor = dict["minor"] as String
	}
	
}

class BeaconZonePresence : NSObject {
	var startTime: NSDate!
	var endTime: NSDate?
}

class BeaconZone {
	
	var beacons = [Beacon]()
	var name: String!
	
	var times = [BeaconZonePresence]()

	var currentTime: NSTimeInterval {
		get {
			var time: NSTimeInterval = 0
			for var i = 0; i < times.count; i++ {
				if let endTime = times[i].endTime {
					time += endTime.timeIntervalSinceDate(times[i].startTime)
				} else {
					time += NSDate().timeIntervalSinceDate(times[i].startTime)
				}
			}
			return time
		}
	}

	// For tracking - JBG
	var rangedBeacons = [Beacon]()
	var proximityScore = 0
	var accuracyScore = 0.0
	
	convenience init(name: String, dict: NSDictionary) {
		self.init()
		self.name = name
		if let beaconDicts = dict["beacons"] as? NSArray {
			for beaconDict in beaconDicts {
				beacons.append(Beacon(dict: beaconDict as NSDictionary))
			}
		}
	}
	
	func evaluate(clBeacon: CLBeacon) {
		for beacon in beacons {
			if clBeacon.minor.stringValue == beacon.minor &&
				clBeacon.proximityUUID.UUIDString == beacon.uuid &&
				clBeacon.proximity != .Unknown {
					rangedBeacons.append(beacon)
					
					if clBeacon.proximity == .Unknown {
						proximityScore += Int.max
					} else  {
						proximityScore += clBeacon.proximity.rawValue
					}
					
					accuracyScore += clBeacon.accuracy
			}
		}
	}
	
	func valid() -> Bool {
		return rangedBeacons.count == beacons.count
	}
	
	func reset() {
		rangedBeacons = [Beacon]()
		proximityScore = 0
		accuracyScore = 0.0
	}
}

protocol BeaconTrackerDelegate {
	func inZone(zone: BeaconZone?) -> Void
}

class BeaconTracker : NSObject, CLLocationManagerDelegate {
	
	var delegate: BeaconTrackerDelegate?
	var locationManager: CLLocationManager!
	
	var regionUUIDStrs = [String]()
	var zones: [BeaconZone]!
	
	override init() {
		super.init()
		locationManager = CLLocationManager()
		locationManager.delegate = self
		if locationManager.respondsToSelector("requestAlwaysAuthorization") {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	func start(zones: [BeaconZone]) {
		self.zones = zones
		
		for zone in zones {
			for beacon in zone.beacons {
				if !contains(regionUUIDStrs, beacon.uuid) {
					if let uuid = NSUUID(UUIDString: beacon.uuid) {
						let region = CLBeaconRegion(proximityUUID: uuid, identifier: zone.name + "." + beacon.uuid)
						if !locationManager.rangedRegions.containsObject(region) {
							locationManager.startMonitoringForRegion(region)
						}
						locationManager.startRangingBeaconsInRegion(region)
						regionUUIDStrs.append(beacon.uuid)
					}
				}
			}
		}
	}
	
	// CLLocationManagerDelegate - JBG
	func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
		println("didEnterRegion")
	}
	
	func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
		println("didExitRegion")
	}
	
	func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
		
		for zone in zones {
			zone.reset()
		}

		for beacon in beacons {
			for zone in zones {
				zone.evaluate(beacon as CLBeacon)
			}
		}
		
		var validZones = [BeaconZone]()
		for zone in zones {
			if zone.valid() { validZones.append(zone) }
		}
		
		if validZones.count == 1 {
			var zone = validZones[0]
			delegate?.inZone(zone)
		} else if validZones.count > 1 {
			var winningZone: BeaconZone? = nil
			for zone in validZones {
				if winningZone == nil {
					winningZone = zone
				} else {
					var z = zone as BeaconZone
					if z.proximityScore < winningZone?.proximityScore {
						winningZone = z
					} else if z.proximityScore == winningZone?.proximityScore &&
						z.accuracyScore < winningZone?.accuracyScore {
						winningZone = z
					}
				}
			}
			delegate?.inZone(winningZone?)
		}
	}
	
	func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
		locationManager.startRangingBeaconsInRegion(region as CLBeaconRegion)
	}
}
