//
//  InterestVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InterestVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    

        //-----------------------
        //MARK:Outlets
        //-----------------------
        
     @IBOutlet weak var HeaderView: UIView!

    @IBOutlet weak var colInteresrtView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtInterest: UITextField!
    //-------------------------
        // MARK: Identifiers
        //-------------------------
     var  keyboardHight = CGFloat()
      
    var iPhoneXorNot = 0
    var interestData = JSON()
    var timer = Timer()
    var interestId = Int()
     //----------------------------
       //MARK: View Life Cycle
       //----------------------------
       
       
     override func viewDidLoad() {
         super.viewDidLoad()

         //-----------------------------------
        
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
         
          HeaderView.backgroundColor = Colors.HeaderColor
       
      //-----------------------------------

       
             btnSave.layer.cornerRadius = 6
             btnSave.clipsToBounds = true
        
        //-----------------------------------
        
                messageView.layer.borderColor = UIColor.lightGray.cgColor
        messageView.layer.borderWidth = 0.5
                messageView.layer.cornerRadius = 6
                messageView.clipsToBounds = true
        
        
        
        let layout = MyLeftCustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        colInteresrtView.collectionViewLayout = layout

        //colInteresrtView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
         // Do any additional setup after loading the view.
        
        
      
     }

    override func viewWillAppear(_ animated: Bool)
    {
          InterestListApi()
    }
        //----------------------------
          //MARK: Delegate Methods
          //----------------------------
          
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return interestData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColInterestCell", for: indexPath) as! ColInterestCell
        
        
        cell.lblInterest.text = " \(interestData[indexPath.row]["interest_name"].stringValue)  "
        cell.btnRemove.tag = indexPath.row
        
        cell.lblInterest.layer.cornerRadius = 20
                   
        cell.lblInterest.clipsToBounds = true
        
        if interestData.count == 1
        {
            cell.btnRemove.isHidden = true
        }
        else
        {
            cell.btnRemove.isHidden = false
        }
                
          
        return cell
        
    }
    
    
    
      //------------------------------------
      //MARK: User Define Function
      //------------------------------------
    
      
    @objc func InternetAvailable()
       {
           if Connectivity.isConnectedToInternet()
           {
               addInterestApi()
           }
           else
           {
               self.stopAnimating()
              PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }
    
    @objc func removeInternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            removeInternetAvailable()
        }
        else
        {
            self.stopAnimating()
           PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
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
                          colInteresrtView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: colInteresrtView.frame.origin.y + keyboardSize.height, right: 0)
                          
                      }
                  }
                  else
                  {
                      print(keyboardSize.height)
                      self.messageView.frame.origin.y -= keyboardSize.height - 30
                      keyboardHight = keyboardSize.height
                      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                          colInteresrtView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: colInteresrtView.frame.origin.y + keyboardSize.height, right: 0)
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
                      
                    if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                          colInteresrtView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: colInteresrtView.frame.origin.y, right: 0)
                      }
                  }
                  else
                  {
                      self.messageView.frame.origin.y += keyboardHight - 30
                      
                      //self.tblChatroom.frame.origin.y += keyboardSize.height
                      
                    if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                          colInteresrtView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: colInteresrtView.frame.origin.y, right: 0)
                      }
                  }
                  
                  
                  print(self.messageView.frame.origin.y)
                  
                  
              }
          }
      
      }
    
    

    //----------------------------
      //MARK: Button Action
      //----------------------------
      
    
    @IBAction func btnSaveTUI(_ sender: UIButton)
    {
        
        addInterestApi()
    }
    
     @IBAction func btnBackTUI(_ sender: UIButton)
     {
         self.navigationController?.popViewController(animated: true)
     }
      
    @IBAction func btnRemoveTUI(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Delete!", message: "Are you sure you want to cancel this interest?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
            print("Download Clicked")
            if self.interestData.count > 1
            {
                self.interestId = self.interestData[sender.tag]["interest_id"].intValue
                self.removeInterestApi()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { action in
            print("Download Clicked")
            
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //-----------------------
    // MARK: Web Service
    //-----------------------
           func addInterestApi()
              {

                  if Connectivity.isConnectedToInternet()
                  {

                    let parameter = ["type":"addAttendeesInterests","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid"),"interest_name":txtInterest.text!] as [String : Any]

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

                                    PopUp(Controller: self, title:  "Error!", message: result["msg"].stringValue, type: .error, time: 2)

                                      self.stopAnimating()
                                  }
                                  else
                                  {
                                      self.stopAnimating()
                                    self.txtInterest.text = ""
                                    self.InterestListApi()
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
       
    
    func InterestListApi()
               {

                   if Connectivity.isConnectedToInternet()
                   {

                     let parameter = ["type":"attendeesInterestsList","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

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

                                     //PopUp(Controller: self, title:  "Error!", message: self.interestData["msg"].stringValue, type: .error, time: 2)

                                       self.stopAnimating()
                                   }
                                   else
                                   {
                                       self.stopAnimating()

                                self.interestData = result["attendees_interest_list"]
                                    
                                
                                    
                                    print(self.interestData)
                                    
                                    self.colInteresrtView.reloadData()
                        
      

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
        
    func removeInterestApi()
    {

        if Connectivity.isConnectedToInternet()
        {

          let parameter = ["type":"deleteInterest","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid"),"interest_id": interestId] as [String : Any]

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

                          PopUp(Controller: self, title:  "Error!", message: result["msg"].stringValue, type: .error, time: 2)

                            self.stopAnimating()
                        }
                        else
                        {
                            self.stopAnimating()
                          
                          self.InterestListApi()
                        }
                     }
                    case .failure(let error):
                        print(error)
                    }
            }

        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.removeInternetAvailable), userInfo: nil, repeats: true)
            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
        }
    }


 }
