//
//  BusStopAnnotation.swift
//  Soneca-Bus
//
//  Created by Allan Melo on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

class BusStopAnnotation : NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?

	init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
	}
}