//
//  CustomTextField.swift
//  Ethereum
//
//  Created by Quan.nv on 7/16/18.
//  Copyright © 2018 Foodbook.vn. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var isDisable = false {
        didSet {
            self.isUserInteractionEnabled = !isDisable
            self.backgroundColor = !isDisable ? UIColor.white : UIColor(red: 244.0/255, green: 244.0/255, blue: 244.0/255, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        self.font = UIFont(name: "MyriadPro-Bold", size: 20)
        self.textColor = UIColor.black
        
        self.layer.cornerRadius =  6
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1).cgColor
        self.layer.borderWidth = 0.5
        
        self.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height ))
        leftView.backgroundColor = UIColor.clear
        self.leftView = leftView
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
        let iconValid = UIImageView(frame: CGRect(x: (rightView.frame.size.width - 15) / 2, y: (rightView.frame.size.height - 11) / 2, width: 15, height: 11))
        iconValid.image = UIImage(named: "icon_textfield_done")
        rightView.addSubview(iconValid)
        rightView.backgroundColor = UIColor.clear
        self.rightView = rightView
    }
}
