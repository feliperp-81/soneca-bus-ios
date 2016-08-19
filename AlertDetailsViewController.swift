//
//  AlertDetailsViewController.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import GoogleMaps

class AlertDetailsViewController: UIViewController, GMSPanoramaViewDelegate {

	var panoramaView: GMSPanoramaView?
	var geonotification: GeoNotification?

	@IBOutlet weak var panoramaContainer: UIView!
	@IBOutlet weak var labelEndereco: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Detalhes da Parada"
        // Do any additional setup after loading the view.
    }

	override func viewDidLayoutSubviews() {
		let rect = CGRectMake(
			0, 0, self.panoramaContainer.frame.size.width,
			self.panoramaContainer.frame.size.height)

		panoramaView?.frame = rect
	}

	override func viewWillAppear(animated: Bool) {

		let rect = CGRectMake(
			0, 0, self.panoramaContainer.frame.size.width,
			self.panoramaContainer.frame.size.height)

		if let notification = geonotification {
			labelEndereco.text = notification.note

			panoramaView = GMSPanoramaView(frame: rect)
			panoramaView?.moveNearCoordinate(notification.coordinate)
			panoramaContainer.addSubview(panoramaView!)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
