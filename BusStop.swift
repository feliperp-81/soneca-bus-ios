//
//  BusStop.swift
//  Soneca-Bus
//
//  Created by Allan Melo on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

public class BusStop {

	var id: String
	var lat: Double
	var lon: Double
	var rua: String

	init(id: String, lat: Double, lon: Double, rua: String) {
		self.id = id
		self.lat = lat
		self.lon = lon
		self.rua = rua
	}
}
