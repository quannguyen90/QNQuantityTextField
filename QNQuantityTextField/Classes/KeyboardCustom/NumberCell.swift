//
//  NumberCell.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/11/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

class NumberCell: UICollectionViewCell {

    @IBOutlet var lblTitleCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTextTitle(text:String?){
        lblTitleCell.text = text
    }

    func setFont(font:UIFont?){
        lblTitleCell.font = font
        if let fontText = font{
            lblTitleCell.font = fontText
        }else{
            lblTitleCell.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }
    
    func setTextColor(color:UIColor?){
        if let colorText = color{
            lblTitleCell.textColor = colorText
        }else{
            lblTitleCell.textColor = UIColor.black
        }
        
    }
}
