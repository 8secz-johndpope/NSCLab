//
//  EditProfileVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfileVC: UIViewController {

//-----------------------
        //MARK:Outlets
        //-----------------------
        
     @IBOutlet weak var HeaderView: UIView!

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var viewImage: UIView!
  
    @IBOutlet weak var txtSurname: UITextField!
  
    @IBOutlet weak var txtGivenName: UITextField!
    
    @IBOutlet weak var txtOrganization: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var txtWechatId: UITextField!
    
    @IBOutlet weak var txtAboutMe: UITextView!
   
    @IBOutlet weak var scrollView: UIScrollView!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
     var timer = Timer()
        
    var profileData = JSON()
    
    var updateProfile = JSON()
    
    
    
     //----------------------------
       //MARK: View Life Cycle
       //----------------------------
       
       
     override func viewDidLoad() {
         super.viewDidLoad()

         
          HeaderView.backgroundColor = Colors.HeaderColor
       
        
        txtAboutMe.layer.borderWidth = 1
        txtAboutMe.layer.borderColor = UIColor.lightGray.cgColor
         
         viewImage.layer.borderWidth = 1
         viewImage.layer.borderColor = UIColor.white.cgColor
        viewImage.layer.masksToBounds = false
         viewImage.layer.cornerRadius =  viewImage.frame.height/2
        viewImage.clipsToBounds = true
         // Do any additional setup after loading the view.
        
        profileApi()
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
    
     //-----------------------------
      // MARK: User Defined Function
      //-----------------------------
      
      
  
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
    
      @objc func InternetAvailable()
      {
          if Connectivity.isConnectedToInternet()
          {
               profileApi()
          }
          else
          {
              self.stopAnimating()
             PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
          }
      }
    
    
    @objc func updateProfileInternetAvailable()
         {
             if Connectivity.isConnectedToInternet()
             {
                  updateProfileApi()
             }
             else
             {
                 self.stopAnimating()
                PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
             }
         }
      
      
    
      
         func fillData()
         {
   
            txtSurname.text = UserDefaults.standard.string(forKey: "surname") ?? ""

             txtGivenName.text =   UserDefaults.standard.string(forKey: "givenName") ?? ""

              txtOrganization.text =  UserDefaults.standard.string(forKey: "organization") ?? ""

              txtCountry.text =   UserDefaults.standard.string(forKey: "country") ?? ""

              txtPhone.text =  UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
            
              txtEmail.text =   UserDefaults.standard.string(forKey: "email") ?? ""

              txtWechatId.text =  UserDefaults.standard.string(forKey: "wechatid") ?? ""

              txtAboutMe.text =  UserDefaults.standard.string(forKey: "description") ?? ""

    }
      

      //----------------------------
        //MARK: Button Action
        //----------------------------
        
    @IBAction func btnSaveTUI(_ sender: UIButton)
    {
        updateProfileApi()
    }
    
     @IBAction func btnBackTUI(_ sender: UIButton)
     {
         self.navigationController?.popViewController(animated: true)
     }
     
      //-----------------------
    // MARK: Web Service
    //-----------------------
        func profileApi()
           {

               if Connectivity.isConnectedToInternet()
               {

                let parameter = ["type":"attendeesProfile","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

                print(parameter)
                   timer.invalidate()
                   self.start()

                let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                   print(url)
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

                                 PopUp(Controller: self, title:  "Error!", message: self.profileData["msg"].stringValue, type: .error, time: 2)

                                   self.stopAnimating()
                               }
                               else
                               {
                                   self.stopAnimating()

                               self.profileData = result["attendees"]
                                
                                
                                print(self.profileData)
                                
                                self.fillData()
                    
  

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
    
    
    func updateProfileApi()
            {

                if Connectivity.isConnectedToInternet()
                {

                    let parameter = ["type":"updateAttendeesProfile","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid"),"givenName":txtGivenName.text!,"surname":txtSurname.text!,"organization":txtOrganization.text!,"phoneNumber":txtPhone.text!,"weChatID":txtWechatId.text!,"country":txtCountry.text!,"description":txtAboutMe.text!] as [String : Any]

                 print(parameter)
                    timer.invalidate()
                    self.start()

                 let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                    print(url)
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

                                  PopUp(Controller: self, title:  "Error!", message: self.updateProfile["msg"].stringValue, type: .error, time: 2)

                                    self.stopAnimating()
                                }
                                else
                                {
                                    self.stopAnimating()

 
                                    PopUp(Controller: self, title:  "", message: self.updateProfile["msg"].stringValue, type: .success, time: 2)

                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5)
                                    {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    

                                }
                             }
                            case .failure(let error):
                                print(error)
                            }
                    }

                }
                else
                {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateProfileInternetAvailable), userInfo: nil, repeats: true)
                    PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                }
            }
 }
