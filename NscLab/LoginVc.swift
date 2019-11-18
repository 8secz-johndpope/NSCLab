//
//  LoginVc.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 07/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVc: UIViewController ,UITextFieldDelegate
{
    
    
    
    
    
    //--------------------------
    //MARK: Outlets
    //--------------------------
    
    @IBOutlet weak var lblEmailID: UILabel!
    
     @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBOutlet weak var lblEmailIDError: UILabel!
    
    @IBOutlet weak var lblPassword: UILabel!
    
     @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
   
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
  
   
    
    //--------------------------
    //MARK: Identifiers
    //--------------------------
    
    var timer = Timer()
    
    var userName = String()
    
      var loginData = JSON()
    
    //--------------------------
    //MARK: View life cycle
    //--------------------------
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     
        
        //----------------------------------------------
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            let obj = storyboard?.instantiateViewController(withIdentifier: "ConfrenceVC") as! ConfrenceVC
//              isNonMember = false
            navigationController?.pushViewController(obj, animated: false)
        }
        
        //----------------------------------------------
        
        
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        
//        lblEmailID.isHidden = true
        lblEmailIDError.isHidden = true
        
//        lblPassword.isHidden = true
        lblPasswordError.isHidden = true
        
        //----------------------------------------------
        
        
        btnLogin.layer.borderColor = UIColor.white.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 6
        btnLogin.clipsToBounds = true
        
        
            txtEmailAddress.layer.borderColor = UIColor.darkGray.cgColor
            txtEmailAddress.layer.borderWidth = 1
              txtEmailAddress.layer.cornerRadius = 5
              txtEmailAddress.clipsToBounds = true
       
        
        //----------------------------------------------
        
        let Username = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtEmailAddress.frame.height))

        let Password = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtPassword.frame.height))

        
        //----------------------------------------------
        

        txtEmailAddress.leftView = Username
        txtEmailAddress.leftViewMode = UITextField.ViewMode.always
        
        txtPassword.leftView = Password
        txtPassword.leftViewMode = UITextField.ViewMode.always

        //----------------------------------------------
        
        txtPassword.layer.borderColor = UIColor.darkGray.cgColor
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 5
        txtPassword.clipsToBounds = true
            
        //----------------------------------------------
        
        txtEmailAddress.addTarget(self, action: #selector(txtEmailAddressValueChanged), for: .editingChanged)
        
        txtPassword.addTarget(self, action: #selector(txtPasswordValueChanged), for: .editingChanged)
        
        //----------------------------------------------
        
        self.hideKeyboardTappedArround()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        
    }
    
    //--------------------------
    //MARK: Delegate Method
    //--------------------------
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    func registerKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: UIResponder.keyboardWillShowNotification,object: nil)

        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification,object: nil)
    }

    
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }




    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    
    //----------------------------
    // MARK: User Defined Function
    //----------------------------
    
    
    @objc func txtEmailAddressValueChanged()
    {
        if txtEmailAddress.text == ""
        {
//            lblEmailID.isHidden = true
            lblEmailIDError.isHidden = false
        }
        else
        {
            lblEmailID.isHidden = false
            lblEmailIDError.isHidden = true
            
        }
    }
    
    
    
    @objc func txtPasswordValueChanged()
    {
        if txtPassword.text == ""
        {
//            lblPassword.isHidden = true
            lblPasswordError.isHidden = false
        }
        else
        {
            lblPassword.isHidden = false
            lblPasswordError.isHidden = true
            
        }
    }
    
    
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
//            loginApi()
        }
        else
        {
            stopAnimating()
            showAlert(Controller: self, title: "Internet Connectivity", message: "Internet not available")
        }
    }


    
    

    @objc func keyboardWillShow(notification: NSNotification)
    {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification)
    {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }


    //--------------------------
    //MARK: Button action
    //--------------------------
    
    @IBAction func btnForgetPasswordTUI(_ sender: UIButton)
    {
        
        let obj = storyboard?.instantiateViewController(withIdentifier: "ForgetPassVC") as! ForgetPassVC
        navigationController?.pushViewController(obj, animated: true)
        
    }
    
    
    @IBAction func btnLoginTUI(_ sender: UIButton)
    {
        if (txtEmailAddress.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            PopUp(Controller: self, title: "Oops!", message: "Please fill emailID", type: .error, time: 3)
        }
        else if validateEmailWithString(txtEmailAddress.text! as NSString)
        {
            PopUp(Controller: self, title: "Oops!", message: "Please enter valid emailID", type: .error, time: 3)
        }
        else if (txtPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            PopUp(Controller: self, title: "Oops!", message: "Please fill password", type: .error, time: 3)
        }
        else
        {
           loginApi()
            
        }
        
        
    }
    
    @IBAction func btnSignUpTUI(_ sender: UIButton)
    {
      
        print("Action")
        
        let obj = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC

      
        self.navigationController?.pushViewController(obj, animated: true)

        
    }
    
    
 
    

    //--------------------------
    //MARK: Web services
    //--------------------------
    

    func loginApi()
    {

        let  parameter = ["type":"attendeesLogin","email": txtEmailAddress.text!, "password": txtPassword.text!] as [String : Any]

        print(parameter)
        if Connectivity.isConnectedToInternet()
        {
            timer.invalidate()
            self.start()
          
            let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                      
                      print("Login API => " + url)

            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
               if response.response?.statusCode == 200
                {
                    let result = JSON(response.value!)

                    print(result)
                    
                    if result["status"].boolValue == false
                         {
                            PopUp(Controller: self, title: "Error!", message: (result["msg"].stringValue), type: .error, time: 3)
                           
                            self.stopAnimating()
                                        
                  }
                        else
                        {
                            self.stopAnimating()

                         
                            
                            UserDefaults.standard.set(result["weChatID"].stringValue, forKey: "wechatid")
                            UserDefaults.standard.set(result["organization"].stringValue, forKey: "organization")
                            UserDefaults.standard.set(result["givenName"].stringValue, forKey: "givenName")
                            UserDefaults.standard.set(result["surname"].stringValue, forKey: "surname")
                            UserDefaults.standard.set(result["surname"].stringValue, forKey: "surname")
                            UserDefaults.standard.set(result["description"].stringValue, forKey: "description")
                             UserDefaults.standard.set(result["email"].stringValue, forKey: "email")
                               UserDefaults.standard.set(result["phoneNumber"].stringValue, forKey: "phoneNumber")
                               UserDefaults.standard.set(result["country"].stringValue, forKey: "country")

                     

                            
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            
                            
                            UserDefaults.standard.set(result["attendees_id"].stringValue, forKey: "attendeesid")
                                                            

                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ConfrenceVC") as! ConfrenceVC

                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")

                            self.navigationController?.pushViewController(obj, animated: true)
                        }

                        }

                    case .failure(let error):
                        print(error)
                    }

            }
        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
             PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
        }
    }


}
