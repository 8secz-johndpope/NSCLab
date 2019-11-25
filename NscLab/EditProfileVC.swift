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
import SDWebImage
import DropDown

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
     var timer = Timer()
        
    var profileData = JSON()
    
    var updateProfile = JSON()
    
    let countryDropDown = DropDown()
    
     //----------------------------
       //MARK: View Life Cycle
       //----------------------------
       
       
     override func viewDidLoad() {
         super.viewDidLoad()

         
        countryDropDown.anchorView = btnCountry
        countryDropDown.dataSource = ["INDIA", "AUSTRALIA", "US", "UK", "CANADA"]
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              dismiss(animated: true, completion: nil)
              self.imgUser.image = image
              
              uploadImage()
             
          } else{
              print("Something went wrong in  image")
          }
      }
      
    
     //-----------------------------
      // MARK: User Defined Function
      //-----------------------------
      
      
  func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
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
      
      
    
      @objc func UploadImageInternetAvailable()
           {
               if Connectivity.isConnectedToInternet()
               {
                  uploadImage()
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
            
            imgUser.sd_setImage(with: URL(string: "http://" + (profileData["profileImage"].stringValue)), placeholderImage: UIImage(named: "img_user"), options: .refreshCached, completed: nil)

    }
      

      //----------------------------
        //MARK: Button Action
        //----------------------------
        
    @IBAction func btnSaveTUI(_ sender: UIButton)
    {
        if (txtSurname.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            PopUp(Controller: self, title: "Oops!", message: "Lastname is required", type: .error, time: 3)
        }
        else if (txtGivenName.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty

        {
            PopUp(Controller: self, title: "Oops!", message: "Firstname is required", type: .error, time: 3)

        }

        else if (txtOrganization.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            PopUp(Controller: self, title: "Oops!", message: "Organization is required", type: .error, time: 3)
        }

        else if (txtPhone.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
        {
            PopUp(Controller: self, title: "Oops!", message: "Phone number is required", type: .error, time: 3)
        }
            

//            else if (txtWechat.text! as NSString).trimmingCharacters(in: .whitespaces).isEmpty
//            {
//                 PopUp(Controller: self, title: "Oops!", message: "Please fill WechatID", type: .error, time: 3)
//            }
            


        else
        {
            updateProfileApi()
        }
        
    }
    
     @IBAction func btnBackTUI(_ sender: UIButton)
     {
         self.navigationController?.popViewController(animated: true)
     }
     
    @IBAction func btnEditImgTUI(_ sender: UIButton)
    {
               let actionSheet = UIAlertController(title: "Choose", message: "Choose a option", preferredStyle: .actionSheet)
                
        //        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
        //
        //            self.openCamera()
        //        }))
                
                actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
                    self.photoLibrary()
                }))
                
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                   
        actionSheet.popoverPresentationController?.sourceView = self.view
                                      
          
        actionSheet.popoverPresentationController?.sourceRect = sender.frame
                              
        self.present(actionSheet, animated: true, completion: nil)
                
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
                                self.updateProfile = result
                             print(result)
                             if result["status"].boolValue == false
                                {

                                  PopUp(Controller: self, title:  "Error!", message: self.updateProfile["msg"].stringValue, type: .error, time: 2)

                                    self.stopAnimating()
                                }
                                else
                                {
                                    self.stopAnimating()

 
                                    PopUp(Controller: self, title:  "Done!", message: self.updateProfile["msg"].stringValue, type: .success, time: 2)
                                    
                                    UserDefaults.standard.set(self.txtWechatId.text!, forKey: "wechatid")
                                    UserDefaults.standard.set(self.txtOrganization.text!, forKey: "organization")
                                    UserDefaults.standard.set(self.txtGivenName.text!, forKey: "givenName")
                                    UserDefaults.standard.set(self.txtSurname.text!, forKey: "surname")
                                    
                                    UserDefaults.standard.set(self.txtAboutMe.text!, forKey: "description")
                                     
                                    UserDefaults.standard.set(self.txtPhone.text!, forKey: "phoneNumber")
                                       UserDefaults.standard.set(self.txtCountry.text!, forKey: "country")
                                    self.btnSave.setTitle("Saved", for: .normal)
//                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5)
//                                    {
//                                        self.navigationController?.popViewController(animated: true)
//                                    }
                                    

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
    
    
    
    
     func uploadImage()
      {
        
        self.start()
        var parameter = [String : Any]()
        
        parameter = ["type":"attendeesProfile","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid")]
        
        let url = appDelegate.ApiImageUrl + parameterConvert(pram: parameter)
                         
        print(url)
          let image = self.imgUser.image
          let imgData = image?.jpegData(compressionQuality: 0.50)
          print(imgData)
          
         
          if Connectivity.isConnectedToInternet()
          {
             
              timer.invalidate()
              Alamofire.upload(multipartFormData: { multipartFormData in
                  
                  multipartFormData.append(imgData!, withName: "fileUpload",fileName: "file.jpg", mimeType: "image/jpg")
                  
                  
                  
              },to: url )
              { (result) in
                  switch result {
                  case .success(let upload, _, _):
                      
                      
                      upload.uploadProgress(closure: { (progress) in
                          
                          
//                          print("Upload Progress: \(progress.fractionCompleted)")
                          
                          
//                          self.uploadingView.isHidden = false
//
//                          self.uploadProgressView.progress = Float(progress.fractionCompleted)
//
                          
//                          print("Upload Progress: \(progress.fractionCompleted)")
                          
                          
                          
//                          let progressPercent = Int(progress.fractionCompleted*100)
                          
//                          self.lblProgressCount.text = "\(progressPercent)%"
                          
                          
                          
                          
                      })
                      
                      upload.responseJSON { response in
                          print(response.result.value!)
                          let result = response.result.value! as! NSDictionary
                          if (result["success"] as! Int) == 0
                          {
                             
                             
                            PopUp(Controller: self, title: "oops!", message: (result["msg"] as! String), type: .error, time: 2)
                          }
                          else
                          {
                              
                              print(result)
                              UserDefaults.standard.set("http://"+(result["file_url"] as! String), forKey: "profilePic")
                            PopUp(Controller: self, title: "Done", message: (result["msg"] as! String), type: .error, time: 2)
                            
//                              self.editImage = (result["image"] as! String)
//
//
//
//                              self.uploadingView.isHidden = true

                          }
                        self.stopAnimating()
                          
                      }
                      
                  case .failure(let encodingError):
                      print(encodingError)
                  }
              }
          }
          else
          {
              self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.UploadImageInternetAvailable), userInfo: nil, repeats: true)
             PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
          }
          
      }
    
 }
