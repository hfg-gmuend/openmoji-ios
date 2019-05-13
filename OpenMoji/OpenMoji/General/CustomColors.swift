//
//  CustomColors.swift
//  OpenMoji
//
//  Created by Sam Eckert on 11.04.19.
//  Copyright © 2019 OpenMoji. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class var actionBlue: UIColor {
        return UIColor(red: 98, green: 176, blue: 205)
    }
    
    class var skinYellow: UIColor {
        return UIColor(red: 252, green: 234, blue: 43)
    }
    
    class var skin1: UIColor {
        return UIColor(red: 250, green: 234, blue: 188)
    }
    
    class var skin2: UIColor {
        return UIColor(red: 224, green: 187, blue: 149)
    }
    
    class var skin3: UIColor {
        return UIColor(red: 191, green: 143, blue: 104)
    }
    
    class var skin4: UIColor {
        return UIColor(red: 155, green: 100, blue: 61)
    }
    
    class var skin5: UIColor {
        return UIColor(red: 89, green: 69, blue: 57)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    /*convenience init(hex: String) {
        //switch hex {
        //case "FCEA2B":
            //self.init(red: U, green: Int, blue: Int)
        //default:
            if let hexAsInt = Int(hex){
                self.init(
                    red: (hexAsInt >> 16) & 0xFF,
                    green: (hexAsInt >> 8) & 0xFF,
                    blue: hexAsInt & 0xFF
                )
            }else{
                self.init(
                    red: 0,
                    green: 0,
                    blue: 0
                )
            }
        //}
    }*/
    
    convenience init (hex:String){
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(
                red: 0 / 255.0,
                green: 0 / 255.0,
                blue: 0 / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
         self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}
