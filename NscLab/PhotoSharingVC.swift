//
//  PhotoSharingVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class PhotoSharingVC: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

  
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
    var sharingData = [UIImage(named: "icon"),UIImage(named: "icon"),UIImage(named: "icon")]

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
    
  
    
    //------------------------------------
    //MARK: Delegate method
    //------------------------------------
    
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return sharingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {

      
            let cell = tblChat.dequeueReusableCell(withIdentifier: "tblPhotoSharingCell") as! tblPhotoSharingCell

   
        cell.imgPhoto.image = sharingData[indexPath.row]
        
        
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
    
    
    
    //------------------------------------
    //MARK: User Define Function
    //------------------------------------
    
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

    //------------------------------------
    //MARK: Button Actions
    //------------------------------------
  
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //------------------------------------
    //MARK:Web services
    //------------------------------------

}
