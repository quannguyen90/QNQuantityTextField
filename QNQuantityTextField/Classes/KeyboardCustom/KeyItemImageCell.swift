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

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
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
		if let iconName = name {
            iconCell.image = getImage(name: iconName)
		}
	}

	func setIconHightlightWithName(name: String?) {
		if let iconName = name {
            iconCell.image = getImage(name: iconName)
		}
	}
    
    func getImage(name: String) -> UIImage? {
        let frameworkBundle = Bundle(for: KeyItemImageCell.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("QNQuantityTextField.bundle")
        let resourceBundle = Bundle(url: bundleURL!)

        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}
