//
//  KeyboardCustom.swift
//  SWiftTest
//
//  Created by MAC MINI  on 1/15/16.
//  Copyright © 2016 MAC MINI . All rights reserved.
//

import UIKit

enum KeyboardComponentType: Int {

	case FullComponent = 0
	case OnlyMainboard
	case ContainLeftComponent
	case ContainRightComponent
}

protocol KeyboardCustomDelegate {

	func keyboardCustom(keyboard: KeyboardCustom, didSelectKey keyItem: KeyItem)
	func keyboardCustom(keyboard: KeyboardCustom, didSelectHideKey keyItem: KeyItem)
	func keyboardCustom(keyboard: KeyboardCustom, didSelectDoneKey keyItem: KeyItem)
}

class KeyboardCustom: UIInputView {

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	var keyboarDelegate: KeyboardCustomDelegate?

	let tagLeftView: Int = -11111
	let tagMainView: Int = -22222
	let tagRightView: Int = -33333

	let indetifierCellText: String = "indetifier_cell_text"
	let indetifierCellImage: String = "indetifier_cell_image"

	// config layout
	let leftWidth: CGFloat = 80
	let rightWidth: CGFloat = 70

	var mainViewMarginLeft = 0.0 {
		didSet {
			layoutCompnent()
		}
	}

	var mainViewMarginRight = 0.0 {
		didSet {
			layoutCompnent()
		}
	}

	let mainViewMarginTop = 0.0
    let mainViewMarginBottom = UIApplication.bottomMargin

	// leftView
	let leftView: UICollectionView
	var listKeysLeftView: [KeyItem]? {
		didSet {
			leftView.reloadData()
		}
	}

	// RightView
	let rightView: UIView = UIView()
	var listKeysRightView: [KeyItem]? {
		didSet {
		}
	}

	// MainView
	let mainBoardView: UICollectionView
	var listKeysMainView: [KeyItem]? {
		didSet {
			mainBoardView.reloadData()
		}
	}

	let componentType: KeyboardComponentType
    init(frame: CGRect, inputViewStyle: UIInputView.Style, componentType: KeyboardComponentType) {

		self.mainBoardView = KeyboardCustom.createCollectionView(tag: tagMainView)
		self.leftView = KeyboardCustom.createCollectionView(tag: tagLeftView)
		self.componentType = componentType

		super.init(frame: frame, inputViewStyle: inputViewStyle)

		self.addSubview(mainBoardView)
		self.addSubview(leftView)
		self.addSubview(rightView)

		leftView.translatesAutoresizingMaskIntoConstraints = false
		rightView.translatesAutoresizingMaskIntoConstraints = false
		mainBoardView.translatesAutoresizingMaskIntoConstraints = false

		addDataSourceAndDelegate()
		registerCellForKeyboard()
		layoutCompnent()
		createSubViewForRightView()

		self.backgroundColor = UIColor(red: 0.962, green: 0.962, blue: 0.962, alpha: 1)
		leftView.backgroundColor = UIColor.clear
		rightView.backgroundColor = UIColor.clear
		mainBoardView.backgroundColor = UIColor.clear
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addDataSourceAndDelegate() {

		self.mainBoardView.delegate = self
		self.mainBoardView.dataSource = self

		switch componentType {
		case .FullComponent:
			self.leftView.delegate = self
			self.leftView.dataSource = self
			break
		case .ContainLeftComponent:
			self.leftView.delegate = self
			self.leftView.dataSource = self
			break;
		default:
			break
		}
	}

	class func createCollectionView(tag: Int) -> UICollectionView {

		let collectionViewLayout = UICollectionViewFlowLayout()
		let collectionFrame = CGRect.zero
		let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: collectionViewLayout)
		collectionView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
		collectionView.tag = tag
		return collectionView
	}

