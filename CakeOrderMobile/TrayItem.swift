//
//  TrayItem.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/22.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation

class TrayItem{
    
    var meal: Meal
    var qty: Int
    
    init(meal: Meal, qty: Int){
        self.meal = meal
        self.qty = qty
    }
}

class Tray{
    
    static let currentTray = Tray()
    
    var item = [TrayItem]()
    
    func getTotal() -> Int{
        var total: Int = 0
        
        for item in self.item{
            total += item.qty * item.meal.price!
        }
        
        return total
    }
    
    func reset(){
        self.item = []
    }
    
}
