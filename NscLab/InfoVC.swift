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
  
    @IBOutlet weak var txtInfo: UITextView!
    
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
        
        let infoStr = """
<h4><span style="color: #1c71e5; font-size:17px">NSCLab</span></h4>
<p style="font-size:17px">NSCLab is an Australia based research lab with connections to Universities in Asia, North America and Europe. Our primary goal is to provide solutions to the security, privacy, reliability, trust, and performance problems of complex network and system environments. We build and deliver excellence in research and commercial outcomes. NSCLab aspires to be one of the world class research labs in network and system&nbsp;security.&nbsp;</p>
<p style="font-size:17px">This app is created and supported by&nbsp;<span style="color: #1c71e5;">NSCLab</span>.</p>
<p style="font-size:17px">Contact Email: info@nsclab.org</p>
""".html2AttributedString
        
        txtInfo.attributedText = infoStr
     
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
