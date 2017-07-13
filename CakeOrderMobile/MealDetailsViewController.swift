//
//  MealDetailsViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class MealDetailsViewController: UIViewController {

    @IBOutlet weak var imgMealPic: UIImageView!
    @IBOutlet weak var lbMealName: UILabel!
    @IBOutlet weak var lbMealDescription: UILabel!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    
    var meal: Meal?
    var qty = 1
    
    var addTrayProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMeal()
        
    }

    func loadMeal(){
        lbMealName.text = meal?.name
        lbMealDescription.text = meal?.short_description
        
        if let videoString = meal?.video_url{
            if videoString != ""{
                btnVideo.isHidden = false
            }
        }
        
        if let imgString = meal?.image{
            if let url = URL(string: imgString){
                imgMealPic.kf.setImage(with: url)
            }
//            Helpers.loadImage(imageView: imgMealPic, urlString: imgString)
        }
    }
    @IBAction func openVideo(_ sender: UIButton) {
        if let videoString = meal?.video_url{
            if let url = URL(string: videoString){
                let options = [UIApplicationOpenURLOptionUniversalLinksOnly: false]
                UIApplication.shared.open(url, options: options, completionHandler: nil)
            }
        }
    }
    
    @IBAction func addQuantity(_ sender: UIButton) {
        if qty < 99{
            qty += 1
            lbQuantity.text = String(qty)
            
            if let price = meal?.price{
                lbPrice.text = "$\(price * qty)"
            }
        }
    }
    
    @IBAction func removeQuantity(_ sender: UIButton) {
        if qty > 1{
            qty -= 1
            lbQuantity.text = String(qty)
            
            if let price = meal?.price{
                lbPrice.text = "$\(price * qty)"
            }
        }
    }
    
    @IBAction func addToTray(_ sender: UIButton) {
        
        if addTrayProcessing == false{
            self.addTrayProcessing = true
            
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
            image.image = UIImage(named: "icons8-bread")
            image.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 100)
            self.view.addSubview(image)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: { image.center = CGPoint(x: self.view.frame.width - 40, y: 24) },
                           completion: { _ in
                            image.removeFromSuperview()
                            
                            let trayItem = TrayItem(meal: self.meal!, qty: self.qty)
                            
                            let inTray = Tray.currentTray.item.index(where: { (item) -> Bool in
                                
                                return item.meal.id! == trayItem.meal.id!
                            })
                            
                            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                            
                            if let index = inTray{
                                
                                let alert = UIAlertController(title: "是否更新？", message: "此餐點已存在訂單內，是否更新數量？", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "更新", style: UIAlertActionStyle.default, handler: { (action) in
                                    
                                    Tray.currentTray.item[index].qty = self.qty
                                    HUD.flash(.labeledSuccess(title: "更新成功", subtitle: "已更新該餐點數量"), delay: 1.0)
                                })
                                
                                alert.addAction(okAction)
                                alert.addAction(cancelAction)
                                self.present(alert, animated: true, completion: nil)
                                self.addTrayProcessing = false
                            }else{
                                Tray.currentTray.item.append(trayItem)
                                self.addTrayProcessing = false
                            }
            })
        }
    }
    
    @IBAction func showTrayList(_ sender: UIBarButtonItem) {
        
        if Tray.currentTray.item.count == 0{
            let alert = UIAlertController(title: "錯誤", message: "您目前尚未點選將餐點加入清單，請點選下方綠色按鍵加入清單", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "確認前往", message: "繼續訂購其他餐點或直接前往訂購清單", preferredStyle: .alert)
            let backAction = UIAlertAction(title: "選擇其他", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            let goAction = UIAlertAction(title: "前往清單", style: .default) { (action) in
                self.performSegue(withIdentifier: "GoToTray", sender: self)
            }
            alert.addAction(backAction)
            alert.addAction(goAction)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
    
    
}
