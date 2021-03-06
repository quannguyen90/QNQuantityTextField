//
//  QuantityTextField.swift
//  MobilePOS
//
//  Created by MAC MINI  on 7/28/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

protocol QuantityTextFieldDelegate: AnyObject {
    func quantityTextField(_ textField: QuantityTextField, didChangeNumber number: NSNumber?)
}



public class QuantityTextField: TextFieldCustom {
   
    public var isShowComma = false {
        didSet {
            refreshDisplayWithAmount(amount: amount)
            self.reloadInputViews()
        }
    }
    
    private var amount: NSNumber? {
        didSet {
            
        }
    }
    
    public override var local: AppLocale {
        didSet {
            groupingSeparatorSymbol = local.groupingSeparator
            decimalSeparatorSymbol = local.decimalSeparator
            reloadInputViews()
        }
    }
    
    var maximumFractionDigits: Int = 5
    var maximumAmount: Double?
    
    public var decimalSeparatorSymbol = ","
    public var groupingSeparatorSymbol = "."

    weak var quantityDelegate: QuantityTextFieldDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.addTarget(self, action: #selector(QuantityTextField.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    override func createListMainKey() -> [KeyItem] {
        
        var mainKeys = [KeyItem]()
        
        for i in 1 ..< 10 {
            let itemKey = KeyItem(ID: "\(i)", textDisplay: "\(i)", actionKey: false, icon: "", iconHightlight: nil, displayIcon: false)
            mainKeys.append(itemKey)
        }
        
        if isShowComma {
            let itemKeyComma = KeyItem(ID: decimalSeparatorSymbol, textDisplay: decimalSeparatorSymbol, actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
            mainKeys.append(itemKeyComma)
        } else {
            let itemKeyComma = KeyItem(ID: "000", textDisplay: "000", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
            mainKeys.append(itemKeyComma)
        }
        
        let itemKey0 = KeyItem(ID: "0", textDisplay: "0", actionKey: false, icon: "icon_back_space", iconHightlight: nil, displayIcon: false)
        mainKeys.append(itemKey0)
        
        let iconDeleteImage = "icon_back_space"
        let iconDeleteHighlightImage = "icon_back_space"
        let itemKeyDel = KeyItem(ID: "del", textDisplay: "del", actionKey: false, icon: iconDeleteImage, iconHightlight: iconDeleteHighlightImage, displayIcon: true)
        mainKeys.append(itemKeyDel)
        
        return mainKeys
    }
    
    override func keyboardCustom(keyboard: KeyboardCustom, didSelectKey keyItem: KeyItem) {
        switch keyItem.ID {
        case "del":
            
            self.deleteBackward()
            break
            
        case decimalSeparatorSymbol:
            let textDisplay = keyItem.textDisplay ?? ""
            guard let isContain = self.text?.contains(textDisplay), !isContain else {
                return
            }
            self.insertText(textDisplay)
            break
            
        default:
            let textWithKey = keyItem.textDisplay ?? ""
            let range = NSRange(location: self.text?.count ?? 0, length: 0)
            
            if let delegate = self.delegate {
                guard let shouldChange = delegate.textField?(self, shouldChangeCharactersIn: range, replacementString: textWithKey),shouldChange  else {
                    return
                }
            }
        
            self.insertText(textWithKey)
            break
        }
    }
    
    func setAmount(_ amount: NSNumber?) {
        if self.amount == nil {
            self.amount = amount
            refreshDisplayWithAmount(amount: amount)
        } else if self.amount?.doubleValue != amount?.doubleValue {
            self.amount = amount
            refreshDisplayWithAmount(amount: amount)
        }
    }
    
    func getAmount() -> NSNumber? {
        return self.amount
    }
    
    
    private func refreshDisplayWithAmount(amount: NSNumber?) {
        let string = local.stringFromNumber(amount ?? NSNumber(value: 0))
        //.stringWithNumber(number: amount?.doubleValue ?? 0, withNumberOfFractionDigits: numberFractionDigit)
        let result = caculateDataFromText(inputText: string)
       
        DispatchQueue.main.async {
            self.text = result.0
        }
        
    }
    
    private func changeAmount(_ amount: NSNumber?) {
        if self.amount?.floatValue != amount?.floatValue {
            self.amount = amount
            quantityDelegate?.quantityTextField(self, didChangeNumber: self.amount)
        }
    }
    
    private func caculateDataFromText(inputText: String?) -> (String?, NSNumber?) {
        guard let inputText = inputText else {
            return (nil, nil)
        }
        
        let groupingSeparator = groupingSeparatorSymbol
        let text = inputText.replacingOccurrences(of: groupingSeparator, with: "")
        
        if text.contains(decimalSeparatorSymbol) {
            
            if let lastComponent = text.components(separatedBy: decimalSeparatorSymbol).last, lastComponent.count > 0 {
                let numberFractionDigit = lastComponent.count < self.maximumFractionDigits ? lastComponent.count : self.maximumFractionDigits
                let number = local.numberFromStringQuantity(text, maximumFractionDigits: self.maximumFractionDigits)
                let result = getAmountAfterCheckMaxAmount(amount: number, numberFraction: numberFractionDigit)
                return result
            } else {
                return (inputText, amount)
            }
            
        } else {
            let number = local.numberFromStringQuantity(text, maximumFractionDigits: self.maximumFractionDigits)
            let result = getAmountAfterCheckMaxAmount(amount: number, numberFraction: self.maximumFractionDigits)
            return result
        }
    }

    
    @objc func textFieldDidChange(textField: UITextField) {
        let result = caculateDataFromText(inputText: textField.text)
        if result.1?.doubleValue != amount?.doubleValue {
            changeAmount(result.1)
            DispatchQueue.main.async {
                self.text = result.0
            }
        } else {
        }
    }

    func getAmountAfterCheckMaxAmount(amount: NSNumber?, numberFraction: Int) -> (String?, NSNumber?) {
        guard let maximumAmount = maximumAmount else {
            var string = local.stringFromNumber(amount ?? NSNumber(value: 0), maximumFractionDigits: maximumFractionDigits)
            if let isContain = self.text?.contains(decimalSeparatorSymbol), isContain {
                if self.text?.last == "0" {
                    string = local.stringFromNumber(amount ?? NSNumber(value: 0))
                    
                    //String.stringWithNumber(number: amount?.doubleValue ?? 0, withNumberOfFractionDigits: numberFraction, minimumFractionDigits: numberFraction)
                }
            }
            return (string, amount)
        }
        
        guard let amount = amount else { return (nil, nil) }
        let amountReal = amount.doubleValue < maximumAmount ? amount: NSNumber(value: maximumAmount)
        let string = local.stringFromNumber(amountReal)
        return (string, amountReal)
    }
}

extension QuantityTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        print("--->> string: ", string)

        let comma = decimalSeparatorSymbol
        if text.contains(comma) {
            // co dau ','
            if let componentAfter = text.components(separatedBy: comma).last, componentAfter.count > 0 {
                if componentAfter.count == maximumFractionDigits {
                    return false
                }
            }
            
            return true
        }
        
        let nsString = (textField.text as NSString?) ?? ""
        print("nsString: ", nsString)
        var newString = nsString.replacingCharacters(in: range, with: string)
        print("newString2: ", newString)
        let groupingSeparator = groupingSeparatorSymbol
        newString = newString.replacingOccurrences(of: groupingSeparator, with: "")
        print("newString3: ", newString)
        if newString.components(separatedBy: decimalSeparatorSymbol).count == 2 {
            let newStringDecimal = newString.components(separatedBy: decimalSeparatorSymbol)[1]
            if newStringDecimal.count < self.maximumFractionDigits {
                if let _ = local.numberFromStringQuantity(newString, maximumFractionDigits: maximumFractionDigits) {
                    return true
                }
            }
        } else {
            if let _ = local.numberFromStringQuantity(newString, maximumFractionDigits: maximumFractionDigits) {
                return true
            }
        }
        
        return false
    }
}

