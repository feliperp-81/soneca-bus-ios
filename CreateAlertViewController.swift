//
//  CreateAlertViewController.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit

class CreateAlertViewController: UIViewController {

	@IBOutlet weak var searchContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		_searchController = UISearchController(searchResultsController: nil)

		searchContainerView.addSubview(_searchController!.searchBar)
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
}
