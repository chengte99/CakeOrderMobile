//
//  File.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager{
    
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void){
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                if error == nil{
                    
                    let json = JSON(result!)
                    print(json)
                    User.currentUser.setUserInfo(json: json)
                    
                    completionHandler()
                }
            })
        }
    }
    
}
