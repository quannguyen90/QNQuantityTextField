//
//  TextFieldCustom.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/12/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

public enum TextFieldWithCustomType: String {
	case Normal
	case NumberKeyboardCustom;
}

public class TextFieldCustom: UITextField {

	static let heightKeyboard: CGFloat = (isIPad() == true) ? 350.0 : 250.0

    public var textFieldCustomType: TextFieldWithCustomType = .Normal {
		didSet {
			setCustomInputViewIfNeed()
		}
	}
    public var local: AppLocale = AppLocale.sharedInstance {
        didSet {
            reloadInputViews()
        }
    }
    

	public override func awakeFromNib() {
		super.awakeFromNib()

		textFieldCustomType = .NumberKeyboardCustom
	}

    
    public override func reloadInputViews() {
        super.reloadInputViews()
        let keyboard = self.inputView as? KeyboardCustom
        keyboard?.listKeysMainView = createListMainKey()
        keyboard?.listKeysLeftView = createListLeftKey()
    }
    
	func setCustomInputViewIfNeed() {

		switch textFieldCustomType {
		case TextFieldWithCustomType.NumberKeyboardCustom:
			setKeyboardNumberCustom()
			break
		default:
			break
		}
	}

    
	func setKeyboardNumberCustom() {
		let keyboard = createInputViewNumber()
		self.inputView = keyboard
	}

	func createInputViewNumber() -> KeyboardCustom {
		let width = UIScreen.main.bounds.size.width;
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: TextFieldCustom.heightKeyboard + UIApplication.bottomMargin)

		let keyBoardType = (isIPad() == true) ? KeyboardComponentType.ContainRightComponent : KeyboardComponentType.OnlyMainboard
		let keyboard = KeyboardCustom(frame: frame, inputViewStyle: .keyboard, componentType: keyBoardType)

		keyboard.mainViewMarginLeft = 0.0
		keyboard.keyboarDelegate = self
		keyboard.listKeysMainView = createListMainKey()
		keyboard.listKeysLeftView = createListLeftKey()

		return keyboard
	}

	func createListMainKey() -> [KeyItem] {

		var mainKeys = [KeyItem]()

		for i in 1 ..< 10 {
			let itemKey = KeyItem(ID: "\(i)", textDisplay: "\(i)", actionKey: false, icon: "", iconHightlight: nil, displayIcon: false)
			mainKeys.append(itemKey)
		}

        if local.maximumFractionDigits > 0 {
            let itemKey00 = KeyItem(ID: local.decimalSeparator, textDisplay: local.decimalSeparator, actionKey: false, icon: "", iconHightlight: nil, displayIcon: false)
            mainKeys.append(itemKey00)
            
        } else {
            let itemKey00 = KeyItem(ID: "00", textDisplay: "000", actionKey: false, icon: "", iconHightlight: nil, displayIcon: false)
            mainKeys.append(itemKey00)
        }
        
		let itemKey0 = KeyItem(ID: "0", textDisplay: "0", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
		mainKeys.append(itemKey0)
        
        let iconDeleteImage = (isIPad() == false) ? "global_numpad_icon_backspace_iphone" : "global_numpad_icon_backspace_ios7"
        let iconDeleteHighlightImage = (isIPad() == true) ? "global_numpad_icon_backspace_pressed_ios7" : ""
        let itemKeyDel = KeyItem(ID: "del", textDisplay: "del", actionKey: false, icon: iconDeleteImage, iconHightlight: iconDeleteHighlightImage, displayIcon: true)
        mainKeys.append(itemKeyDel)

		return mainKeys
	}

	func createListLeftKey() -> [KeyItem] {

		var leftKeys = [KeyItem]()

		let itemKey10Percent = KeyItem(ID: "10%", textDisplay: "10%", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
		leftKeys.append(itemKey10Percent)

		let itemKey20Percent = KeyItem(ID: "20%", textDisplay: "20%", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
		leftKeys.append(itemKey20Percent)

		let itemKey30Percent = KeyItem(ID: "30%", textDisplay: "30%", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
		leftKeys.append(itemKey30Percent)

		let itemKey35Percent = KeyItem(ID: "35%", textDisplay: "35%", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
		leftKeys.append(itemKey35Percent)

		return leftKeys
	}

	// MARK: - Disable action and move cursor
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
	
    public override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        self.position(from: beginning, offset: (self.text?.count)!)
        let end = self.position(from: beginning, offset: (self.text?.count)!)
        return end
    }

	
}

//MARK: - KeyboardDelegate
extension TextFieldCustom: KeyboardCustomDelegate {

	@objc func keyboardCustom(keyboard: KeyboardCustom, didSelectKey keyItem: KeyItem) {
		switch keyItem.ID {
		case "del":
			self.deleteBackward()
			break
		default:
			let textWithKey = keyItem.textDisplay
			if let delegate = delegate {
                
				if delegate.textField!(self, shouldChangeCharactersIn: NSRange(location: self.text!.count, length: 0), replacementString: textWithKey!) == true {
					self.insertText(textWithKey!)
				}
			} else {
				self.insertText(textWithKey!)
			}

			break
		}
	}

	@objc func keyboardCustom(keyboard: KeyboardCustom, didSelectHideKey keyItem: KeyItem) {
		self.resignFirstResponder()
	}

	@objc func keyboardCustom(keyboard: KeyboardCustom, didSelectDoneKey keyItem: KeyItem) {
		self.resignFirstResponder()
	}
}
