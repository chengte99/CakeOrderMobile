//
//  User.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation
import SwiftyJSON

class User{
    
    var name: String?
    var email: String?
    var pictureURL: String?
    
    static let currentUser = User()
    
    func setUserInfo(json: JSON){
        self.name = json["name"].string
        self.email = json["email"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
    }
    
    func resetUserInfo(){
        self.name = nil
        self.email = nil
        self.pictureURL = nil
    }
    
}
