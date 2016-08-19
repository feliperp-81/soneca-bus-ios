//
//  CreateAlertViewController.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class CreateAlertViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var searchContainerView: UIView!
	@IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
		_searchController = UISearchController(searchResultsController: nil)

		searchContainerView.addSubview(_searchController!.searchBar)

		if let location = getLocatioManager().location?.coordinate {
			mapView.centerCoordinate = location
			mapView.zoomEnabled = true

			let camera = MKMapCamera(
				lookingAtCenterCoordinate: location, fromDistance: 0, pitch: 0,
				heading: 0)

			mapView.setCamera(camera, animated: true)
		}

		mapView.delegate = self
		getPoints()
    }

	func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		getPoints()
	}

	func getPoints() {
		busStops.removeAll()

		let header: [String : String] = ["host": "api.soneca.wedeploy.me"]
		var parameters = [String: AnyObject]()

		parameters["lat"] = Double(mapView.centerCoordinate.latitude)
		parameters["lon"] = Double(mapView.centerCoordinate.longitude)

		Alamofire.request(
			.GET, "http://192.168.109.163/paradas", parameters: parameters,
			headers: header).responseJSON { response in

			let items = response.result.value as! [AnyObject]
			for item in items {

				let localization = item["localizacao"] as! [String: AnyObject]

				let id = item["id"] as! String
				let lat = localization["lat"] as! Double
				let lon = localization["lon"] as! Double

				let street = item["rua"] as! String


				let busStop = BusStop(
					id: id, lat: lat,
					lon: lon, rua: street)

				self.busStops.append(busStop)
			}

		}

		print(busStops)

	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		guard let searchController = _searchController else {
			return
		}

		var frame = searchController.searchBar.bounds
		frame.size.width = self.view.bounds.size.width
		searchController.searchBar.frame = frame
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func cancelButtonAction(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	

	private var _searchController:UISearchController?
	private var busStops = [BusStop]()
}
