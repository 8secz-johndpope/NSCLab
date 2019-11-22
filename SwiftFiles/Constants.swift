//
//  Constants.swift
//  DJDani
//
//  Created by sanjay bhatia on 29/08/19.
//  Copyright © 2019 sanjay bhatia. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import SwiftMessageBar



func PopUp(Controller: UIViewController, title: String, message: String, type: MessageType, time : Double)
{
//    SwiftMessageBar.showMessage(withTitle: title, message: message, type: type)
    SwiftMessageBar.showMessage(withTitle: title, message: message, type: type, duration: time)
    //    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
    //    Controller.present(alert, animated: true, completion: nil)
}
func parameterConvert(pram: [String : Any]) -> String
{
    var urlParam = ""
    for i in pram
    {
        let value = "\(i.value)".trimmingCharacters(in: .whitespaces)
        urlParam = urlParam + i.key + "=\(value)" + "&"
    }
    
    urlParam.removeLast()
    
    return "?"+urlParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
}


func validateEmailWithString(_ Email: NSString) -> Bool
{
    //let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return !emailTest.evaluate(with: Email)
}



func showAlert(Controller: UIViewController, title: String, message: String)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
    Controller.present(alert, animated: true, completion: nil)
}



class Connectivity
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}



func isValidPhone(phone: String) -> Bool
{
    let phoneRegex = "^[0-9]{6,14}$";
    let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    return valid
}


extension String
{
    var isValidContact: Bool
    {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}
func share(view: UIView, self: UIViewController, text: String, img: UIImage)
{
    
    // set up activity view controller
    let textToShare = [ text, img ] as [Any]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    //activityViewController.excludedActivityTypes = ([ UIActivityType.airDrop ] as! [UIActivityType])
    //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
}


class InstrinsicTableView: UITableView
{
    override var contentSize:CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
        
    }
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}



extension UIViewController: NVActivityIndicatorViewable
{

    func getVCInstance(storyBoard: String, vc: String) -> UIViewController
    {
        return UIStoryboard(name: storyBoard, bundle: nil) .
            instantiateViewController(withIdentifier: vc)
    }

    func disableEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapView))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func onTapView() {
        self.view.endEditing(true)
    }

    func start() {
        let size = CGSize(width: 50,height: 50)
        startAnimating(size, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor(rgb: 0x4fc1e9), padding: NVActivityIndicatorView.DEFAULT_PADDING)
    }

}


func validePhoneNumber(text : NSString)->Bool
{
    let searchTerm = text as String
    
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
    if text.length != 10
    {
        return true
    }
    else  if searchTerm.rangeOfCharacter(from: characterset.inverted) == nil
    {
        
        return true
    }
        
    else
    {
        return false
    }
}
