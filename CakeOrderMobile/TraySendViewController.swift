//
//  OrderSendViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD

class TraySendViewController: UIViewController, UIPopoverPresentationControllerDelegate, PopOverViewControllerDelegate {

    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var textfieldPickDate: UITextField!
    @IBOutlet weak var textfieldComment: UITextField!
    @IBOutlet weak var tbvTrayList: UITableView!
    @IBOutlet weak var lbTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfieldName.placeholder = "請填寫真實姓名"
        textfieldAddress.placeholder = "請填寫訂購地址"
        textfieldPhone.placeholder = "請填寫訂購電話"
        textfieldPickDate.placeholder = "請填寫預計取貨日期"
        textfieldComment.placeholder = "請填寫備註需求，若無可不填"
        
        loadTray()
        
    }
    
    func setDate(_ dateString: String) {
        self.textfieldPickDate.text = dateString
    }
    
    func loadTray(){
        self.lbTotal.text = "$\(Tray.currentTray.getTotal())"
        self.tbvTrayList.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func sendOrder(_ sender: UIButton) {
        
        if (textfieldName.text == "" || textfieldAddress.text == "" || textfieldPhone.text == "" || textfieldPickDate.text == "") {
            let alert = UIAlertController(title: "錯誤", message: "請填寫各項基本資料", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            if textfieldComment.text == ""{
                textfieldComment.text = "無"
            }
            APIManager.shared.getLatestOrder { (json) in
                if json != nil{
                    
                    if let latestOrderStatus = json["order"]["status"].string{
                        if latestOrderStatus == "Finish"{
                            HUD.show(.labeledProgress(title: "送出訂單", subtitle: "傳送訂單中"), onView: self.view)
                            //Now can create new order
                            APIManager.shared.createOrder(restaurant_id: RESTAURANT_ID, realname: self.textfieldName.text!, address: self.textfieldAddress.text!, phone: self.textfieldPhone.text!, pickDate: self.textfieldPickDate.text!, comment: self.textfieldComment.text!, completionHandler: { (json) in
                                if json != nil{
                                    print(json)
                                    if json["status"] == "success"{
                                        HUD.hide()
                                        Tray.currentTray.reset()
                                        let alert = UIAlertController(title: "訂購成功", message: "您已送出訂單，店家24小內即將確認您的訂單，感謝！", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                                        })
                                        alert.addAction(action)
                                        self.present(alert, animated: true, completion: nil)
                                    }else{
                                        let alert = UIAlertController(title: "訂購失敗", message: "訂購失敗，請確認網路是否正常！", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                        alert.addAction(action)
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            })
                        }else{
                            //show alert message that still has order not finish
                            
                            let alert = UIAlertController(title: "錯誤", message: "您尚有未完成的訂單，無法再新增訂單", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopOver"{
            segue.destination.popoverPresentationController?.delegate = self
            if let popOverView = segue.destination as? PopOverViewController{
                popOverView.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension TraySendViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textfieldPickDate{
            performSegue(withIdentifier: "PopOver", sender: self)
            self.view.endEditing(true)
            return false
        }else{
            return true
        }
    }
    
}

extension TraySendViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrayFinalCell", for: indexPath) as! TrayFinalTableViewCell
        
        let tray = Tray.currentTray.item[indexPath.row]
        
        cell.lbMealName.text = tray.meal.name
        cell.lbQty.text = "\(tray.qty)"
        cell.lbSubtotal.text = "$\(tray.qty * tray.meal.price!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "訂購清單"
        }else{
            return "訂購清單"
        }
    }
    
}
