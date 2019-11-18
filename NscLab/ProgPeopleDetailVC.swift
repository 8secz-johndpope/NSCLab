//
//  ProgPeopleDetailVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProgPeopleDetailVC: UIViewController {

    //-----------------------
       //MARK:Outlets
       //-----------------------
       
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var lblImgName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddr: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblHeaderTittle: UILabel!
    @IBOutlet weak var viewInterest: UIView!
    
    @IBOutlet weak var viewChat: UIView!
    //-------------------------
       // MARK: Identifiers
       //-------------------------
    
    var speakerId = String()
    var speakerDetailData = JSON()
   var attendeesDetailData = JSON()
    var attendeesId = String()
    
    var timer = Timer()
    
    //----------------------------
      //MARK: View Life Cycle
      //----------------------------
      
      
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
         HeaderView.backgroundColor = Colors.HeaderColor
        lblImgName.textColor = Colors.HeaderColor
        
        lblHeaderTittle.text = tittleHeader
       viewImg.layer.masksToBounds = false
        viewImg.layer.cornerRadius =  viewImg.frame.height/2
       viewImg.clipsToBounds = true
        
        if isSpeaker == true
        {
            SpeakerDetailApi()
        }
        else
        {
            isSpeaker = false
            
             attendeesDetailApi()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    

          @objc func InternetAvailable()
           {
               if Connectivity.isConnectedToInternet()
               {
                   SpeakerDetailApi()
               }
               else
               {
                   self.stopAnimating()
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }

    @objc func attendeedInternetAvailable()
          {
              if Connectivity.isConnectedToInternet()
              {
                attendeesDetailApi()
              }
              else
              {
                  self.stopAnimating()
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
              }
          }

    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnMsgTUI(_ sender: UIButton)
    
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC

                  navigationController?.pushViewController(obj, animated: true)
    }
    
        //-----------------------
       // MARK: Web Service
       //-----------------------
    func SpeakerDetailApi()
        {

            if Connectivity.isConnectedToInternet()
            {

                
             let parameter = ["type":"speakerProfile","p_speaker_id":speakerId] as [String : Any]

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

                            self.speakerDetailData = result["speaker"]
                             
                             
                             print(self.speakerDetailData)
                             
                             
                             self.lblName.text! = self.speakerDetailData[0]["givenName"].stringValue + " " + self.speakerDetailData[0]["surname"].stringValue
                                
                                
                                
                                let strArr = self.speakerDetailData[0]["givenName"].stringValue + " " + self.speakerDetailData[0]["surname"].stringValue
                                    
                                    if strArr.count > 1
                                    {
                                       
                                        let str = String(strArr[0].first!) + String(strArr[1].first!)
                                
                                        self.lblImgName.text = str.uppercased()
                                        
                                    }
                                    else
                                    {
                                        let str = String(strArr[0][0]) + String(strArr[0][1])
                                     
                                        self.lblImgName.text = str.uppercased()
                                    }

                                    
                                self.lblImgName.textColor = Colors.HeaderColor
                                                
                             
                             self.lblAddr.text! = self.speakerDetailData[0]["organization"].stringValue
                             
                             
                             self.lblDescription.text! = "Description: " + self.speakerDetailData[0]["description"].stringValue
                             
                                self.viewChat.isHidden = true
                                self.viewInterest.isHidden = true
                      
                            
                          

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

    
    func attendeesDetailApi()
          {

              if Connectivity.isConnectedToInternet()
              {

                  
               let parameter = ["type":"attendeesProfile","attendees_id":attendeesId] as [String : Any]

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

                              self.attendeesDetailData = result["attendees"]
                               
                               
                               print(self.attendeesDetailData)
                               
                               
                               self.lblName.text! = self.attendeesDetailData["givenName"].stringValue + " " + self.attendeesDetailData["surname"].stringValue
                                  
                                  
                                  
                                  let strArr = self.attendeesDetailData["givenName"].stringValue + " " + self.attendeesDetailData["surname"].stringValue
                                      
                                      if strArr.count > 1
                                      {
                                         
                                          let str = String(strArr[0].first!) + String(strArr[1].first!)
                                  
                                          self.lblImgName.text = str.uppercased()
                                          
                                      }
                                      else
                                      {
                                          let str = String(strArr[0][0]) + String(strArr[0][1])
                                       
                                          self.lblImgName.text = str.uppercased()
                                      }

                                      
                                  self.lblImgName.textColor = Colors.HeaderColor
                                                  
                               
                               self.lblAddr.text! = self.attendeesDetailData["organization"].stringValue
                               
                               
                               self.lblDescription.text! = "Description: " + self.attendeesDetailData["description"].stringValue
                               
                               
                                
                        
                              if self.attendeesDetailData["Interests"].stringValue == "null"
                                                   
                              {
                                                 
                                self.viewInterest.isHidden = true
                                                
                              }
                                                    
                              else
                                                    
                              {
                                                       
                                self.lblInterest.text! =  "Interest: " + self.attendeesDetailData["Interests"].stringValue
                                                  
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
                  self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.attendeedInternetAvailable), userInfo: nil, repeats: true)
                  PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
              }
          }
    
}
