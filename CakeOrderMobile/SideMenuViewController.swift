//
//  SideMenuViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/13.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    var session: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default)
        
        lbName.text = User.currentUser.name
        
        if let imgString = User.currentUser.pictureURL{
            if let url = URL(string: imgString){
                let newTask = session?.downloadTask(with: url, completionHandler: { (url, response, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    
                    if let downloadURL = url{
                        do{
                            let downloadData = try Data(contentsOf: downloadURL)
                            DispatchQueue.main.async {
                                self.imgAvatar.image = UIImage(data: downloadData)
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                })
                newTask?.resume()
            }
        }
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.clipsToBounds = true

        view.backgroundColor = UIColor(red:0.91, green:0.69, blue:0.51, alpha:1.0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout"{
            APIManager.shared.logout(completionHandler: { (error) in
                if error == nil{
                    FBManager.shared.logOut()
                    User.currentUser.resetUserInfo()
                }
            })
        }
    }

}
