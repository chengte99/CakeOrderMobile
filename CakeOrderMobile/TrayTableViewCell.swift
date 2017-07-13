//
//  TrayTableViewCell.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/22.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit

class TrayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMealName: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    @IBOutlet weak var lbSubtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
