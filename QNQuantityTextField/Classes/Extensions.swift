//
//  Extensions.swift
//  QNQuantityTextField
//
//  Created by Quan Nguyen on 26/06/2022.
//

import Foundation
import UIKit


extension UIApplication {
    static var bottomMargin: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            } else {
                // Fallback on earlier versions
                return 0
            }
        }
    }
}


extension UIView {

    func addConstraints(constraintsVFL: String, views: [String: UIView], metrics: [String: AnyObject]? = nil, options: NSLayoutConstraint.FormatOptions = NSLayoutConstraint.FormatOptions(rawValue: 0)) {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: constraintsVFL, options: options, metrics: metrics, views: views)
        self.addConstraints(constraints)
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, name: String? = nil) -> CALayer {
        let line = CALayer()
        line.backgroundColor = lineColor.cgColor
        if start.y == end.y { // horizoltal line
            line.frame = CGRect(x: start.x, y: start.y, width: end.x - start.x, height: 0.5)
        } else { // vertical line
            line.frame = CGRect(x: start.x, y: start.y, width: 0.5, height: end.y - start.y)
        }
        line.name = name
        if let name = name {
            if let subLayers = self.layer.sublayers {
                for subLine in subLayers {
                    if name == subLine.name {
                        subLine.removeFromSuperlayer()
                    }
                }
            }
        }
        
        self.layer.addSublayer(line)
        
        return line
    }

}

extension String {
    static func stringWithNumber(number: Double, withCurrencySymbol currencySymbol: String, withNumberOfFractionDigits numberFractionDigit: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
//        numberFormatter.locale = Locale(identifier: "vi_VN")
        //    numberFormatter.maximumFractionDigits = numberFractionDigit
        numberFormatter.minimumFractionDigits = numberFractionDigit
        numberFormatter.currencySymbol = currencySymbol
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.groupingSeparator = AppLocale.sharedInstance.groupingSeparator
        numberFormatter.decimalSeparator = AppLocale.sharedInstance.decimalSeparator
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    static func currencyStringOfNumber(number: Double) -> String {
        return currencyStringOfNumber(number: number, withCurrency: AppLocale.sharedInstance.currencyCode)
    }
    
    static func currencyStringOfNumber(number: Double, withCurrency currency: String) -> String {
        if let string = stringWithNumber(number: number, withCurrencySymbol: "", withNumberOfFractionDigits: 0) {
            return string
        } else {
            return ""
        }
    }
    
    static func numberWithString(string: String, withCurrencySymbol currencySymbol: String, withNumberOfFractionDigits numberFractionDigit: Int) -> NSNumber? {
        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = numberFractionDigit
        numberFormatter.minimumFractionDigits = numberFractionDigit
        numberFormatter.currencySymbol = currencySymbol
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = AppLocale.sharedInstance.groupingSeparator
        numberFormatter.decimalSeparator = AppLocale.sharedInstance.decimalSeparator
        return numberFormatter.number(from: string)
    }
    
    static func stringWithNumber(number: Double, withNumberOfFractionDigits numberFractionDigit: Int, minimumFractionDigits: Int = 0) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = numberFractionDigit
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.groupingSeparator = AppLocale.sharedInstance.groupingSeparator
        numberFormatter.decimalSeparator = AppLocale.sharedInstance.decimalSeparator
        return numberFormatter.string(from: NSNumber(value: number))
    }
}
