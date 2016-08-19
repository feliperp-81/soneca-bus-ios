//
//  HomeTableViewCell.swift
//  Soneca-Bus
//
//  Created by Felipe Rodrigues de Paula on 8/19/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

	@IBOutlet weak var frequencyLabel: UILabel!
	@IBOutlet weak var mapImageView: UIImageView!
	@IBOutlet weak var streetLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
