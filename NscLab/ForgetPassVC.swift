//
//  ForgetPassVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ForgetPassVC: UIViewController,UITextFieldDelegate {

    
    
        //-----------------------
        //MARK: Outlets
        //-----------------------
        
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var lblCode: UILabel!
    
    @IBOutlet weak var txtCode: UITextField!
    
    @IBOutlet weak var lblCodeError: UILabel!
    
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var lblConfirmPassword: UILabel!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblConfirmPasswordError: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
     
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var btnSendCode: UIButton!
    
      
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
  
    //-----------------------
    //MARK: Identifires
    //-----------------------
            
         
    var timer = Timer()
            
     var forgetData = JSON()
    var codeData = JSON()
    
    var code = String()
    
    

    
         
            //-----------------------
            //MARK: View life cycle
            //-----------------------
            
            override func viewDidLoad()
            {
                super.viewDidLoad()
                
                headerView.backgroundColor = Colors.HeaderColor
                
               
                lblEmailError.isHidden = true
                lblCodeError.isHidden = true
                lblPasswordError.isHidden = true
                lblConfirmPasswordError.isHidden = true
               
                
                
                //----------------------------------------------
//                lblEmail.isHidden = true
//                lblCode.isHidden = true
//                lblPassword.isHidden = true
//                lblConfirmPassword.isHidden = true
               
                       
                
                //----------------------------------------------
                btnRegister.layer.borderColor = UIColor.white.cgColor
                btnRegister.layer.borderWidth = 1
                btnRegister.layer.cornerRadius = 6
                btnRegister.clipsToBounds = true
                
                
                btnSendCode.layer.borderColor = UIColor.white.cgColor
                btnSendCode.layer.borderWidth = 1
                btnSendCode.layer.cornerRadius = 5
                btnSendCode.clipsToBounds = true
                
                
                btnVerify.layer.borderColor = UIColor.white.cgColor
                btnVerify.layer.borderWidth = 1
                btnVerify.layer.cornerRadius = 5
                btnVerify.clipsToBounds = true
                
                
                
              
                //----------------------------------------------
                
                
                txtEmail.delegate = self
                txtCode.delegate = self
                txtPassword.delegate = self
                txtConfirmPassword.delegate = self
              
              
                
                //----------------------------------------------
                
                
    //            txtName.placeholderColor(color: UIColor.white)
    //            txtEmailAddress.placeholderColor(color: UIColor.white)
    //            txtPassword.placeholderColor(color: UIColor.white)
    //            txtConfirmPassword.placeholderColor(color: UIColor.white)
    //
                
            
                //----------------------------------------------
                   
                let Email = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtEmail.frame.height))

                let GivenName = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtCode.frame.height))
            
                let Org = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtPassword.frame.height))

                let confirmPass = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtConfirmPassword.frame.height))

            
                
                   
                   //----------------------------------------------
                   

                    txtEmail.leftView = Email
                    txtCode.leftView = GivenName
                    txtPassword.leftView = Org
                    txtConfirmPassword.leftView = confirmPass
                   

                
                //----------------------------------------------
                              
                
                    txtEmail.leftViewMode = UITextField.ViewMode.always
                    txtCode.leftViewMode = UITextField.ViewMode.always
                    txtPassword.leftViewMode = UITextField.ViewMode.always
                    txtConfirmPassword.leftViewMode = UITextField.ViewMode.always
                 
                   //----------------------------------------------
                
                
                txtEmail.addTarget(self, action: #selector(txtEmailValueChanged), for: .editingChanged)
                txtCode.addTarget(self, action: #selector(txtCodeValueChanged), for: .editingChanged)
               
                  txtPassword.addTarget(self, action: #selector(txtPasswordValueChanged), for: .editingChanged)
                      
                      txtConfirmPassword.addTarget(self, action: #selector(txtConfirmPasswordValueChanged), for: .editingChanged)
               
                //----------------------------------------------
                
                txtEmail.layer.borderColor = UIColor.darkGray.cgColor
                txtEmail.layer.borderWidth = 1
                  txtEmail.layer.cornerRadius = 5
                  txtEmail.clipsToBounds = true
                
                txtCode.layer.borderColor = UIColor.darkGray.cgColor
                txtCode.layer.borderWidth = 1
                  txtCode.layer.cornerRadius = 5
                  txtCode.clipsToBounds = true
                
                txtPassword.layer.borderColor = UIColor.darkGray.cgColor
                txtPassword.layer.borderWidth = 1
                 txtPassword.layer.cornerRadius = 5
                  txtPassword.clipsToBounds = true
                
                txtConfirmPassword.layer.borderColor = UIColor.darkGray.cgColor
                txtConfirmPassword.layer.borderWidth = 1
                  txtConfirmPassword.layer.cornerRadius = 5
                  txtConfirmPassword.clipsToBounds = true
                
                self.hideKeyboardTappedArround()
                
                
            }
            
            
            
            override func viewWillAppear(_ animated: Bool)
            {
                super.viewWillAppear(animated)
                registerKeyboardNotifications()
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
            
            
            func textFieldDidBeginEditing(_ textField: UITextField) {
                scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            }
            
            
            
            
            func textFieldDidEndEditing(_ textField: UITextField) {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
            
            //-----------------------------
            //MARK: User defined functions
            //-----------------------------
            
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
               

               
               @objc func txtPasswordValueChanged()
               {
                   if txtPassword.text == ""
                   {
                       lblPassword.isHidden = true
                       lblPasswordError.isHidden = false
                   }
                   else
                   {
                       lblPassword.isHidden = false
                       lblPasswordError.isHidden = true
                   }
               }
               
               @objc func txtConfirmPasswordValueChanged()
               {
                   if txtConfirmPassword.text == ""
                   {
                       lblConfirmPassword.isHidden = true
                       lblConfirmPasswordError.isHidden = false
                   }
                   else
                   {
                       lblConfirmPassword.isHidden = false
                       lblConfirmPasswordError.isHidden = true
                   }
               }
               
    
    
    @objc func txtCodeValueChanged()
      {
          if txtCode.text == ""
          {
              lblCode.isHidden = true
              lblCodeError.isHidden = false
          }
          else
          {
              lblCode.isHidden = false
              lblCodeError.isHidden = true
          }
      }
            @objc func InternetAvailable()
            {
                if Connectivity.isConnectedToInternet()
                {
                    forgotPasswordAPI()
                }
                else
                {
                    stopAnimating()
                  PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                }
            }
    
        @objc func SendCodeInternetAvailable()
               {
                   if Connectivity.isConnectedToInternet()
                   {
                       sendCodeApi()
                   }
                   else
                   {
                       stopAnimating()
                     PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
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
            
            //-----------------------
            //MARK: Button action
            //-----------------------
            
            
        @IBAction func btnBackTUI(_ sender: UIButton)
                   
        {
                        navigationController?.popViewController(animated: true)
                 
    }
            
            
    @IBAction func btnSendCodeTUI(_ sender: UIButton)
    {
        if txtEmail.text == "" || (txtEmail.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                              
        {
        
            lblEmailError.isHidden = false
                              
        }

                               
        else if validateEmailWithString(txtEmail.text! as NSString)
                               
        {
                                
            lblEmailError.text = "Enter valid Email ID"
                               
            lblEmailError.isHidden = false
                              
        }
        
        else
        {
            sendCodeApi()
        }
    }
    
    
    @IBAction func btnVerifyTUI(_ sender: UIButton)
    {
         if txtCode.text == "" || (txtCode.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
               {
                   lblCodeError.isHidden = false
               }
               else
               {
                   if txtCode.text == code
                   {
                      PopUp(Controller: self, title: "", message: "Your VerificationCode is Sucessfully Verified", type: .success, time: 2)
                   }
                   else
                   {
                      PopUp(Controller: self, title: "", message: "Your VerificationCode is incorrect", type: .error, time: 2)
                   }
                   
               }
        
    }
    
            @IBAction func btnRegister(_ sender: UIButton)
            {
                  if (txtEmail.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                        {
                            PopUp(Controller: self, title: "Oops!", message: "Email is required", type: .error, time: 3)
                        }

                        else if validateEmailWithString(txtEmail.text! as NSString)
                        {
                            
                           PopUp(Controller: self, title: "Oops!", message: "Please enter your valid email address", type: .error, time: 3)
                        }

                  else if (txtPassword.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                                      
                  {
                                    
                    PopUp(Controller: self, title: "Oops!", message: "Password is required", type: .error, time: 3)
                                      
                  }
                                       
                  else if txtConfirmPassword.text! != txtPassword.text!
                                        
                  {
                                          
                    PopUp(Controller: self, title: "Oops!", message: "Password and confirm password should be same", type: .error, time: 3)
                                      
                  }
             
                  else if (txtCode.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
                        {
                           PopUp(Controller: self, title: "Oops!", message: "Please enter your valid OTP", type: .error, time: 3)
                        }
                        else
                        {
                         
                            forgotPasswordAPI()
                        }

            
                    }
    
    
    
          
    //------------------------------
    // MARK: Web Services
    //------------------------------
                
               
    func forgotPasswordAPI()
               
    {
 
                let  parameter = ["type":"updateAttendeesPassword","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid"), "password": txtPassword.text!] as [String : Any]
                            print(parameter)
                    if Connectivity.isConnectedToInternet()
                    {
                        timer.invalidate()
                        //SVProgressHUD.show()
                        self.start()
                        
                        let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                        
                        print("Forgot Password API => " + url)
                        
                        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                            {
                                response in
                               switch response.result
                                                   {
                                                   case .success:
                                                 self.forgetData = JSON(response.value!)
                                                   print(self.forgetData)
                                                                       
                                                 if self.forgetData["status"].boolValue == false
                                                                        
                                                 {
                                                                           
                                                   PopUp(Controller: self, title: "Error!", message: (self.forgetData["msg"].string!), type: .error, time: 3)
                                                                         
                                                   self.stopAnimating()
                                                                       
                                                 }
                                                       else
                                                       {
                                                           self.stopAnimating()

                                           
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

    
    func sendCodeApi()
                
     {
        let  parameter = ["type":"sendResetCode","email": txtEmail.text!] as [String : Any]
                         
        print(parameter)
                     
        if Connectivity.isConnectedToInternet()
                    {
                         timer.invalidate()
                         //SVProgressHUD.show()
                         self.start()
                         
                         let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                         
                         print("Send Code API => " + url)
                         
                         Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                             {
                                 response in
                                  switch response.result
                                                                           
                                  {
                                    case .success:
                                    self.codeData = JSON(response.value!)
                                    print(self.codeData)
                                    
                                    if self.codeData["status"].boolValue == false

                                    {
                                        PopUp(Controller: self, title: "Error!", message: (self.codeData["msg"].stringValue), type: .error, time: 3)
                                            
                                        self.stopAnimating()
                                    }
                                                                             
                                    else
                                            {
                                                self.stopAnimating()
                                                
                                                
                                                
                                                self.code = self.codeData["code"].string!
                                                
                                                print(self.code)
                                                
                              
                                                   PopUp(Controller: self, title: "Success", message: self.codeData["msg"].stringValue,type: .success, time: 3)
                                                
                                                
                                                
                                                
                                                                         
                                    }



                                                                            
                                  case .failure(let error):
                                                                                
                                    print(error)
                                                                            
                                }

                                                                     
                        }
                                                                
                     }
        
        else
                     {
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.SendCodeInternetAvailable), userInfo: nil, repeats: true)
                                            
                        PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                                                              
        }
                                                           
    }


            }
