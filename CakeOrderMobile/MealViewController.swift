//
//  MealViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/13.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit
import PKHUD

class MealViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbvMeal: UITableView!
    
    var mealArray = [Meal]()
    var mealFilterArray = [Meal]()
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            //self.revealViewController().rearViewRevealWidth = 300
        }
        
        loadMeal()
        
    }

    func loadMeal(){
        HUD.show(.progress, onView: self.view)
//        Helpers.showActivityIndicator(activityIndicator, view)
        
        APIManager.shared.getMeal(restaurant_id: RESTAURANT_ID) { (json) in
            if json != nil{
                
                if let mealList = json["meal"].array{
                    for item in mealList{
                        let meal = Meal(json: item)
                        self.mealArray.append(meal)
                    }
                }
                self.tbvMeal.reloadData()
                HUD.hide()
//                Helpers.hideActivityIndicator(self.activityIndicator)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealDetails"{
            self.view.endEditing(true)
            if let dvc = segue.destination as? MealDetailsViewController{
                if searchBar.text != ""{
                    dvc.meal = mealFilterArray[(tbvMeal.indexPathForSelectedRow?.row)!]
                }else{
                    dvc.meal = mealArray[(tbvMeal.indexPathForSelectedRow?.row)!]
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
}

extension MealViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        mealFilterArray = mealArray.filter({ (meal) -> Bool in
            
            if (meal.name?.contains(searchText))!{
                return true
            }else{
                return false
            }
        })
        tbvMeal.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}



extension MealViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text != ""{
            return mealFilterArray.count
        }else{
            return mealArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
        
        let meal: Meal
        
        if searchBar.text != ""{
            meal = mealFilterArray[indexPath.row]
        }else{
            meal = mealArray[indexPath.row]
        }
        
        cell.lbMealNane.text = meal.name
        cell.lbShortDescription.text = meal.short_description
        cell.lbPrice.text = "$\(meal.price!)"
        
        if let imgString = meal.image{
            if let url = URL(string: imgString){
                cell.imgPic.kf.setImage(with: url)
            }
//            Helpers.loadImage(imageView: cell.imgPic, urlString: imgString)
        }
            
        return cell
    }
    
    
}
