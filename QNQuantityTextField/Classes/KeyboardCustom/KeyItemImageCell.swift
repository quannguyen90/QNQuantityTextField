//
//  KeyItemImageCell.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/15/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

class KeyItemImageCell: UICollectionViewCell {

	@IBOutlet var iconCell: UIImageView!
	@IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var labelName: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
        labelName.font = UIFont.systemFont(ofSize: 17)
        labelName.textColor = UIColor.black
        labelName.text = ""
        
		if isIPad() {
			imageViewBackground.isHidden = false
//			iconCell.tintColor = UIColor.whiteColor()
			self.backgroundColor = UIColor.clear
		} else {
			imageViewBackground.isHidden = true
			self.backgroundColor = UIColor.white

			let v = UIView()
			v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
			self.selectedBackgroundView = v
		}
	}

	func setIconWithName(name: String?) {
		if let iconName = name, let img = getImage(name: iconName) {
            iconCell.image = img
            labelName.isHidden = true
            iconCell.isHidden = false
        } else {
            labelName.isHidden = false
            iconCell.isHidden = true
        }
	}

	func setIconHightlightWithName(name: String?) {
		if let iconName = name, let img = getImage(name: iconName) {
            iconCell.image = img
            labelName.isHidden = true
            iconCell.isHidden = false
        } else {
            labelName.isHidden = false
            iconCell.isHidden = true
        }
	}
    
    func getImage(name: String) -> UIImage? {
        let frameworkBundle = Bundle(for: KeyItemImageCell.self)
//        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("QNQuantityTextField.bundle")
//        let resourceBundle = Bundle(url: bundleURL!)

        return UIImage(named: name, in: frameworkBundle, compatibleWith: nil)
    }
}
