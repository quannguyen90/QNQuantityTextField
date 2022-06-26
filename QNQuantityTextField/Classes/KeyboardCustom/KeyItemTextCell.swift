//
//  KeyItemTextCell.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/15/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

class KeyItemTextCell: UICollectionViewCell {

	@IBOutlet var lblCellText: UILabel!
	@IBOutlet weak var imageViewBackground: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code

		if isIPad() {
			imageViewBackground.isHidden = false
			self.backgroundColor = UIColor.clear
			lblCellText.font = UIFont.systemFont(ofSize: 25.0)
		} else {
			imageViewBackground.isHidden = true
			self.backgroundColor = UIColor.white

			let v = UIView()
			v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
			self.selectedBackgroundView = v
		}
	}

	func setTextForCell(text: String?) {
		lblCellText.text = text
	}
}
