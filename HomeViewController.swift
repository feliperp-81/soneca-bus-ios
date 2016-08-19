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
//		let coordinate = CLLocationCoordinate2DMake(-8.062845, -34.871091)
//		let radius = Double(1000)
//		let identifier = NSUUID().UUIDString
//		let note = "marco zero.... Uhuull"
//
//		addGeotification(coordinate, radius: radius, identifier: identifier,
//		                 note: note)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		tableView.reloadData()
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("aqui")

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		let vc =
			storyboard.instantiateViewControllerWithIdentifier("alertDetails") as! AlertDetailsViewController

		vc.geonotification = getGeonotifications()[indexPath.row]

		self.navigationController?.pushViewController(vc, animated: true)
		
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
		setImage(geonotification.coordinate, completion: { image in
			cell.mapImageView.image = image
		})

		return cell
	}

//	override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
//
//		if segue!.identifier == "Details" {
//			let viewController:ViewController = segue!.destinationViewController as ViewController
//			let indexPath = self.tableView.indexPathForSelectedRow()
//			viewController.pinCode = self.exams[indexPath.row]
//		}
//	}
//
	func setImage(coordinate: CLLocationCoordinate2D, completion: (UIImage) -> ()) {
		let options = MKMapSnapshotOptions()
		options.size = CGSizeMake(107, 107)
		options.scale = UIScreen.mainScreen().scale
		options.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)

		let snapshotter = MKMapSnapshotter(options: options)

		snapshotter.startWithQueue(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { snapshot, error in
			guard let snapshot = snapshot else {
				print("Snapshot error: \(error)")
				fatalError()
			}

			let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
			let pinImage = pin.image

			let image = snapshot.image

			UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
			image.drawAtPoint(CGPoint.zero)

			var point = snapshot.pointForCoordinate(coordinate)
			let pinCenterOffset = pin.centerOffset

			point.x -= pin.bounds.size.width / 2.0
			point.y -= pin.bounds.size.width / 2.0
			point.x += pinCenterOffset.x
			point.y += pinCenterOffset.y

			pinImage?.drawAtPoint(CGPointMake(image.size.width/2, image.size.height/2))

			let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			completion(compositeImage)
		}
	}

	private let _cellID = "HomeTableViewCell"

}