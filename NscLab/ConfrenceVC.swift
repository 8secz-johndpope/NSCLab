//
//  ConfrenceVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 08/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConfrenceVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    //-------------------
    // MARK: Outlets
    //-------------------
    
   
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var colUpcomingView: UICollectionView!
    
    @IBOutlet weak var colAttendView: UICollectionView!
    
    
    @IBOutlet weak var colPastView: UICollectionView!
   
    @IBOutlet weak var colUpcomingHeight: NSLayoutConstraint!
    @IBOutlet weak var colAttendHeight: NSLayoutConstraint!
    @IBOutlet weak var colPastHeight: NSLayoutConstraint!
    //------------------------
        // MARK: Identifiers
        //------------------------
    
  
    var scrollBarTimer = Timer()
    
    var upcomingConferenceData = JSON()
    var attendingConferenceData = JSON()
    
    var pastconferenceData = JSON()
    
    var timer = Timer()

    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        print(conferenceId)
        
        HeaderView.backgroundColor = Colors.HeaderColor
      
        
        
           upcomingConferenceApi()
        
       pastConferenceApi()
                
//        attendingConferenceApi()
        
     
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
      {
          //scrollBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showScrollBar), userInfo: nil, repeats: true)
          startTimerForShowScrollIndicator()
          
      }
    
    //--------------------------
       // MARK: Table View Methods
       //--------------------------
       
    
  
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
         {
            if  collectionView.tag == 0
            {
                 return upcomingConferenceData.count
            }
            else if collectionView.tag == 1
            {
                 return upcomingConferenceData.count
            }
            else
            {
                 return pastconferenceData.count
            }
                   
               }
               
    
    
    
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

                 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColConferenceCell", for: indexPath) as! ColConferenceCell

                if  collectionView.tag == 0
                {
                    cell.lblTittle.text =   upcomingConferenceData[indexPath.row]["topic"].stringValue

                    cell.lblDate.text = upcomingConferenceData[indexPath.row]["date"].string

                    let strarray = upcomingConferenceData[indexPath.row]["date"].string!.components(separatedBy: "-")

                    print(strarray)

                    cell.lblCalenderDate.text = strarray[2]


                }
                else  if  collectionView.tag == 1
                    {
                         cell.lblTittle.text =   upcomingConferenceData[indexPath.row]["topic"].stringValue
                                                       
                        cell.lblDate.text = upcomingConferenceData[indexPath.row]["date"].string
               
                        let strarray = upcomingConferenceData[indexPath.row]["date"].string!.components(separatedBy: "-")

                        print(strarray)

                        cell.lblCalenderDate.text = strarray[2]

                    }
        
                    else  if  collectionView.tag == 2
                {
                    cell.lblTittle.text = pastconferenceData[indexPath.row]["topic"].stringValue
                    
                    cell.lblDate.text = pastconferenceData[indexPath.row]["date"].string
        }
                                   
  

                   return cell
               }
               
                
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
                   {
         
             if collectionView.tag == 0
                    {
                        let obj = storyboard?.instantiateViewController(withIdentifier: "ConferenceDetailVC") as! ConferenceDetailVC

                         obj.topic = upcomingConferenceData[indexPath.row]["topic"].stringValue
                          obj.des = upcomingConferenceData[indexPath.row]["description"].stringValue
                        obj.date = upcomingConferenceData[indexPath.row]["date"].stringValue
                    
                        conferenceId = upcomingConferenceData[indexPath.row]["conference_id"].stringValue
                              
                            

                        navigationController?.pushViewController(obj, animated: true)
                    }
                   else if collectionView.tag == 1
                             {
                       let obj = storyboard?.instantiateViewController(withIdentifier: "CyberMissionsVC") as! CyberMissionsVC

                                 obj.tittleName = upcomingConferenceData[indexPath.row]["topic"].stringValue
                                 
                                 conferenceId = upcomingConferenceData[indexPath.row]["conference_id"].stringValue
                             
                                  print(conferenceId)
                                 
                           navigationController?.pushViewController(obj, animated: true)
                            }

                    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: self.view.frame.width, height: 90)
               
           }
       //-----------------------------
       // MARK: User Defined Function
       //-----------------------------
       
    
    @objc func showScrollBar()
     {
        
         colUpcomingView.flashScrollIndicators()
       
        
    
        colAttendView.flashScrollIndicators()
        
       
        colPastView.flashScrollIndicators()
     }
     @objc func showScrollIndicatorsInContacts()
     {
         UIView.animate(withDuration: 0.0001)
         {
             self.colUpcomingView.flashScrollIndicators()
            
            self.colAttendView.flashScrollIndicators()
         
            
            self.colPastView.flashScrollIndicators()
    
         }
     }
     func startTimerForShowScrollIndicator() {
         self.scrollBarTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
     }
       @objc func upcomingConferenceInternetAvailable()
                {
                    if Connectivity.isConnectedToInternet()
                    {
                       upcomingConferenceApi()
                    }
                    else
                    {
                        self.stopAnimating()
                      PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                    }
                }
    
    @objc func attendingConferenceInternetAvailable()
           {
               if Connectivity.isConnectedToInternet()
               {
                  attendingConferenceApi()
               }
               else
               {
                   self.stopAnimating()
                 PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }
      
       @objc func pastConferenceInternetAvailable()
       {
           if Connectivity.isConnectedToInternet()
           {
              pastConferenceApi()
            
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
       

       
       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       func upcomingConferenceApi()
           {

               if Connectivity.isConnectedToInternet()
               {
                
                let parameter = ["type":"upcomingConferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

                print(parameter)
                   timer.invalidate()
                   self.start()
                
                let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                   print("upcoming Conference List ==>> " + url)
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
                                self.colUpcomingHeight.constant = 0
                             //    PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)
                              
                                   self.stopAnimating()
                               }
                               else
                               {
                                   self.stopAnimating()

                               self.upcomingConferenceData = result["conference_list"]
                                
                                print( self.upcomingConferenceData)
                                
                                 self.colUpcomingView.reloadData()
                                
                                self.colAttendView.reloadData()
                                
                           
                               }
                            }
                           case .failure(let error):
                               print(error)
                           }
                   }

               }
               else
               {
                   self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.upcomingConferenceInternetAvailable), userInfo: nil, repeats: true)
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }

     

    
       func attendingConferenceApi()
       {

           if Connectivity.isConnectedToInternet()
           {
            
            let parameter = ["type":"attendingConferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

            print(parameter)
               timer.invalidate()
               self.start()
            
            let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
               print("Attending Conference List ==>> " + url)
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
                             
                            self.colAttendHeight.constant = 0
                           //  PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)
                          
                               self.stopAnimating()
                           }
                           else
                           {
                               self.stopAnimating()

                           self.attendingConferenceData = result["conference_list"]
                            
                            print( self.attendingConferenceData)
                            
                          
                            self.colAttendView.reloadData()
                            
                       
                           }
                        }
                       case .failure(let error):
                           print(error)
                       }
               }

           }
           else
           {
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.attendingConferenceInternetAvailable), userInfo: nil, repeats: true)
               PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }
    
    
    
    
    
    func pastConferenceApi()
         {

             if Connectivity.isConnectedToInternet()
             {
              
              let parameter = ["type":"conferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

              print(parameter)
                 timer.invalidate()
                 self.start()
              
              let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                print("Past Conference List ==>> " + url)
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
                                 self.colPastHeight.constant = 0
                            //   PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)
                            
                                 self.stopAnimating()
                             }
                             else
                             {
                                 self.stopAnimating()

                             self.pastconferenceData = result["conference_list"]
                              
                              print( self.pastconferenceData)
                              
                             
                              self.colPastView.reloadData()
                              
                             }
                          }
                         case .failure(let error):
                             print(error)
                         }
                 }

             }
             else
             {
                 self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.pastConferenceInternetAvailable), userInfo: nil, repeats: true)
                 PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
             }
         }
         
}
