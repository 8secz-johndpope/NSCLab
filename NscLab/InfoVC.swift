//
//  InfoVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    //-------------------
    // MARK: Outlets
    //-------------------
    

  

    @IBOutlet weak var HeaderView: UIView!
     
    //-------------------
    // MARK: Identifiers
    //-------------------
    
    var VC = UIViewController()
    
    //-----------------------
    // MARK: View Life Cycle
    //-----------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      
     
         HeaderView.backgroundColor = Colors.HeaderColor

      
        
    }
    
    
    
    
    //----------------------------
    // MARK: User Defined Function
    //----------------------------
    
    
    
    
    
    
    
    
    
    
    
    //----------------------
    // MARK: Button Actions
    //----------------------
    
    
   
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    //----------------------
    // MARK: Web Service
    //----------------------
    
    
    

    

}
