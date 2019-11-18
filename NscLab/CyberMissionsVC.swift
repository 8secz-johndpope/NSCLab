//
//  CyberMissionsVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

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
        
    var cyberCategories =  ["Program","My Profile","Message","Attendees","Speakers","Organizations","Photo Sharing","Location","Info","Documents"]
    
    
    var img = [UIImage(named: "icon_calender"),UIImage(named: "icon_documentlist"),UIImage(named: "icon_email"),UIImage(named: "icon_group_fill"),UIImage(named: "icon_audio"),UIImage(named: "icon_blockchain"),UIImage(named: "icon_camera"),UIImage(named: "locationdirection"),UIImage(named: "icon_i"),UIImage(named: "icon_document")]
    
    
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
        
        //------------------------------------
        // MARK: Delegate Methods
        //------------------------------------
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return cyberCategories.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColCyberMissionCell", for: indexPath) as! ColCyberMissionCell
            
       
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
                                tittleHeader = "ATTENDEES"
                                                               
                                  self.navigationController?.pushViewController(obj, animated: true)
                                                                              
                                                                              
                                                                   
                              }
                
                if indexPath.row == 4
                                                                       
                        {
                                                                      
                            let obj = storyboard?.instantiateViewController(withIdentifier: "AttendeesVC") as! AttendeesVC
                                              
                                isSpeaker = true
                                       tittleHeader = "SPEAKERS"
                            
                        
                                                                            
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
                                                                               
                            let obj = storyboard?.instantiateViewController(withIdentifier: "InfoVC") as! InfoVC

                                self.navigationController?.pushViewController(obj, animated: true)
                    }
                
                if indexPath.row == 9
                                    {
                                                                                           
                            let obj = storyboard?.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC

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
        
      
//            @objc func InternetAvailable()
//            {
//                if Connectivity.isConnectedToInternet()
//                {
//                   
//                }
//                else
//                {
//                    self.stopAnimating()
//                    PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//                }
//            }
        
        
        
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
//            func galleryApi()
//            {
//
//                if Connectivity.isConnectedToInternet()
//                {
//
//                    timer.invalidate()
//
//                    self.start()
//
//                    print(appDelegate.apiString + "gallery")
//
//                    Alamofire.request( appDelegate.apiString + "gallery" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
//                        {
//                            response in
//                            switch response.result
//                            {
//                            case .success:
//                                print("Gallery")
//                                let result = response.result.value! as! NSDictionary
//                                print(result)
//                                if (result["status"] as! Int) == 0
//                                {
//                                    PopUp(Controller: self, title: "Error!", message: (result["msg"] as! String))
//                                    self.stopAnimating()
//                                }
//                                else
//                                {
//                                    self.stopAnimating()
//
//                                    self.imgGal = (result["gallery"] as! NSArray).mutableCopy() as! NSMutableArray
//
//
//
//                                    self.colGalleryView.reloadData()
//                                }
//
//                            case .failure(let error):
//                                print(error)
//                            }
//                    }
//
//                }
//                else
//                {
//                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
//                    PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//                }
//            }
//
    }
