//
//  OrderViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/7/3.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class OrderViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tbvOrder: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbPickDate: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var lbCheckedMessage: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var viewForStatus: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    
    var meal = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        loadLatestOrder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLatestOrder(){
        APIManager.shared.getLatestOrder { (json) in
            if json != nil{
                
                let order = json["order"]
                if let orderDetails = order["order_details"].array{
                    self.meal = orderDetails
                    self.tbvOrder.reloadData()
                }
                
                if let total = order["total"].int{
                    self.lbTotal.text = "$\(total)"
                }
                
                if let timeString = order["created_at"].string{
//                    let index = timeString.index(timeString.startIndex, offsetBy: 10)
//                    let prefix = timeString.substring(to: index)
                    self.lbDate.text = timeString
                }
                
                if let pickDate = order["pick_date"].string{
                    self.lbPickDate.text = pickDate
                }
                
                if let comment = order["customer_comment"].string{
                    self.lbComment.text = comment
                }
                
                if let message = order["finnal_checked_message"].string{
                    self.lbCheckedMessage.text = message
                }
                
                if let status = order["status"].string{
                    switch status{
                    case "Prepare":
                        HUD.flash(.label("店家尚未確認您的訂單，我們將於24小時內確認並回覆您的訂單，感謝！"), delay: 3.0)
                        self.lbStatus.text = "等待店家確認訂單中"
                        self.viewForStatus.backgroundColor = UIColor(red:0.94, green:0.35, blue:0.51, alpha:1.0)
                        
                    case "Finish":
                        HUD.flash(.label("感謝您的耐心等待，我們已確認完成您的訂單，感謝您的訂購！"), delay: 3.0)
                        self.lbStatus.text = "您的訂單已確認完成"
                        self.viewForStatus.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.37, alpha:1.0)
                        
                    default:
                        self.lbStatus.text = "等待中"
                        self.viewForStatus.backgroundColor = UIColor(red:0.94, green:0.35, blue:0.51, alpha:1.0)
                    }
                }
            }
        }
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ordeDetail = meal[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as! OrderTableViewCell
        
        cell.lbMealName.text = ordeDetail["meal"]["name"].string!
        cell.lbQty.text = "\(ordeDetail["quantity"].int!)"
        cell.lbSubtotal.text = "$\(ordeDetail["sub_total"].int!)"
        
        return cell
    }
    
    
    
}
