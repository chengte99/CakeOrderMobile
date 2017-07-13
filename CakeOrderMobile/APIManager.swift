//
//  APIManager.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/14.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import FBSDKLoginKit

class APIManager{
    
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    //API to login
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void){
        
        let path = "api/social/convert-token/"
        let url = baseURL?.appendingPathComponent(path)
        
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": FBSDKAccessToken.current().tokenString,
            "user_type": userType
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                
                let jsonData = JSON(value)
                
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                
                completionHandler(nil)
                
                break
            case .failure(let error):
                
                completionHandler(error as NSError)
                
                break
            }
        }
    }
    
    //API to logout
    func logout(completionHandler: @escaping (NSError?) -> Void){
        
        let path = "api/social/revoke-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success:
                
                completionHandler(nil)
                break
            case .failure(let error):
                
                completionHandler(error as NSError)
                break
            }
        }
    }
    
    //API to refresh the token when it's expired
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void){
        
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if Date() > self.expired{
            
            Alamofire.request(url!, method: HTTPMethod.post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result{
                case .success(let value):
                    
                    let jsonData = JSON(value)
                    
                    self.accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    
                    completionHandler()
                    
                    break
                case .failure:
                    break
                }
            })
            
        }else{
            completionHandler()
        }
    }
    
    //API to request server
    func requestServer(_ method: HTTPMethod, _ path: String, _ params: [String: Any]?, _ encoding: ParameterEncoding, _ completionHandler: @escaping (JSON) -> Void){
        
        let url = baseURL?.appendingPathComponent(path)
        
        Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                
                completionHandler(jsonData)
                break
            case .failure:
                completionHandler(nil)
                break
            }
        }
    }
    
    //API to get meal from restaurant 1
    func getMeal(restaurant_id: Int, completionHandler: @escaping (JSON) -> Void){
        
        let path = "api/customer/meal/\(restaurant_id)/"
        
        requestServer(.get, path, nil, URLEncoding()) { (json) in
            if json != nil{
                completionHandler(json)
            }
        }
    }
    
    //API to create new order
    func createOrder(restaurant_id: Int, realname: String, address: String, phone: String, pickDate: String, comment: String, completionHandler: @escaping (JSON) -> Void){
        
        let path = "api/customer/order/add/"
        let simpleArray = Tray.currentTray.item
        let jsonArray = simpleArray.map { item in
            return [
                "meal_id": item.meal.id!,
                "quantity": item.qty
            ]
        }
        
        if JSONSerialization.isValidJSONObject(jsonArray){
            
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                let params: [String: Any] = [
                    "access_token": self.accessToken,
                    "restaurant_id": restaurant_id,
                    "order_details": dataString!,
                    "realname": realname,
                    "address": address,
                    "phone": phone,
                    "pick_date": pickDate,
                    "customer_comment": comment
                ]
                
                requestServer(.post, path, params, URLEncoding(), completionHandler)
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    //API to get latest order
    func getLatestOrder(completionHandler: @escaping (JSON) -> Void){
        
        let path = "api/customer/order/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    
    
    
    
    
    
    
    
}
