//
//  Helper.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/6/22.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import Foundation

class Helpers{
    
    //Helper to show activity indicator func
    static func showActivityIndicator(_ activityIndicator: UIActivityIndicatorView, _ view: UIView){
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //Helper to hide activity indicator func
    static func hideActivityIndicator(_ activityIndicator: UIActivityIndicatorView){
        activityIndicator.stopAnimating()
    }
    
    //Helper to load image func
    static func loadImage(imageView: UIImageView, urlString: String){
        
        if let url = URL(string: urlString){
            
            URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
                
                guard let download_url = url, error == nil else{
                    return
                }
                
                do{
                    let loadedData = try Data(contentsOf: download_url)
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: loadedData)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
            }).resume()
        }
    }
    
}
