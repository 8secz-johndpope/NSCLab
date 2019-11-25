//
//  RegisterVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 08/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import FirebaseDatabase

class RegisterVC: UIViewController,UITextFieldDelegate {


        //-----------------------
        //MARK: Outlets
        //-----------------------
        
       
    @IBOutlet weak var lblSurname: UILabel!
    
    @IBOutlet weak var txtSurname: UITextField!
    
    @IBOutlet weak var lblSurnameError: UILabel!
    
    @IBOutlet weak var lblGivenName: UILabel!

    @IBOutlet weak var txtGivenName: UITextField!
    
    @IBOutlet weak var lblGivenNameError: UILabel!
    
    @IBOutlet weak var txtSelectTittle: UITextField!
    
    @IBOutlet weak var lblSelectTittleError: UILabel!
    
    @IBOutlet weak var lblOrganizer: UILabel!
    
    @IBOutlet weak var txtOrganizer: UITextField!
    
    @IBOutlet weak var lblOrganizerError: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var lblPhoneError: UILabel!
    
    @IBOutlet weak var lblWechat: UILabel!
    
    @IBOutlet weak var txtWechat: UITextField!
    
    @IBOutlet weak var lblWechatError: UILabel!
    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var lblCountryError: UILabel!
    
    @IBOutlet weak var lblPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var lblConfirmPasswordPlaceholder: UILabel!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
        
    @IBOutlet weak var headerView: UIView!
    
     @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var btnDropDown: UIButton!
    
        //-----------------------
        //MARK: Identifires
        //-----------------------
        
        var timer = Timer()
        
        var appuserid = Int()
    
        let dropDown = DropDown()
    
        var regiterData = JSON()
        
        let countryDropDown = DropDown()
     
        //-----------------------
        //MARK: View life cycle
        //-----------------------
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            
            dropDown.anchorView = btnDropDown
            dropDown.dataSource = ["Professor", "Miss", "Sir"]
            
            countryDropDown.anchorView = btnCountry
            countryDropDown.dataSource = ["INDIA", "AUSTRALIA", "US", "UK", "CANADA"]
            headerView.backgroundColor = Colors.HeaderColor
        
              
               
                
            lblPasswordError.isHidden = true
            lblConfirmPasswordError.isHidden = true
            lblSurnameError.isHidden = true
            lblGivenNameError.isHidden = true
            lblOrganizerError.isHidden = true
            lblEmailError.isHidden = true
            lblPhoneError.isHidden = true
            lblWechatError.isHidden = true
            lblSelectTittleError.isHidden = true
            lblCountryError.isHidden = true
            
//            //----------------------------------------------
            lblSurname.isHidden = true
            lblGivenName.isHidden = true
            lblOrganizer.isHidden = true
            lblEmail.isHidden = true
            lblPhone.isHidden = true
            lblWechat.isHidden = true
            lblCountry.isHidden = true
            lblConfirmPasswordPlaceholder.isHidden = true
            lblPasswordPlaceholder.isHidden = true
                   
//            
//            //----------------------------------------------
            btnRegister.layer.borderColor = UIColor.white.cgColor
            btnRegister.layer.borderWidth = 1
            btnRegister.layer.cornerRadius = 6
            btnRegister.clipsToBounds = true
          
//            //----------------------------------------------
//            
            txtSurname.delegate = self
            txtGivenName.delegate = self
            txtOrganizer.delegate = self
            txtEmail.delegate = self
            txtPhone.delegate = self
            txtWechat.delegate = self
            txtSelectTittle.delegate = self
            txtCountry.delegate = self
            txtPassword.delegate = self
            txtConfirmPassword.delegate = self
            

//            //----------------------------------------------
               
            let Surname = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtSurname.frame.height))

            let GivenName = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtGivenName.frame.height))
        
            let Org = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtOrganizer.frame.height))

            let Email = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtEmail.frame.height))

            let Phone = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtPhone.frame.height))

            let Wechat = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtWechat.frame.height))

              let Country = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtCountry.frame.height))
             
            let tittle = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtSelectTittle.frame.height))
            
              let password = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtPassword.frame.height))
            
              let Confirmpassword = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtConfirmPassword.frame.height))
//               
//               //----------------------------------------------
//               

                txtSurname.leftView = Surname
                txtGivenName.leftView = GivenName
                txtOrganizer.leftView = Org
                txtEmail.leftView = Email
                txtPhone.leftView = Phone
                txtWechat.leftView = Wechat
                txtCountry.leftView = Country
                txtSelectTittle.leftView = tittle
                txtPassword.leftView = password
                txtConfirmPassword.leftView = Confirmpassword
