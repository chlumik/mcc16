//
//  Extensions.swift
//  Bonami
//
//  Created by Jan Nejtek on 15.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// This function returns a darkened version of the original image, used to make the subheader in SingleCampaignViewController. A parameter of 0.0 should return an unchanged image, and 1.0 should return a completely black image.
    /// - parameters:
    /// - alpha: The value that decides how much the image will be darkened (0.0 - no darkening; 1.0 - completely black)
    /// - returns: A darkened version of itself.
    func darkenedImage(alpha: CGFloat) -> UIImage {
        let color: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
        let area: CGRect = CGRectMake(0, 0, self.size.width, self.size.height)
        
        // zahájení vykreslovacího kontextu
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        // vykreslení původního obrázku
        self.drawInRect(area)
        
        // překreslení průhlednou barvou
        color.setFill()
        CGContextFillRect(context, area);
        
        // vytvoření nového UIImage a ukončení kontextu
        let darkImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return darkImage
    }
    
    /// This function returns a solid filled image with the given color and given size.
    /// - parameters:
    /// - color: The `UIColor` that the image will be filled with
    /// - size: The size of the desired image
    /// - returns: A solid filled image of given size and color.
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let area: CGRect = CGRect(origin: CGPoint.zero, size: size)
        
        // zahájení kontextu
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        // vykreslení obdélníku dané barvy
        color.setFill()
        CGContextFillRect(context, area)
        
        // vytvoření nového UIImage
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}

extension NSDate {
    /// This function converts the ISO 8601 date string sent by the Bonami API to a NSDate object.
    /// - warning: This function doesn't validate the correctness of the timezone or daylight saving time nor do any other error handling.
    /// - parameters:
    /// - string: An ISO 8601 formatted date string (e.g. `2015-02-28T20:15:00+0200`)
    /// - returns: A NSDate object with the given date and time.
    class func dateFromISOString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter.dateFromString(string)!
    }
}

extension String {
    /// This function returns the original string split into segments of given length.
    /// - note: Stolen from [here](http://stackoverflow.com/questions/33305157/split-string-into-groups-with-specific-length).
    /// - note: If the length of the original string is not a multiple of desired segment length, the first segment will be shorter.
    /// - parameters:
    /// - length: The desired segment length.
    /// - returns: An array of strings of the specified length.
    func splitIntoIntervals(length: Int) -> [String] {
        return 0.stride(to: self.characters.count, by: length)
            .reverse()
            .map {
                i -> String in
                let endIndex = self.endIndex.advancedBy(-i)
                let startIndex = endIndex.advancedBy(-length, limit: self.startIndex)
                return self[startIndex ..< endIndex]
        }
    }
}

public extension String {
    public subscript(i: Int) -> String {
        return self.substringWithRange(self.startIndex ..< self.startIndex.advancedBy(i + 1))
    }
    
    public subscript(r: Range<Int>) -> String {
        get {
            return self.substringWithRange(self.startIndex.advancedBy(r.startIndex) ..< self.startIndex.advancedBy(r.endIndex))
        }
    }
}

/// This function formats the currency and amount returned from the Bonami API according to their following specification and the respective locale:
/// CZK and PLN without decimal places, EUR with decimal places. If the currency is not recognized or the amount is not parsable, an unformatted string
/// consisting of the amount and the currency will be returned.
/// - parameters:
///   - amount: The string representing the amount to be parsed (example: "1234.50")
///   - currency: The string representing the currency (example: "EUR")
/// - returns: The formatted price string (example: 1234,50 €)
func BonamiFormatCurrency(amount: String, currency: String) -> String {
    
    guard let amount_float = Float(amount) else {
        print("BonamiFormatCurrency: can't parse amount \(amount) to Float, returning unformatted string...")
        return("\(amount) \(currency)")
    }
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    
    switch currency {
    case "CZK":
        formatter.locale = NSLocale(localeIdentifier: "cs_CZ")
        formatter.maximumFractionDigits = 0
    case "EUR":
        formatter.locale = NSLocale(localeIdentifier: "sk_SK")
        formatter.maximumFractionDigits = 2
    case "PLN":
        formatter.locale = NSLocale(localeIdentifier: "pl_PL")
        formatter.maximumFractionDigits = 0
    default:
        print("BonamiFormatCurrency: unknown currency \(currency), returning unformatted string...")
        return("\(amount) \(currency)")
    }
    
    return formatter.stringFromNumber(NSNumber(float: amount_float))!
}

func BonamiFormatCurrency(amount: String?, currency: String?) -> String? {
    
    guard let amm = amount, curr = currency else {
        return nil
    }
    return BonamiFormatCurrency(amm, currency: curr)
}
