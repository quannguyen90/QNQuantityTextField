//
//  AppLocale.swift
//  QNQuantityTextField
//
//  Created by Quan Nguyen on 26/06/2022.
//

import UIKit

public class AppLocale: NSObject {
    let defaultCurrency = "đ"
    public static let sharedInstance = AppLocale()
    
    public init(localeIdentifier: String) {
        self.localeIdentifier = localeIdentifier
        let locale = Locale(identifier: self.localeIdentifier)
        self.locale = locale
        numberFormatter.locale = locale
        dateFormatter.locale = locale
    }

    fileprivate let dateFormatter = DateFormatter()
    public let numberFormatter = NumberFormatter()

    public var locale: Locale = Locale.current {
        didSet {
            numberFormatter.locale = locale
            dateFormatter.locale = locale
        }
    }
    public var localeIdentifier = Locale.current.identifier {
        didSet {
            let locale = Locale(identifier: self.localeIdentifier)
            self.locale = locale
            numberFormatter.locale = locale
            dateFormatter.locale = locale
        }
    }
    
    var currencySymbol: String {
        get {
            return numberFormatter.currencySymbol
        }
    }
    
    var currencyCode: String {
        get {
            return numberFormatter.currencyCode
        }
    }
    
    
    var decimalSeparator: String {
        get {
            return numberFormatter.decimalSeparator
        }
    }
    
    var groupingSeparator: String {
        get {
            return numberFormatter.groupingSeparator
        }
    }
    
    
    public var maximumFractionDigits: Int = 2
    
    
    override init() {
        super.init()
        self.numberFormatter.usesGroupingSeparator = true
        self.locale = Locale(identifier: self.localeIdentifier)
        self.numberFormatter.locale = locale
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    
    func getCurrencySymbol(_ currencyCode: String) -> String {

        for localeString in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeString)
            if let localeCurrencyCode = (locale as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String  {
                if localeCurrencyCode == currencyCode {
                    return (locale as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as? String ?? defaultCurrency
                }
            }
        }
        return defaultCurrency
    }
}

//MARK: - Number format
extension AppLocale {
    
    // MARK: - Number to string
    func stringFromNumber(_ number: NSNumber,maximumFractionDigits: Int = 0) -> String {
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        guard let string = numberFormatter.string(from: number) else {
            return ""
        }
        return string
    }
    
    func quantityStringWithNumber(_ number: Double, maximumFractionDigits: Int) -> String? {
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        return numberFormatter.string(from: NSNumber(value: number as Double))
    }
    
    func currencyStringOfNumber(_ number: Double) -> String {
        numberFormatter.numberStyle = .currency
        let numberNeedFormat = NSNumber(value: number as Double)
        return stringFromNumber(numberNeedFormat)
    }
    
    func percentStringOfNumber(_ number: Double) -> String {
        numberFormatter.numberStyle = .percent
        let numberNeedFormat = NSNumber(value: number as Double)
        return stringFromNumber(numberNeedFormat)
    }
    
    // MARK: - String to number
    func numberFromStringQuantity(_ string: String, maximumFractionDigits: Int) -> NSNumber? {
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        return numberFormatter.number(from: string)
    }
    
    func numberFromStringPercent(_ string: String) -> NSNumber? {
        numberFormatter.numberStyle = .percent
        return numberFormatter.number(from: string)
    }
    
    func numberFromStringCurrency(_ string: String) -> NSNumber? {
        numberFormatter.numberStyle = .currency
        return numberFormatter.number(from: string)
    }
    
    func stringFromNumber(_ number: Double, mumFractionDigits num: NSInteger) -> String? {
        numberFormatter.locale = self.locale
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = num
        return numberFormatter.string(from: NSNumber(value: number as Double))
    }
    
}
