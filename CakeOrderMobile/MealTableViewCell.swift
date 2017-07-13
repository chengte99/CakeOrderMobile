//
//  MealTableViewCell.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/21.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMealNane: UILabel!
    @IBOutlet weak var lbShortDescription: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
