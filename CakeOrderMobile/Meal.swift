//
//  Meal.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/21.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class Meal{
    
    var id: Int?
    var name: String?
    var short_description: String?
    var video_url: String?
    var image: String?
    var price: Int?
    
    init(json: JSON){
        
        self.id = json["id"].int
        self.name = json["name"].string
        self.short_description = json["short_description"].string
        self.video_url = json["video_url"].string
        self.image = json["image"].string
        self.price = json["price"].int
    }
    
}
