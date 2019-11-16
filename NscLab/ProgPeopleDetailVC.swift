//
//  ProgPeopleDetailVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

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
    //-------------------------
       // MARK: Identifiers
       //-------------------------
    
    //----------------------------
      //MARK: View Life Cycle
      //----------------------------
      
      
    override func viewDidLoad() {
        super.viewDidLoad()

        
         HeaderView.backgroundColor = Colors.HeaderColor
        lblImgName.textColor = Colors.HeaderColor
        
        
       viewImg.layer.masksToBounds = false
        viewImg.layer.cornerRadius =  viewImg.frame.height/2
       viewImg.clipsToBounds = true
        // Do any additional setup after loading the view.
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
}
