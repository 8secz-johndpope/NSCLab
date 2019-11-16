//
//  ConferenceDetailVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 08/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ConferenceDetailVC: UIViewController {

    //-------------------
        // MARK: Outlets
        //-------------------
        
     
        
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var SubDetailsView: UIView!
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var btnAttend: UIButton!
    @IBOutlet weak var lblHeaderTittle: UILabel!
    
    
    
    //------------------------
            // MARK: Identifiers
            //------------------------
        
    var  topic = String()
    var des =  String ()
    var date = String()
    var timer = Timer()

        //------------------------
          // MARK: View Life Cycle
          //------------------------
          
        override func viewDidLoad() {
            super.viewDidLoad()

            print(conferenceId)
       
              lblTittle.text = topic
            lblDescription.text = "Description: " + des
            
            HeaderView.backgroundColor = Colors.HeaderColor
            SubDetailsView.backgroundColor = Colors.HeaderColor
            
            lblTittle.textColor = UIColor.white
            lblDate.textColor = UIColor.white
          
                     
                 
            btnAttend.layer.borderColor = UIColor.white.cgColor
            btnAttend.layer.borderWidth = 1
            btnAttend.layer.cornerRadius = 6
            btnAttend.clipsToBounds = true
                    
                     
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
                    attendApi()
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
           
           

           
    @IBAction func btnAttendTUI(_ sender: UIButton)
    {
        attendApi()
        
         DispatchQueue.main.asyncAfter(deadline: .now()+0.5)
        {
            self.navigationController?.popViewController(animated: true)
                                        
        }
            }
    
           
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
           
           
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
           //-----------------------
           // MARK: Web Service
           //-----------------------
           
  
           func attendApi()
                    {

                        if Connectivity.isConnectedToInternet()
                        {

                         let parameter = ["type":"conferenceAttendees","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid"),"conference_id":conferenceId] as [String : Any]

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

                                   
                                          PopUp(Controller: self, title:  "", message: result["msg"].stringValue, type: .success, time: 2)
                                     
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
