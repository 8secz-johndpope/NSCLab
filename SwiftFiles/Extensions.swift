//
//  Extensions.swift
//  DJDani
//
//  Created by sanjay bhatia on 29/08/19.
//  Copyright © 2019 sanjay bhatia. All rights reserved.
//


import Foundation
import UIKit


class MyLeftCustomFlowLayout:UICollectionViewFlowLayout {
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    let attributes = super.layoutAttributesForElements(in: rect)

    var leftMargin = sectionInset.left
    var maxY: CGFloat = 2.0

    let horizontalSpacing:CGFloat = 5

    attributes?.forEach { layoutAttribute in
        if layoutAttribute.frame.origin.y >= maxY
            || layoutAttribute.frame.origin.x == sectionInset.left {
            leftMargin = sectionInset.left
        }

        if layoutAttribute.frame.origin.x == sectionInset.left {
            leftMargin = sectionInset.left
        }
        else {
            layoutAttribute.frame.origin.x = leftMargin
        }

        leftMargin += layoutAttribute.frame.width + horizontalSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
    }

    return attributes
}
}
extension UIViewController
{
    func hideKeyboardTappedArround()
    {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard()
    {
        self.view.endEditing(true)
    }
}

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
    
    
}

extension UIButton {
    func changeButtonImageColor(color: UIColor, mode: UIControl.State)
    {
        let button = self
        button.setImage(button.image(for: mode)?.withRenderingMode(.alwaysTemplate), for: mode)
        button.tintColor = color
    }
}

extension UIView {
    func setGradientBackground(colorLeft: UIColor, colorMiddle: UIColor , colorRight: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft.cgColor, colorMiddle.cgColor, colorRight.cgColor]
        //        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        //        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 0.5), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}




extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView{
    
    
    func setGradient(colorLeft: UIColor, colorMiddle: UIColor , colorRight: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorMiddle.cgColor, colorLeft.cgColor , colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.0, 0.5 , 1.0]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
extension String {

  var length: Int {
    return count
  }

  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }

  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, length) ..< length]
  }

  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    
    
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func twoDecimalZero() -> String
    {
        let str = self
        let strArr = Array(str)
        let str1 = str.components(separatedBy: ".")
        if !strArr.contains(".")
        {
            return str+".00"
        }
        else if str1.last?.count != 2
        {
            return str+"0"
        }
        
        return str
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
