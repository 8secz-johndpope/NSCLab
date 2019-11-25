//
//  ProgramsDetailVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PresentationDetailVC: UIViewController {

    //-------------------
        // MARK: Outlets
        //-------------------
        
     
        
        @IBOutlet weak var HeaderView: UIView!
        
    @IBOutlet weak var SubDetailsView: UIView!
    
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewSpeakers: UIView!
    //------------------------
            // MARK: Identifiers
            //------------------------
        
   
        var presentationId = String()
          
    var timer = Timer()
    var presentationDetailData = JSON()
    
        //------------------------
          // MARK: View Life Cycle
          //------------------------
          
        override func viewDidLoad() {
            super.viewDidLoad()

            HeaderView.backgroundColor = Colors.HeaderColor
            SubDetailsView.backgroundColor = Colors.HeaderColor
             
            


           
            lblTittle.textColor = UIColor.white
            lblDate.textColor = UIColor.white
            lblTime.textColor = UIColor.white
                     
                 
          presentationDetailApi()
                     
            // Do any additional setup after loading the view.
        }
        
        //--------------------------
           // MARK: Delegate Methods
           //--------------------------
   
           
           //-----------------------------
           // MARK: User Defined Function
           //-----------------------------
           
           
           @objc func InternetAvailable()
           {
               if Connectivity.isConnectedToInternet()
               {
                    presentationDetailApi()
               }
               else
               {
                   self.stopAnimating()
                    PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }
           
           
           
           
           
           //-----------------------
           // MARK: Button Action
           //-----------------------
           
           

      
           @IBAction func btnBackTUI(_ sender: UIButton)
           {
                 navigationController?.popViewController(animated: true)
           }
           
           
  
    
           
           
//           
//    @IBAction func btnLocationTUI(_ sender: UIButton) {
//    }
    
           
    @IBAction func btnStarTUI(_ sender: UIButton)
    {
                if sender.isSelected
                   {
                      
                      sender.isSelected = false
                     
                   }
                   else
                   {
                     
                      sender.isSelected = true

                   }
    }
    
    @IBAction func btnSpeakersTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                              
        isSpeaker = true
        tittleHeader = "Speakers"
        obj.isFromPrsentation = true
        obj.presentationId = presentationId
        obj.presentationConfId = self.presentationDetailData["conference_id"].stringValue
                                                            
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
           //-----------------------
           // MARK: Web Service
           //-----------------------
    func presentationDetailApi()
       {

           if Connectivity.isConnectedToInternet()
           {

            let parameter = ["type":"presentationDetails","presentation_id":presentationId] as [String : Any]

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

                             PopUp(Controller: self, title:  "Error!", message: self.presentationDetailData["msg"].stringValue, type: .error, time: 2)

                               self.stopAnimating()
                           }
                           else
                           {
                               self.stopAnimating()

                           self.presentationDetailData = result["presentation"]
                            
                            
                            print(self.presentationDetailData)
                            
                            
                            self.lblTittle.text! = self.presentationDetailData["topic"].stringValue
                            
                            self.lblDate.text! = dmmmyFormat.string(from: ymdFormat.date(from: self.presentationDetailData["date"].stringValue) ?? Date())
                            
                            self.lblTime.text! = self.presentationDetailData["toTime"].stringValue[0..<5]  + " - " + self.presentationDetailData["fromTime"].stringValue[0..<5]
                            
                            self.lblDescription.text! = "Description: " + self.presentationDetailData["description"].stringValue
                            
                            self.lblLocation.text! = "Address: " + self.presentationDetailData["address"].stringValue
                            
                            if self.presentationDetailData["Speakers"].stringValue == "null"
                            {
                                self.viewSpeakers.isHidden = true
                            }
                            else
                            {
                                 self.lblGroupName.text! = self.presentationDetailData["Speakers"].stringValue
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
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
               PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }

    }
