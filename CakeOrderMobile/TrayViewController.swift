//
//  OrderViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/13.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit

class TrayViewController: UIViewController {
    
    @IBOutlet weak var tbvList: UITableView!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewButton: UIView!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(showEditMode(_:)))
        
        if Tray.currentTray.item.count == 0{
            //show message when tray is empty
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            emptyLabel.text = "目前清單為空，請選取餐點"
            emptyLabel.center = self.view.center
            emptyLabel.textAlignment = NSTextAlignment.center
            
            self.view.addSubview(emptyLabel)
        }else{
            //show all tray item
            
            self.tbvList.isHidden = false
            self.viewTotal.isHidden = false
            self.viewButton.isHidden = false
            
            loadTray()
        }
        
    }
    
    func loadTray(){
        self.lbTotal.text = "$\(Tray.currentTray.getTotal())"
        self.tbvList.reloadData()
    }
    
    
    func showEditMode(_ sender: UIBarButtonItem){
        if self.tbvList.isEditing == true{
            self.tbvList.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "編輯"
        }else{
            self.tbvList.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "完成"
        }
    }
    
}



extension TrayViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrayCell", for: indexPath) as! TrayTableViewCell
        
        let tray = Tray.currentTray.item[indexPath.row]
        
        cell.lbMealName.text = tray.meal.name
        cell.lbQty.text = "\(tray.qty)"
        cell.lbSubtotal.text = "$\(tray.qty * tray.meal.price!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            Tray.currentTray.item.remove(at: indexPath.row)
            self.lbTotal.text = "$\(Tray.currentTray.getTotal())"
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
}
