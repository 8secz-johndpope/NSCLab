//
//  MapLocationVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class MapLocationVC: UIViewController {

    //-----------------------
       //MARK:Outlets
       //-----------------------
   
  
    
    @IBOutlet weak var lblLocation: UILabel!
    //-------------------------
      // MARK: Identifiers
      //-------------------------
      
      var locationName = String()
    
    
    //----------------------------
     //MARK: View Life Cycle
     //----------------------------
     
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLocation.text! = locationName
        // Do any additional setup after loading the view.
    }
    
    //----------------------------
    //MARK: Button Action
    //----------------------------
    

    @IBAction func btnCopyTUI(_ sender: UIButton)
    {
        UIPasteboard.general.string = locationName
             
             PopUp(Controller: self, title: "", message: "Copied", type: .success, time: 2)
    }
}
