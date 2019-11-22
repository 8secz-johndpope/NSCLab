//
//  CyberMissionsVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CyberMissionsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
     
    //------------------------------------
        // MARK: Outlets
        //------------------------------------
        
        
        @IBOutlet weak var colCyberMissionsView: UICollectionView!
        
         @IBOutlet weak var HeaderView: UIView!
        
    @IBOutlet weak var lblTittleHeader: UILabel!
    //------------------------------------
        // MARK: Identifiers
        //------------------------------------
        
        var timer = Timer()
        
    var cyberCategories =  ["Program","My Profile","Message","Attendees","Speakers","Organizations","Photo Sharing","Location","Documents","Info"]
    
    
    var img = [UIImage(named: "icon_calender"),UIImage(named: "icon_documentlist"),UIImage(named: "icon_email"),UIImage(named: "icon_group_fill"),UIImage(named: "icon_audio"),UIImage(named: "icon_blockchain"),UIImage(named: "icon_camera"),UIImage(named: "locationdirection"),UIImage(named: "icon_document"),UIImage(named: "icon_i")]
    
    
    var tittleName = String()
    
    
    
    

           
        //------------------------------------
        // MARK: View Life Cycle
        //------------------------------------
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

          
            HeaderView.backgroundColor = Colors.HeaderColor

            // Do any additional setup after loading the view.
            
            lblTittleHeader.text = tittleName
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        messageBadgeApi()
    }
    
        //------------------------------------
        // MARK: Delegate Methods
        //------------------------------------
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return cyberCategories.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColCyberMissionCell", for: indexPath) as! ColCyberMissionCell
            cell.lblBadge.isHidden = true
            cell.lblBadge.layer.cornerRadius = cell.lblBadge.frame.height/2
            cell.lblBadge.clipsToBounds = true
            cell.lblCyberCategory.text = cyberCategories[indexPath.row]
            cell.lblCyberCategory.textColor = Colors.HeaderColor
       
            cell.imgCyberView.image = img[indexPath.row]
            
            return cell
        }
        
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
            {
        
                if indexPath.row == 0
                {
                        let obj = storyboard?.instantiateViewController(withIdentifier: "ProgramsVC") as! ProgramsVC
            
                    
                    self.navigationController?.pushViewController(obj, animated: true)
                    
                    
                }
        
                if indexPath.row == 1
                {
                                       
                    let obj = storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                                   
                                  
                    self.navigationController?.pushViewController(obj, animated: true)
                                   
                                   
                               }
                if indexPath.row == 2
                                            
                {
                                           
                    let obj = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                                                                
                                                               
                                                 
                    self.navigationController?.pushViewController(obj, animated: true)
                                                                
                                                                
                                                     
                }
                if indexPath.row == 3
                                                          
                              {
                                                         
                                  let obj = storyboard?.instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                                       
                                   isSpeaker = false
                                tittleHeader = "Attendees"
                                                               
                                  self.navigationController?.pushViewController(obj, animated: true)
                                                                              
                                                                              
                                                                   
                              }
                
                if indexPath.row == 4
                                                                       
                        {
                                                                      
                            let obj = storyboard?.instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                                              
                                isSpeaker = true
                                       tittleHeader = "Speakers"
                            
                        
                                                                            
                        self.navigationController?.pushViewController(obj, animated: true)
                                                                                           
                                                                                           
                                                                                
                                           }
                
                if indexPath.row == 5
                                                                                    
                                     {
                                                                                   
                                         let obj = storyboard?.instantiateViewController(withIdentifier: "OrganizationsVC") as! OrganizationsVC
                                                                                                        
                                                
                                                                                         
                                     self.navigationController?.pushViewController(obj, animated: true)
                                                                                                        
                                                                                                        
                                                                                             
                                                        }
                    
                if indexPath.row == 6
              {
                                                        
                    let obj = storyboard?.instantiateViewController(withIdentifier: "PhotoSharingVC") as! PhotoSharingVC
                                                                             
                                                                            
                                                              
                self.navigationController?.pushViewController(obj, animated: true)
                                                                             
                                                                             
                                                                  
                             }
                
                if indexPath.row == 7
                        {
                                                                  
                              let obj = storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                                                                                       
                                                                                      
                                                                        
                          self.navigationController?.pushViewController(obj, animated: true)
                                                                                       
                                                                                       
                                                                            
                                       }
                
                if indexPath.row == 8
                        {
                                                                               
                            let obj = storyboard?.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC

                            self.navigationController?.pushViewController(obj, animated: true)
                    }
                
                if indexPath.row == 9
                                    {
                                        
                                        let obj = storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC

                                        self.navigationController?.pushViewController(obj, animated: true)
                                                                                           
                            
                                }
        
//                let obj = storyboard?.instantiateViewController(withIdentifier: "GalleryDetailVC") as! GalleryDetailVC
//
//                let dic = imgGal[indexPath.row] as! NSDictionary
//
//                 obj.imgZoom = dic["image"] as! String
//
//               present(obj, animated: true, completion: nil)
//
//                colCyberMissionsView.reloadData()
            }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width/3 - 1, height: self.view.frame.width/3 + 10)
            
        }
        //
        //
        //
        //------------------------------------
        // MARK: User Defined Functions
        //------------------------------------
        
      
         @objc func InternetAvailable()
            {
                if Connectivity.isConnectedToInternet()
                {
                    messageBadgeApi()
                }
                else
                {
                    self.stopAnimating()
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                }
            }
        
        
        
        //------------------------------------
        // MARK: Button Actions
        //------------------------------------
        
        
             
        @IBAction func btnBackTUI(_ sender: UIButton)
        {
            navigationController?.popViewController(animated: true)
        }
        
        
        //------------------------------------
        // MARK: Web Services
        //------------------------------------
func messageBadgeApi()
{

    if Connectivity.isConnectedToInternet()
    {

      let parameter = ["type":"dashboardMessage","attendees_id":UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

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
                        if result["flag"].intValue != 0
                        {
                            let cell = self.colCyberMissionsView.cellForItem(at: IndexPath(row: 2, section: 0)) as! ColCyberMissionCell
                            
                            cell.lblBadge.isHidden = false
                        }
                        self.stopAnimating()
                      
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
//
    }
