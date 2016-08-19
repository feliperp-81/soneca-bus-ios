//
//  BusStopAnnotation.swift
//  Soneca-Bus
//
//  Created by Allan Melo on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import CoreLocation
import MapKit

class BusStopAnnotation : NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	var busStop: BusStop

	init(
		coordinate: CLLocationCoordinate2D, title: String,
		subtitle: String? = nil, busStop: BusStop) {

		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		self.busStop = busStop
	}
}