	func configLayoutView() {
		let keyLeftView = "keyLeftView"
		let keyRightView = "keyRightView"
		let keyMainboardView = "keyMainboardView"

		let visualContraintHevaltical = "H:|-0-[\(keyLeftView)(\(leftWidth))]-\(mainViewMarginLeft)-[\(keyMainboardView)]-\(mainViewMarginRight)-[\(keyRightView)(\(rightWidth))]-0-|"
		let visualContraintVerticalLeftView = "V:|-0-[\(keyLeftView)]-0-|"
		let visualContraintVerticalRightView = "V:|-0-[\(keyRightView)]-0-|"
		let visualContraintVerticalMainView = "V:|-\(mainViewMarginTop)-[\(keyMainboardView)]-\(mainViewMarginBottom)-|"

		let dicView: [String: AnyObject] = [keyLeftView: leftView, keyRightView: rightView, keyMainboardView: mainBoardView]

		let contraintHevaltical = NSLayoutConstraint.constraints(withVisualFormat: visualContraintHevaltical,
                                                                 options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalLeftView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalLeftView,
                                                                       options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalRightView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalRightView,
                                                                        options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalMainView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalMainView,
                                                                       options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		self.addConstraints(contraintHevaltical)
		self.addConstraints(contraintVerticalMainView)
		self.addConstraints(contraintVerticalLeftView)
		self.addConstraints(contraintVerticalRightView)
	}

	func registerCellForKeyboard() {

		mainBoardViewRegisterCell()

		switch componentType {
		case .FullComponent:
			leftViewRegisterCell()
			break

		case .ContainLeftComponent:
			leftViewRegisterCell()
			break;

		default:
			break
		}
	}
}

// MARK: - layout component
extension KeyboardCustom {

	func layoutCompnent() {
		switch componentType {
		case .FullComponent:
			layoutWhenFullComponent()
			break
		case .OnlyMainboard:
			layoutWhenOnlyMainboard()
			break
		case .ContainLeftComponent:
			layoutWhenContainLeftComponent()
			break
		case .ContainRightComponent:
			layoutWhenContainRighComponent()
			break
		}
	}

	func layoutWhenOnlyMainboard() {
		let leftViewWidth: CGFloat = 0.0
		let rightViewWidth: CGFloat = 0.0
		layoutComponent(leftViewWidth: leftViewWidth, rightViewWidth: rightViewWidth)
	}

	func layoutWhenFullComponent() {
		let leftViewWidth: CGFloat = leftWidth
		let rightViewWidth: CGFloat = rightWidth
		layoutComponent(leftViewWidth: leftViewWidth, rightViewWidth: rightViewWidth)
	}

	func layoutWhenContainLeftComponent() {
		let leftViewWidth: CGFloat = leftWidth
		let rightViewWidth: CGFloat = 0.0
		layoutComponent(leftViewWidth: leftViewWidth, rightViewWidth: rightViewWidth)
	}

	func layoutWhenContainRighComponent() {
		let leftViewWidth: CGFloat = 340 // 0.0
		let rightViewWidth: CGFloat = 340 // rightWidth
		layoutComponent(leftViewWidth: leftViewWidth, rightViewWidth: rightViewWidth)
	}

	func layoutComponent(leftViewWidth: CGFloat, rightViewWidth: CGFloat) {

		let allConstraint = self.constraints
		self.removeConstraints(allConstraint)

		let keyLeftView = "keyLeftView"
		let keyRightView = "keyRightView"
		let keyMainboardView = "keyMainboardView"

		let visualContraintHevaltical = "H:|-0-[\(keyLeftView)(\(leftViewWidth))]-\(mainViewMarginLeft)-[\(keyMainboardView)]-\(mainViewMarginRight)-[\(keyRightView)(\(rightViewWidth))]-0-|"
		let visualContraintVerticalLeftView = "V:|-0-[\(keyLeftView)]-0-|"
		let visualContraintVerticalRightView = "V:|-0-[\(keyRightView)]-0-|"
		let visualContraintVerticalMainView = "V:|-\(mainViewMarginTop)-[\(keyMainboardView)]-\(mainViewMarginBottom)-|"

		let dicView: [String: AnyObject] = [keyLeftView: leftView, keyRightView: rightView, keyMainboardView: mainBoardView]

		let contraintHevaltical = NSLayoutConstraint.constraints(withVisualFormat: visualContraintHevaltical,
                                                                 options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalLeftView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalLeftView,
                                                                       options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalRightView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalRightView,
                                                                        options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		let contraintVerticalMainView = NSLayoutConstraint.constraints(withVisualFormat: visualContraintVerticalMainView,
                                                                       options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline,
			metrics: nil,
			views: dicView)

		self.addConstraints(contraintHevaltical)
		self.addConstraints(contraintVerticalMainView)
		self.addConstraints(contraintVerticalLeftView)
		self.addConstraints(contraintVerticalRightView)
	}
}

// MARK: - Collection View datasource
extension KeyboardCustom: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == tagLeftView {
            return leftView(collectionView: collectionView, numberOfItemsInSection: section)
        } else {
            return mainBoardView(collectionView: collectionView, numberOfItemsInSection: section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == tagLeftView {
            return leftView(collectionView: collectionView, cellForItemAtIndexPath: indexPath)
        } else {
            return mainBoardView(collectionView: collectionView, cellForItemAtIndexPath: indexPath)
        }

    }

}

// MARK: - Collection View delegate
extension KeyboardCustom: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView.tag == tagLeftView {
            leftView(collectionView: collectionView, didSelectItemAtIndexPath: indexPath)
		} else {
            mainBoardView(collectionView: collectionView, didSelectItemAtIndexPath: indexPath)
		}
	}
}

