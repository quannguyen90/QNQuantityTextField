//
//  KeyItem.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/15/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

class KeyItem: NSObject {

	let ID: String!
	let textDisplay: String?
	let isActionKey: Bool
	let iconName: String?
	let iconHightlight: String?
	let isDisplayIcon: Bool

	init(ID: String, textDisplay text: String, actionKey isActionKey: Bool, icon iconName: String, iconHightlight: String?, displayIcon: Bool) {
		self.ID = ID
		self.isActionKey = isActionKey
		self.textDisplay = text
		self.iconName = iconName
		self.iconHightlight = iconHightlight
		isDisplayIcon = displayIcon

		super.init()
	}
}
