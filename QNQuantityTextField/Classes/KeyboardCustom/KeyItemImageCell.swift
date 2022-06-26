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
            if #available(iOS 13.0, *) {
                iconCell.image = UIImage(named: iconName, in: Bundle(for: KeyItemImageCell.self), with: nil)
            } else {
                // Fallback on earlier versions
                iconCell.image = UIImage(named: iconName, in: Bundle(for: KeyItemImageCell.self), compatibleWith: nil)

            }
		}
	}

	func setIconHightlightWithName(name: String?) {
		if let iconName = name {
            if #available(iOS 13.0, *) {
                iconCell.highlightedImage = UIImage(named: iconName, in: Bundle(for: KeyItemImageCell.self), with: nil)
            } else {
                // Fallback on earlier versions
                iconCell.highlightedImage = UIImage(named: iconName, in: Bundle(for: KeyItemImageCell.self), compatibleWith: nil)

            }
		}
	}
}