// MARK: - Collection View delegate flow layout
extension KeyboardCustom: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView.tag == tagLeftView {
            return leftView(collectionView: collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
		} else {
			return mainBoardView(collectionView: collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (isIPad() == true) ? 5 : 0.5

	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return (isIPad() == true) ? 5 : 0.5
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return (isIPad() == true) ? UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0) : UIEdgeInsets(top: 0.5, left: 0, bottom: 0, right: 0.0)
	}
}

// MARK: - LeftView
extension KeyboardCustom {

	func leftViewRegisterCell() {

		let imageNibCell = UINib.init(nibName: "KeyItemImageCell", bundle: Bundle(for: KeyItemTextCell.self))
		leftView.register(imageNibCell, forCellWithReuseIdentifier: indetifierCellImage)

		let textNibCell = UINib.init(nibName: "KeyItemTextCell", bundle: Bundle(for: KeyItemTextCell.self))
		leftView.register(textNibCell, forCellWithReuseIdentifier: indetifierCellText)
	}

	func leftView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = listKeysLeftView?.count {
			return count
		} else {
			return 0
		}
	}

	func leftView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {

		let keyDisplay: KeyItem = listKeysLeftView![indexPath.row] as KeyItem
		if keyDisplay.isDisplayIcon {

			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indetifierCellImage, for: indexPath as IndexPath) as! KeyItemImageCell
			cell.setIconWithName(name: keyDisplay.iconName)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indetifierCellText, for: indexPath) as! KeyItemTextCell
			cell.setTextForCell(text: keyDisplay.textDisplay)
			return cell
		}
	}

	func leftView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)

		let keyDisplay: KeyItem = listKeysLeftView![indexPath.row] as KeyItem
        keyboarDelegate?.keyboardCustom(keyboard: self, didSelectKey: keyDisplay)

	}

	func leftView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

		let width = collectionView.frame.size.width;
		var height: CGFloat = 0.0

		if let numberItem = listKeysLeftView?.count {
			height = (collectionView.frame.size.height - (CGFloat(numberItem) * 0.5)) / CGFloat(numberItem)
		} else {
			height = 0.0
		}
        let size = CGSize(width: width, height: height)
		return size
	}
}

// MARK: - RightView
extension KeyboardCustom {

	func createSubViewForRightView() {

		switch componentType {
		case .FullComponent:
			addButtonForRightView()
			break

		case .ContainRightComponent:
			addButtonForRightView()
			break

		default:
			break
		}
	}

	func createButtonWithSelector(selector: Selector, target: AnyObject, displayText text: String, iconDisplay iconName: String) -> UIButton {
		let button = UIButton()
        button.setTitle(text, for: UIControl.State.normal)
		button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.setImage(UIImage(named: iconName), for: UIControl.State.normal)
        button.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
		return button
	}

