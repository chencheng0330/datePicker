//
//  ViewController.swift
//  datePicker
//
//  Created by chencheng0330 on 2019/11/9.
//  Copyright © 2019年 chencheng0330. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func show(_ sender: Any) {
        let datepickPage = DatePickPage.init(nibName: nil, bundle: nil)
        datepickPage.sureBtnBlock = {(time) -> Void in
            print(time)
        }
        datepickPage.showDatePickerPage(to: self)
    }
    
}

