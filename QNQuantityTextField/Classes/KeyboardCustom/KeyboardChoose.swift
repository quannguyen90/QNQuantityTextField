//
//  KeyboardChoose.swift
//  iPCC
//
//  Created by quan.nv  on 12/16/16.
//  Copyright © 2016 quan.nv . All rights reserved.
//

import UIKit

protocol KeyboardChooseDelegate: class {
    func keyboardChoose(keyboard: KeyboardChoose, widthForComponent component: Int) -> CGFloat
    func keyboardChoose(keyboard: KeyboardChoose, rowHeightForComponent component: Int) -> CGFloat
    func keyboardChoose(keyboard: KeyboardChoose, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    func keyboardChoose(keyboard: KeyboardChoose, didSelectRow row: Int, inComponent component: Int)
    func keyboardChooseDidDone(keyboard: KeyboardChoose)
    func keyboardChooseDidCancel(keyboard: KeyboardChoose)
    func keyboardChoose(keyboard: KeyboardChoose, didChooseDate value: NSDate)
}

protocol KeyboardChooseDataSource: class {
    func keyboardChoose(keyboard: KeyboardChoose, numberOfRowsInComponent component: Int) -> Int
    func numberOfComponentsInKeyboardChoose(keyboard: KeyboardChoose) -> Int
}

enum KeyboardChooseType {
    case normal
    case date
}

class KeyboardChoose: UIInputView {
    
    var type: KeyboardChooseType = .normal {
        didSet {
            switch type {
            case .normal:
                showPickerView()
            case .date:
                showDatePicker()
            }
        }
    }
    
    var rowSelected = -1 {
        didSet {
            if rowSelected >= 0 {
                pickerView.selectRow(rowSelected, inComponent: 0, animated: false)
            }
        }
    }
    
    // Date picker
    var dateMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = dateMode
        }
    }
    
    var minimumDate: NSDate? {
        didSet {
            datePicker.minimumDate = minimumDate as Date?
        }
    }
    var maximumDate: NSDate? {
        didSet {
            datePicker.maximumDate = maximumDate as Date?
        }
    }
    var dateSelected: NSDate = NSDate() {
        didSet {
            datePicker.date = dateSelected as Date
        }
    }
    
    weak var keboardDelegate: KeyboardChooseDelegate?
    weak var keboardDataSource: KeyboardChooseDataSource?
    var pickerView: UIPickerView = UIPickerView()
    var datePicker: UIDatePicker = UIDatePicker()
    var titleBar: String?
    
    var toolBar = UIToolbar()
    
    init(frame: CGRect, inputViewStyle: UIInputView.Style, delegate: KeyboardChooseDelegate, dataSource: KeyboardChooseDataSource) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        self.backgroundColor = UIColor(red: 215.0/255, green: 218.0/255, blue: 255.0/255, alpha: 1.0)
        self.keboardDelegate = delegate
        self.keboardDataSource = dataSource
        
        pickerView.delegate = self
        pickerView.dataSource = self
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        pickerView.reloadAllComponents()
    }
    
    // MARK: - setupview
    private func showPickerView() {
        pickerView.isHidden = false
        datePicker.isHidden = true
        self.removeConstraints(self.constraints)
        let dict = ["toolBar": toolBar, "pickerView": pickerView] as [String: UIView]
        self.addConstraints(constraintsVFL: "H:|-0-[pickerView]-0-|", views: dict)
        self.addConstraints(constraintsVFL: "V:|-0-[pickerView]-0-|", views: dict)
    }
    
    private func showDatePicker() {
        pickerView.isHidden = true
        datePicker.isHidden = false
        
        self.removeConstraints(self.constraints)
        let dict = ["toolBar": toolBar, "pickerView": datePicker] as [String: UIView]
        self.addConstraints(constraintsVFL: "H:|-0-[pickerView]-0-|", views: dict)
        self.addConstraints(constraintsVFL: "V:|-0-[pickerView]-0-|", views: dict)
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    func setupView() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(pickerView)
        self.addSubview(datePicker)
        
        showPickerView()
        setupToolBar()
    }
    
    func setupToolBar() {
        self.toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Xong", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneAction))
        doneButton.tintColor = UIColor.darkGray
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Huỷ", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAction))
        cancelButton.tintColor = UIColor.red
        self.toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }
    
    @objc func doneAction() {
        if type == .date {
            keboardDelegate?.keyboardChoose(keyboard: self, didChooseDate: datePicker.date as NSDate)
            return
        }
        
        keboardDelegate?.keyboardChooseDidDone(keyboard: self)
    }
    
    @objc func cancelAction() {
        keboardDelegate?.keyboardChooseDidCancel(keyboard: self)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        keboardDelegate?.keyboardChoose(keyboard: self, didChooseDate: datePicker.date as NSDate)
    }
}

extension KeyboardChoose: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = keboardDelegate?.keyboardChoose(keyboard: self, widthForComponent: component)
        return width ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let height = keboardDelegate?.keyboardChoose(keyboard: self, rowHeightForComponent: component)
        return height ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        keboardDelegate?.keyboardChoose(keyboard: self, didSelectRow: row, inComponent: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = keboardDelegate?.keyboardChoose(keyboard: self, viewForRow: row, forComponent: component, reusingView: view)
        return view ?? UIView()
    }
    
}

extension KeyboardChoose: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let component = keboardDataSource?.keyboardChoose(keyboard: self, numberOfRowsInComponent: component)
        return component ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let component = keboardDataSource?.numberOfComponentsInKeyboardChoose(keyboard: self)
        return component ?? 0
    }
    
}
