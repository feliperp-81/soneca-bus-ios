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

//	@IBOutlet weak var searchContainerView: UIView!
	@IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
		_searchController = UISearchController(searchResultsController: nil)

//		searchContainerView.addSubview(_searchController!.searchBar)

    }

	func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		getPoints()
	}

	func getPoints() {
//		busStops.removeAll()
//		mapView.removeAnnotations(mapView.annotations)

//		let header: [String : String] = ["host": "api.soneca.wedeploy.me"]
		var parameters = [String: AnyObject]()

		parameters["lat"] = Double(mapView.centerCoordinate.latitude)
		parameters["lon"] = Double(mapView.centerCoordinate.longitude)

//		http://api.soneca.wedeploy.io/paradas

		Alamofire.request(
			.GET, "http://api.soneca.wedeploy.io/paradas", parameters: parameters,
			headers: nil).responseJSON { response in

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
				self.addAnnotation(busStop)
			}

		}

		print(busStops)
	}

	func addAnnotation(busStop: BusStop) {
		let coodinate = CLLocationCoordinate2DMake(busStop.lat, busStop.lon)

		let annotation =
			BusStopAnnotation(coordinate: coodinate, title: busStop.rua,
			                  busStop: busStop)
		
		mapView.addAnnotation(annotation)
	}

	override func viewWillAppear(animated: Bool) {
	}

	override func viewDidAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if let location = getLocatioManager().location?.coordinate {
			mapView.centerCoordinate = location
			mapView.zoomEnabled = true

			let span = MKCoordinateSpanMake(0.012, 0.012)
			let region = MKCoordinateRegion(center: location, span: span)
			mapView.setRegion(region, animated: true)

			//			let camera = MKMapCamera(
			//				lookingAtCenterCoordinate: location, fromDistance: 0, pitch: 0,
			//				heading: 0)
			//
			//			mapView.setCamera(camera, animated: true)
		}

		mapView.delegate = self
		getPoints()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func cancelButtonAction(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation)
		-> MKAnnotationView? {
			
		if (annotation is MKUserLocation) {
			//if annotation is not an MKPointAnnotation (eg. MKUserLocation),
			//return nil so map draws default view for it (eg. blue dot)...
			return nil
		}

		let anView = MKPinAnnotationView(
			annotation: annotation, reuseIdentifier: nil)

		anView.canShowCallout = true
			

		return anView
	}

	func mapView(
		mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

		let busStopAnnotation = view.annotation as! BusStopAnnotation

		let coordinate = CLLocationCoordinate2DMake(
			busStopAnnotation.busStop.lat, busStopAnnotation.busStop.lon)

		let radius = Double(1000)
		let identifier = NSUUID().UUIDString
		let note = busStopAnnotation.busStop.rua

		addGeotification(coordinate, radius: radius, identifier: identifier,
		                 note: note)
	}

	private var _searchController:UISearchController?
	private var busStops = [BusStop]()
}
