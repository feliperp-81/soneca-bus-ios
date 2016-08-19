//
//  HomeTableViewController.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,
	UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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

		return 10
	}

	func tableView(
		tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
		-> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier(_cellID)
			as! HomeTableViewCell

		cell.streetLabel.text = "Felipe"

		return cell
	}

	private let _cellID = "HomeTableViewCell"

}