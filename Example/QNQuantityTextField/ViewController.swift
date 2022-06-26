//
//  ViewController.swift
//  QNQuantityTextField
//
//  Created by quannguyen90 on 06/26/2022.
//  Copyright (c) 2022 quannguyen90. All rights reserved.
//

import UIKit
import QNQuantityTextField

class ViewController: UIViewController {

    @IBOutlet weak var textField: QuantityTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.local = AppLocale(localeIdentifier: "vi_VN") //= Locale(identifier: "VN")
        textField.isShowComma = true 
        textField.reloadInputViews()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

