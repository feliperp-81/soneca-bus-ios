//
//  HomeTableViewController.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController,
	UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		// marco zero -8.062845, -34.871091
		// praça bv -8.132096, -34.900622
		let coordinate = CLLocationCoordinate2DMake(-8.062845, -34.871091)
		let radius = Double(1000)
		let identifier = NSUUID().UUIDString
		let note = "marco zero.... Uhuull"

		addGeotification(coordinate, radius: radius, identifier: identifier,
		                 note: note)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func tableView(
		tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
		-> CGFloat {

		return 108.0
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
		-> Int {

		return getGeonotifications().count
	}

	func tableView(
		tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier(_cellID)
			as! HomeTableViewCell

		let geonotification = getGeonotifications()[indexPath.row]

		cell.streetLabel.text = geonotification.note

		return cell
	}

	private let _cellID = "HomeTableViewCell"

}