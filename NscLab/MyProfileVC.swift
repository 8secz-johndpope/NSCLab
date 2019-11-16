//
//  MyProfileVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {

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
      
            // Do any additional setup after loading the view.
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
    
    }
