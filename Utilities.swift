//
//  Utilities.swift
//  Soneca-Bus
//
//  Created by Allan Melo on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import MapKit

func showSimpleAlertWithTitle(
	title: String, message: String, viewController: UIViewController) {
	let alert = UIAlertController(
		title: title, message: message, preferredStyle: .Alert)

	let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
	alert.addAction(action)
	
	viewController.presentViewController(alert, animated: true, completion: nil)
}

func getLocatioManager() -> CLLocationManager {
	let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

	return delegate.locationManager
}

func regionWithGeotification(geonotification: GeoNotification)
	-> CLCircularRegion {

	let region = CLCircularRegion(
		center: geonotification.coordinate, radius: geonotification.radius,
		identifier: geonotification.identifier)

	region.notifyOnEntry = (geonotification.eventType == .OnEntry)
	region.notifyOnExit = !region.notifyOnEntry

	return region
}

func saveAllGeotifications(geonotifications: [GeoNotification]) {
	let items = NSMutableArray()
	for geonotication in geonotifications {
		let item = NSKeyedArchiver.archivedDataWithRootObject(geonotication)
		items.addObject(item)
	}

	NSUserDefaults.standardUserDefaults().setObject(
		items, forKey: kSavedItemsKey)

	NSUserDefaults.standardUserDefaults().synchronize()
}