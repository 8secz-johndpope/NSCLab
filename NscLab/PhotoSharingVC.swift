//
//  PhotoSharingVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class PhotoSharingVC: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

  
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var viewBtn: UIView!

    
   @IBOutlet weak var HeaderView: UIView!
    
    
    
    //-------------------------
    // MARK: Identifiers
    //-------------------------
   var  keyboardHight = CGFloat()
     var iPhoneXorNot = 0
    var sharingData = JSON()
    var timer = Timer()
    var UploadImage = UIImage()

    //-------------------------
     // MARK: View Life Cycle
     //-------------------------
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     HeaderView.backgroundColor = Colors.HeaderColor
       
        messageView.layer.borderColor = UIColor.lightGray.cgColor
          messageView.layer.borderWidth = 0.5
                  messageView.layer.cornerRadius = 6
                  messageView.clipsToBounds = true
        
        viewBtn.layer.masksToBounds = false
        viewBtn.layer.cornerRadius =  6
        viewBtn.clipsToBounds = true
        
        txtField.delegate = self

        
        tblChat.rowHeight = 200
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
        
        
        
        
    }
    
  override func viewWillAppear(_ animated: Bool)
    {
          photoSharingApi()
    }
    
    //------------------------------------
    //MARK: Delegate method
    //------------------------------------
    
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return sharingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {

      
            let cell = tblChat.dequeueReusableCell(withIdentifier: "tblPhotoSharingCell") as! tblPhotoSharingCell

   
        cell.imgPhoto.sd_setImage(with: URL(string: "http://" + (sharingData[indexPath.row]["photoPath"].stringValue)), placeholderImage: UIImage(named: "logo"), options: .refreshCached, completed: nil)
    
        print( "http://" + (sharingData[indexPath.row]["photoPath"].stringValue))
       
        cell.lblDescription.text = sharingData[indexPath.row]["description"].stringValue
    
        
        cell.imgUser.sd_setImage(with: URL(string: "http://" + (sharingData[indexPath.row]["profileImage"].stringValue)), placeholderImage: UIImage(named: "logo"), options: .refreshCached, completed: nil)
        
        cell.lblDate.isHidden = true
    
        cell.lblTime.isHidden = true
        
        cell.imgUser.layer.masksToBounds = false
        cell.imgUser.layer.cornerRadius =  cell.imgUser.frame.height/2
        cell.imgUser.clipsToBounds = true
              
        cell.viewPhoto.layer.masksToBounds = false
        cell.viewPhoto.layer.cornerRadius =  6
        cell.viewPhoto.clipsToBounds = true
        

            return cell
//        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        self.view.endEditing(true)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              dismiss(animated: true, completion: nil)
              self.UploadImage = image
              
              uploadImage()
             
          } else{
              print("Something went wrong in  image")
          }
      }
      
    
    //------------------------------------
    //MARK: User Define Function
    //------------------------------------
    
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            print(self.messageView.frame.origin.y)
            print(self.view.frame.maxY)
            if self.view.frame.maxY - self.messageView.frame.origin.y == 85
            {
                iPhoneXorNot = 0
            }
            else
            {
                iPhoneXorNot = 1
            }
            if self.messageView.frame.origin.y == self.view.frame.maxY - 85 || self.messageView.frame.origin.y == self.view.frame.maxY - 143
            {
                if iPhoneXorNot == 0
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y -= keyboardSize.height
                    keyboardHight = keyboardSize.height
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y + keyboardSize.height, right: 0)
                        
                    }
                }
                else
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y -= keyboardSize.height - 30
                    keyboardHight = keyboardSize.height
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y + keyboardSize.height, right: 0)
                    }
                }
                
                //self.tblChatroom.frame.origin.y -= keyboardSize.height
                print(self.messageView.frame.origin.y)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            print(keyboardSize.height)
            print(self.messageView.frame.origin.y)
            if self.messageView.frame.origin.y != self.view.frame.maxY - 85 && self.messageView.frame.origin.y != self.view.frame.maxY - 143
            {
                if iPhoneXorNot == 0
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y += keyboardHight
                    
                    //self.tblChatroom.frame.origin.y += keyboardSize.height
                    
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y, right: 0)
                    }
                }
                else
                {
                    self.messageView.frame.origin.y += keyboardHight - 30
                    
                    //self.tblChatroom.frame.origin.y += keyboardSize.height
                    
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y, right: 0)
                    }
                }
                
                
                print(self.messageView.frame.origin.y)
                
                
            }
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
    
    
    @objc func InternetAvailable()
            {
                if Connectivity.isConnectedToInternet()
                {
                  photoSharingApi()
                }
                else
                {
                    self.stopAnimating()
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                }
            }

    //------------------------------------
    //MARK: Button Actions
    //------------------------------------
  
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareTUI(_ sender: UIButton)
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
    
    
    
    //------------------------------------
    //MARK:Web services
    //------------------------------------

     func uploadImage()
          {
            
            var parameter = [String : Any]()
            
            parameter = ["type":"sharing","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid"),"conference_id": conferenceId,"description":txtField.text!]
            
            
            let url = appDelegate.ApiImageUrl + parameterConvert(pram: parameter)
                             
            print(url)
              let image = self.UploadImage
            let imgData = image.jpegData(compressionQuality: 0.50)
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
                                  
                                PopUp(Controller: self, title: "Done", message: (result["msg"] as! String), type: .error, time: 2)
                                
    //                              self.editImage = (result["image"] as! String)
    //
    //
    //
    //                              self.uploadingView.isHidden = true
                                self.photoSharingApi()
                                
                          
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
    
    
    
     func photoSharingApi()
                {

                    if Connectivity.isConnectedToInternet()
                    {

                      let parameter = ["type":"photoSharingList","conference_id":conferenceId] as [String : Any]

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

                                      PopUp(Controller: self, title:  "Error!", message: self.sharingData["msg"].stringValue, type: .error, time: 2)

                                        self.stopAnimating()
                                    }
                                    else
                                    {
                                        self.stopAnimating()

                                 self.sharingData = result["photosharing_list"]
                                     
                                 
                                     
                                     print(self.sharingData)
                                     
                                     self.tblChat.reloadData()
                         
       

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
