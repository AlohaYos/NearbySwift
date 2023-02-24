//
//  CustomCell.swift
//  NearbySwift
//
//  Created by Yos Hashimoto on 2023/02/24.
//

import UIKit

class CustomCell: UITableViewCell {

	@IBOutlet weak var nameOfPlace: UILabel!
	@IBOutlet weak var distanceOfPlace: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
