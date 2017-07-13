//
//  LoginViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import PKHUD

class LoginViewController: UIViewController {
    
    var fbLoginSuccess = false
    
    let userType = USER_TYPE_CUSTOMER
    
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true){
            HUD.hide()
//            Helpers.hideActivityIndicator(self.activityIndicator)
            performSegue(withIdentifier: "CustomerView", sender: self)
            
        }
    }

    @IBAction func fbLogin(_ sender: UIButton) {
        
        let reachability = Reachability(hostName: "www.apple.com")
        
        if reachability?.currentReachabilityStatus().rawValue == 0{
            let alert = UIAlertController(title: "錯誤", message: "偵測網路失敗, 請確認網路連線正常", preferredStyle: UIAlertControllerStyle.alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else{
            if (FBSDKAccessToken.current() != nil){
                
                FBManager.getFBUserData(completionHandler: {
                    HUD.show(.progress, onView: self.view)
//                    Helpers.showActivityIndicator(self.activityIndicator, self.view)
                    APIManager.shared.login(userType: self.userType, completionHandler: { (error) in
                        if error == nil{
                            self.fbLoginSuccess = true
                            self.viewDidAppear(true)
                        }
                    })
                })
                
            }else{
                
                FBManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
                    
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    
                    FBManager.getFBUserData(completionHandler: {
                        HUD.show(.progress, onView: self.view)
//                        Helpers.showActivityIndicator(self.activityIndicator, self.view)
                        APIManager.shared.login(userType: self.userType, completionHandler: { (error) in
                            if error == nil{
                                self.fbLoginSuccess = true
                                self.viewDidAppear(true)
                            }
                        })
                    })
                    
                })
            }
        }
    }
    
    
    
    
}
