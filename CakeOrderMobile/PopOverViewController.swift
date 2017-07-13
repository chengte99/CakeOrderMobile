//
//  PopOverViewController.swift
//  CakeOrderMobile
//
//  Created by ChengTeLin on 2017/7/12.
//  Copyright © 2017年 Let'sGoBuildApp. All rights reserved.
//

import UIKit

protocol PopOverViewControllerDelegate{
    func setDate(_ dateString: String)
}

class PopOverViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnFinish: UIButton!
    var delegate: PopOverViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnFinish(_ sender: UIButton) {
        
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        delegate?.setDate(dateString)
        dismiss(animated: true, completion: nil)
    }

}