//
//            
//            //----------------------------------------------
//                          
//            
                txtSurname.leftViewMode = UITextField.ViewMode.always
                txtGivenName.leftViewMode = UITextField.ViewMode.always
                txtOrganizer.leftViewMode = UITextField.ViewMode.always
                txtEmail.leftViewMode = UITextField.ViewMode.always
                txtPhone.leftViewMode = UITextField.ViewMode.always
                txtWechat.leftViewMode = UITextField.ViewMode.always
                txtCountry.leftViewMode = UITextField.ViewMode.always
                txtSelectTittle.leftViewMode = UITextField.ViewMode.always
                txtPassword.leftViewMode = UITextField.ViewMode.always
                txtConfirmPassword.leftViewMode = UITextField.ViewMode.always
                //
                          
//               //----------------------------------------------
//            
            
            txtSurname.addTarget(self, action: #selector(txtSurnameValueChanged), for: .editingChanged)
            txtGivenName.addTarget(self, action: #selector(txtGivenNameValueChanged), for: .editingChanged)
            txtOrganizer.addTarget(self, action: #selector(txtOrganizerValueChanged), for: .editingChanged)
            txtEmail.addTarget(self, action: #selector(txtEmailValueChanged), for: .editingChanged)
             txtPhone.addTarget(self, action: #selector(txtPhoneValueChanged), for: .editingChanged)
             txtWechat.addTarget(self, action: #selector(txtWechatValueChanged), for: .editingChanged)
            txtSelectTittle.addTarget(self, action: #selector(txtSelectTittleValueChanged), for: .editingChanged)
            txtCountry.addTarget(self, action: #selector(txtCountryValueChanged), for: .editingChanged)
            
            txtPassword.addTarget(self, action: #selector(PasswordTextChanged), for: .editingChanged)
            
                  txtConfirmPassword.addTarget(self, action: #selector(ConfirmPasswordTextChanged), for: .editingChanged)
//            //----------------------------------------------
  
//            self.hideKeyboardTappedArround()
            
            txtSurname.layer.borderColor = UIColor.darkGray.cgColor
            txtSurname.layer.borderWidth = 1
            txtSurname.layer.cornerRadius = 5
            txtSurname.clipsToBounds = true
            
            txtGivenName.layer.borderColor = UIColor.darkGray.cgColor
            txtGivenName.layer.borderWidth = 1
            txtGivenName.layer.cornerRadius = 5
            txtGivenName.clipsToBounds = true
            
            txtOrganizer.layer.borderColor = UIColor.darkGray.cgColor
            txtOrganizer.layer.borderWidth = 1
            txtOrganizer.layer.cornerRadius = 5
            txtOrganizer.clipsToBounds = true
            
            txtEmail.layer.borderColor = UIColor.darkGray.cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            txtEmail.clipsToBounds = true
            
            txtPhone.layer.borderColor = UIColor.darkGray.cgColor
            txtPhone.layer.borderWidth = 1
            txtPhone.layer.cornerRadius = 5
            txtPhone.clipsToBounds = true
            
            txtWechat.layer.borderColor = UIColor.darkGray.cgColor
            txtWechat.layer.borderWidth = 1
            txtWechat.layer.cornerRadius = 5
            txtWechat.clipsToBounds = true
            
            txtCountry.layer.borderColor = UIColor.darkGray.cgColor
            txtCountry.layer.borderWidth = 1
            txtCountry.layer.cornerRadius = 5
            txtCountry.clipsToBounds = true
            
            txtSelectTittle.layer.borderColor = UIColor.darkGray.cgColor
            txtSelectTittle.layer.borderWidth = 1
            txtSelectTittle.layer.cornerRadius = 5
            txtSelectTittle.clipsToBounds = true
            
            txtPassword.layer.borderColor = UIColor.darkGray.cgColor
            txtPassword.layer.borderWidth = 1
            txtPassword.layer.cornerRadius = 5
            txtPassword.clipsToBounds = true
            
            txtConfirmPassword.layer.borderColor = UIColor.darkGray.cgColor
            txtConfirmPassword.layer.borderWidth = 1
            txtConfirmPassword.layer.cornerRadius = 5
            txtConfirmPassword.clipsToBounds = true
     
        }
        
        
        
        override func viewWillAppear(_ animated: Bool)
        {
            super.viewWillAppear(animated)
            registerKeyboardNotifications()
            DropDown.startListeningToKeyboard()

        }
        
        
        //-----------------------
        //MARK: Delegate methods
        //-----------------------
        
        
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
        
        
//        func textFieldDidBeginEditing(_ textField: UITextField) {
//            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
//        }
//
//
//
//
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }
        
         
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
         {
             if textField.tag == 1
             {
                 if string.count == 0 {
                     return true
                 }
                 if (textField.text?.count ?? 0) == 10 {
                     return false
                 }
                 let nonNumberSet = CharacterSet.decimalDigits.inverted
                 if Int((string as NSString).rangeOfCharacter(from: nonNumberSet).location) != NSNotFound {
                     return false
                 }
             }
             
             return true
         }
        
        //-----------------------------
        //MARK: User defined functions
        //-----------------------------
        
        @objc func txtSurnameValueChanged()
        {
            if txtSurname.text == ""
            {
                lblSurname.isHidden = true
                lblSurnameError.isHidden = false
            }
            else
            {
                lblSurname.isHidden = false
                lblSurnameError.isHidden = true
            }
        }
        
        
        @objc func txtGivenNameValueChanged()
        {
            if txtGivenName.text == ""
            {
                lblGivenName.isHidden = true
                lblGivenNameError.isHidden = false
            }
            else
            {
                lblGivenName.isHidden = false
                lblGivenNameError.isHidden = true
            }
        }
        
      
    
        
    
    @objc func txtSelectTittleValueChanged()
        {
            if txtGivenName.text == ""
            {
               
                lblSelectTittleError.isHidden = false
            }
            else
            {
               
                lblSelectTittleError.isHidden = true
            }
        }
        @objc func txtOrganizerValueChanged()
        {
            if txtOrganizer.text == ""
            {
                lblOrganizer.isHidden = true
               lblOrganizerError.isHidden = false
            }
            else
            {
                lblOrganizer.isHidden = false
                lblOrganizerError.isHidden = true
            }
        }
        
    @objc func txtEmailValueChanged()
         {
             if txtEmail.text == ""
             {
                 lblEmail.isHidden = true
                 lblEmailError.isHidden = false
             }
             else
             {
                 lblEmail.isHidden = false
                 lblEmailError.isHidden = true
             }
         }
         
        @objc func txtPhoneValueChanged()
        {
            if txtPhone.text == ""
            {
                lblPhone.isHidden = true
                lblPhoneError.isHidden = false
            }
            else
            {
                lblPhone.isHidden = false
                lblPhoneError.isHidden = true
            }
        }
    
    @objc func PasswordTextChanged()
      {
          if txtPassword.text == ""
          {
              lblPasswordError.isHidden = false
              lblPasswordPlaceholder.isHidden = true
          }
          else
          {
              lblPasswordError.isHidden = true
              lblPasswordPlaceholder.isHidden = false
          }
      }
      @objc func ConfirmPasswordTextChanged()
      {
          if txtConfirmPassword.text == ""
          {
              lblConfirmPasswordError.isHidden = false
              lblConfirmPasswordPlaceholder.isHidden = true
          }
          else
          {
              lblConfirmPasswordError.isHidden = true
              lblConfirmPasswordPlaceholder.isHidden = false
          }
      }
        
    @objc func txtWechatValueChanged()
          {
//              if txtWechat.text == ""
//              {
//                  lblWechat.isHidden = true
//                  lblWechatError.isHidden = false
//              }
//              else
//              {
//                  lblWechat.isHidden = false
//                  lblWechatError.isHidden = true
//              }
          }
        
    
    @objc func txtCountryValueChanged()
            {
                if txtCountry.text == ""
                {
                    lblCountry.isHidden = true
                    lblCountryError.isHidden = false
                }
                else
                {
                    lblCountry.isHidden = false
                    lblCountryError.isHidden = true
                }
            }
        @objc func InternetAvailable()
        {
            if Connectivity.isConnectedToInternet()
            {
                registerAPI()
            }
            else
            {
                   PopUp(Controller: self, title: "Oops!", message: "No internet connection available", type: .error, time: 2)
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
    
    func register_user(surname: String, givenname: String, uid: String, organization: String)
    {
        let mDatabase = Database.database().reference().child("users")
        let parameter = ["device_token": appDelegate.FcmId, "surname": surname, "organization": organization, "givenname": givenname]

        mDatabase.child(uid).setValue( parameter, withCompletionBlock: {error,ref in
            if error == nil
            {
                print("Registered")
                
            }
            else
            {
                print(error?.localizedDescription)
            }
        })
    }
    
        //-----------------------
        //MARK: Button action
        //-----------------------
        
    @IBAction func btnDropDown(_ sender: UIButton)
    {
        dropDown.show()

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
          
            
        print("Selected item: \(item) at index: \(index)")
            
               self.txtSelectTittle.text = item
            
            
           
        }
        
        
    }
    @IBAction func btnBackTUI(_ sender: UIButton)
           {
               navigationController?.popViewController(animated: true)
           }
        
        
        @IBAction func btnRegister(_ sender: UIButton)
        {
            if (txtSurname.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            {
                PopUp(Controller: self, title: "Oops!", message: "Surname is required", type: .error, time: 3)
            }
            else if (txtGivenName.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty

            {
                     PopUp(Controller: self, title: "Oops!", message: "Givenname is required", type: .error, time: 3)

            }
            else if (txtSelectTittle.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            {
                      PopUp(Controller: self, title: "Oops!", message: "Title is required", type: .error, time: 3)
            }

            else if (txtOrganizer.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                {
                          PopUp(Controller: self, title: "Oops!", message: "Organization is required", type: .error, time: 3)
                }

      
            else if (txtEmail.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                  {
                      PopUp(Controller: self, title: "Oops!", message: "Email is required", type: .error, time: 3)
                  }
                  
            else if validateEmailWithString(txtEmail.text! as NSString)
                  {
                      PopUp(Controller: self, title: "Oops!", message: "Email should be in correct format", type: .error, time: 3)
                  }
                
            else if (txtPhone.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                      {
                          PopUp(Controller: self, title: "Oops!", message: "Phone number is required", type: .error, time: 3)
                      }
                
                else if (txtPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                 {
                     PopUp(Controller: self, title: "Oops!", message: "Password is required", type: .error, time: 3)
                 }
                 else if txtConfirmPassword.text! != txtPassword.text!
                 {
                     PopUp(Controller: self, title: "Oops!", message: "Password and confirm password should be same", type: .error, time: 3)
                 }

//            else if (txtWechat.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
//            {
//                 PopUp(Controller: self, title: "Oops!", message: "Please fill WechatID", type: .error, time: 3)
//            }
                
            else if (txtCountry.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
            {
                PopUp(Controller: self, title: "Oops!", message: "Country is required", type: .error, time: 3)
            }
                


            else
            {
                registerAPI()
            }
            
        
        }
        
    @IBAction func btnCountryTUI(_ sender: UIButton)
    {
        countryDropDown.show()

        countryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
          
            
        print("Selected item: \(item) at index: \(index)")
            
               self.txtCountry.text = item
            
            
           
        }
    }
    
  
        //-----------------------
        //MARK: Web services
        //-----------------------
        
        

        func registerAPI()
        {


            let parameter = ["type":"attendeesSignUp","surname": txtSurname.text!, "givenName": txtGivenName.text!,"title": txtSelectTittle.text!,"organization": txtOrganizer.text!,"email": txtEmail.text!,"phoneNumber": txtPhone.text!,"password": txtPassword.text!,"weChatID":txtWechat.text!,"country":txtCountry.text!,"description":"","profileImage":"","deviceToken":""] as [String : Any]

            print(parameter)

            if Connectivity.isConnectedToInternet()
            {
                timer.invalidate()
                self.start()
                
                let url =  appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                      

                print(" Register Api ==> " + url)
                Alamofire.request( url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                    {
                        response in
                        switch response.result
                        {
                        case .success:
                       
                            self.regiterData = JSON(response.value!)
                            print(self.regiterData)
                            if self.regiterData["status"].boolValue == false
                            {
                                 PopUp(Controller: self, title: "Error!", message: (self.regiterData["msg"].string!), type: .error, time: 3)
                                   self.stopAnimating()
                            }
                            else
                            {
                                self.stopAnimating()

                                self.register_user(surname: self.txtSurname.text!, givenname: self.txtGivenName.text!, uid: self.txtEmail.text!.replacingOccurrences(of: ".", with: "@"), organization: self.txtOrganizer.text!)

                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
                                
                                  self.navigationController?.pushViewController(obj, animated: true)
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

