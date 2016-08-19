//
//  AppDelegate.swift
//  Soneca-Bus
//
//  Created by Allan Melo on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import CoreLocation

let kSavedItemsKey = "savedItems"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
	CLLocationManagerDelegate {

	var window: UIWindow?
	let locationManager = CLLocationManager()
	var geonotifications = [GeoNotification]()

	func application(
		application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
		-> Bool {

		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()

		geonotifications = getSavedGeonotifications()

		let settings = UIUserNotificationSettings(
			forTypes: [.Sound, .Alert, .Badge], categories: nil)

		application.registerUserNotificationSettings(settings)
		UIApplication.sharedApplication().cancelAllLocalNotifications()

		return true
	}

	func handleRegionEvent(region: CLRegion) {
		let application = UIApplication.sharedApplication()
		let state = application.applicationState

		if  (state == .Active) {
			if let message = notefromRegionIdentifier(region.identifier) {
				if let viewController = window?.rootViewController {
					showSimpleAlertWithTitle(
						"", message: message, viewController: viewController)
				}
			}
		}
		else {
			let notification = UILocalNotification()
			notification.alertBody = notefromRegionIdentifier(region.identifier)
			notification.soundName = "Default";
			application.presentLocalNotificationNow(
				notification)
		}
	}

	func locationManager(
		manager: CLLocationManager, didEnterRegion region: CLRegion) {

		if region is CLCircularRegion {
			handleRegionEvent(region)
		}
	}

	func locationManager(
		manager: CLLocationManager, didExitRegion region: CLRegion) {

		if region is CLCircularRegion {
			handleRegionEvent(region)
		}
	}

	func notefromRegionIdentifier(identifier: String) -> String? {
		let items = geonotifications.filter { (geonotification) -> Bool in
			return geonotification.identifier == identifier
		}

		if (!items.isEmpty) {
			return items.first?.note
		}
		
		return nil
	}

	func getSavedGeonotifications() -> [GeoNotification] {
		var geonotifications = [GeoNotification]()

		if let savedItems =
			NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {

			for savedItem in savedItems {
				guard let savedItem = savedItem as? NSData else {
					break
				}

				if let geonotification =
					NSKeyedUnarchiver.unarchiveObjectWithData(savedItem)
						as? GeoNotification {

					geonotifications.append(geonotification)
				}
			}
		}

		return geonotifications
	}

	func addGeonotification(geonotification: GeoNotification) {
		geonotifications.append(geonotification)

		saveAllGeotifications(geonotifications)
	}

}

