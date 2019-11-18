//
//  MyProfileVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class MyProfileVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   //-----------------------
           //MARK:Outlets
           //-----------------------
           
        @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var viewImage: UIView!
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblOrganization: UILabel!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
   var timer = Timer()
        
        var profileData = JSON()
        //----------------------------
          //MARK: View Life Cycle
          //----------------------------
          
          
        override func viewDidLoad() {
            super.viewDidLoad()

            
             HeaderView.backgroundColor = Colors.HeaderColor
          
            
            viewImage.layer.borderWidth = 1
            viewImage.layer.borderColor = UIColor.white.cgColor
           viewImage.layer.masksToBounds = false
            viewImage.layer.cornerRadius =  viewImage.frame.height/2
           viewImage.clipsToBounds = true
            
            
            lblName.text = (UserDefaults.standard.string(forKey: "givenName") ?? "")  + " " +  (UserDefaults.standard.string(forKey: "surname") ?? "")
            
            lblDescription.text = UserDefaults.standard.string(forKey: "description") ?? ""
            
            lblOrganization.text =  UserDefaults.standard.string(forKey: "organization") ?? ""
      
            
            profileApi()
            // Do any additional setup after loading the view.
        }
    
    
    //--------------------------
      //MARK: Delegate Method
      //--------------------------
      
      
        
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
      
            func fillData()
            {
      
               imgUser.sd_setImage(with: URL(string: "http://" + (profileData["profileImage"].stringValue)), placeholderImage: UIImage(named: "img_user"), options: .refreshCached, completed: nil)

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
    
 
        //----------------------------
          //MARK: Button Action
          //----------------------------
          

        @IBAction func btnBackTUI(_ sender: UIButton)
        {
            self.navigationController?.popViewController(animated: true)
        }
        

    @IBAction func btnProfileTUI(_ sender: UIButton)
    
    {
         let obj = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC

             
        
             navigationController?.pushViewController(obj, animated: true)

           
        
    }
    @IBAction func btnInterestTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "InterestVC") as! InterestVC

                   
              
                   navigationController?.pushViewController(obj, animated: true)
        
    }
    @IBAction func btnLogoutTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc

         UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        
        navigationController?.pushViewController(obj, animated: true)

    }
    
    @IBAction func btnCopyTUI(_ sender: UIButton)
    {
        
        UIPasteboard.general.string = UserDefaults.standard.string(forKey: "wechatid") ?? ""
        
        PopUp(Controller: self, title: "", message: "Copied", type: .success, time: 2)
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
      
    
    
      
         func uploadImage()
          {
            
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
                              
                              
//                              print("Upload Progress: \(progress.fractionCompleted)")
                              
                              
    //                          self.uploadingView.isHidden = false
    //
    //                          self.uploadProgressView.progress = Float(progress.fractionCompleted)
    //
                              
//                              print("Upload Progress: \(progress.fractionCompleted)")
                              
                              
                              
//                              let progressPercent = Int(progress.fractionCompleted*100)
                              
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
                                  
                                PopUp(Controller: self, title: "Done", message: (result["msg"] as! String), type: .error, time: 2)
                                
    //                              self.editImage = (result["image"] as! String)
    //
    //
    //
    //                              self.uploadingView.isHidden = true

                              }
                              
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