	func addButtonForRightView() {
		let buttonHide = createButtonWithSelector(selector: #selector(KeyboardCustom.pressHideKeyboard), target: self, displayText: "", iconDisplay: "global_numpad_icon_dismiss_iphone")
		buttonHide.translatesAutoresizingMaskIntoConstraints = false
		buttonHide.setBackgroundImage(UIImage(named: "global_numpad_key_bg_normal_grey"), for: .normal)

		let buttonDone = createButtonWithSelector(selector: #selector(KeyboardCustom.pressDone), target: self, displayText: NSLocalizedString("Done", comment: ""), iconDisplay: NSLocalizedString("", comment: ""))
		buttonDone.translatesAutoresizingMaskIntoConstraints = false
		buttonDone.setBackgroundImage(UIImage(named: "global_numpad_key_bg_lrgdone"), for: .normal)
		buttonDone.titleLabel?.font = UIFont.systemFont(ofSize: 25)

		rightView.addSubview(buttonHide)
		rightView.addSubview(buttonDone)

		let keyButtonHide = "keyButtonHide"
		let visualConstrainButtonHideVertical = "V:[\(keyButtonHide)(75)]-10-|"
        let constraintsHideVertical = NSLayoutConstraint.constraints(withVisualFormat: visualConstrainButtonHideVertical, options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline, metrics: nil, views: [keyButtonHide: buttonHide])

		let visualConstrainButtonHideHevaltical = "H:[\(keyButtonHide)(109)]-10-|"
        let constraintsHideHevaltical = NSLayoutConstraint.constraints(withVisualFormat: visualConstrainButtonHideHevaltical, options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline, metrics: nil, views: [keyButtonHide: buttonHide])

		rightView.addConstraints(constraintsHideHevaltical)
		rightView.addConstraints(constraintsHideVertical)

		let keyButtonDone = "keyButtonDone"
		let visualConstrainButtonDoneHevaltical = "H:|-10-[\(keyButtonDone)(149)]"
        let constraintsDoneHevaltical = NSLayoutConstraint.constraints(withVisualFormat: visualConstrainButtonDoneHevaltical, options: NSLayoutConstraint.FormatOptions.alignAllLastBaseline, metrics: nil, views: [keyButtonDone: buttonDone])

        let constraintCenterDone = NSLayoutConstraint(item: buttonDone, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: rightView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0)
        let constraintHeightDone = NSLayoutConstraint(item: buttonDone, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 161.0)

		rightView.addConstraints(constraintsDoneHevaltical)
		rightView.addConstraint(constraintCenterDone)
		rightView.addConstraint(constraintHeightDone)
	}

	// action
    @objc func pressHideKeyboard() {
		if keyboarDelegate != nil {
			let keyHide = KeyItem(ID: "hide", textDisplay: "hide", actionKey: true, icon: "", iconHightlight: nil, displayIcon: false)
            keyboarDelegate?.keyboardCustom(keyboard: self, didSelectHideKey: keyHide)
		}
	}

    @objc func pressDone() {
		let keyHide = KeyItem(ID: "hide", textDisplay: "hide", actionKey: true, icon: "", iconHightlight: nil, displayIcon: false)
        keyboarDelegate?.keyboardCustom(keyboard: self, didSelectHideKey: keyHide)
	}
}

//MARK: - MainboardView
extension KeyboardCustom {
	func mainBoardViewRegisterCell() {

		let imageNibCell = UINib.init(nibName: "KeyItemImageCell", bundle: Bundle(for: KeyItemImageCell.self))
		mainBoardView.register(imageNibCell, forCellWithReuseIdentifier: indetifierCellImage)

		let textNibCell = UINib.init(nibName: "KeyItemTextCell", bundle: Bundle(for: KeyItemTextCell.self))
		mainBoardView.register(textNibCell, forCellWithReuseIdentifier: indetifierCellText)
	}

	func mainBoardView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let count = listKeysMainView?.count {
			return count
		} else {
			return 0
		}
	}

	func mainBoardView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {

		let keyDisplay: KeyItem = listKeysMainView![indexPath.row] as KeyItem
		if keyDisplay.isDisplayIcon {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indetifierCellImage, for: indexPath) as! KeyItemImageCell
            cell.labelName.text = keyDisplay.textDisplay
			cell.setIconWithName(name: keyDisplay.iconName)
			cell.setIconHightlightWithName(name: keyDisplay.iconHightlight ?? keyDisplay.iconName)
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indetifierCellText, for: indexPath) as! KeyItemTextCell
			cell.setTextForCell(text: keyDisplay.textDisplay)
			return cell
		}
	}

	func mainBoardView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)

		let keyDisplay: KeyItem = listKeysMainView![indexPath.row] as KeyItem
        keyboarDelegate?.keyboardCustom(keyboard: self, didSelectKey: keyDisplay)
	}

	func mainBoardView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		if isIPad() {
            let width = (collectionView.frame.width - 15) / 3
            let height = (collectionView.frame.height - 25) / 4
			return CGSize(width: width, height: height)
		} else {
			let width = (collectionView.frame.size.width - 1.5) / 3.0
			var height: CGFloat = 0.0
			if let count = listKeysMainView?.count {
				let numberRow = count / 3
				height = (collectionView.frame.size.height - (CGFloat(numberRow) * 0.5)) / CGFloat(numberRow)
			}

            let size = CGSize(width: width, height: height)
			return size
		}
	}
}
