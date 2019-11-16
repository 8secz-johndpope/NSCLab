//
//  MapVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class MapVC: UIViewController{
    //-------------------
    // MARK: Outlets
    //-------------------
    
    @IBOutlet weak var containerView: UIView!
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnSegment: UISegmentedControl!
    
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
        
      
         btnSegment.layer.borderColor = UIColor.white.cgColor
         btnSegment.layer.borderWidth = 1
         btnSegment.layer.cornerRadius = 6
         btnSegment.clipsToBounds = true
        searchBar.isHidden = true
                  
         HeaderView.backgroundColor = Colors.HeaderColor

        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.HeaderColor], for: .selected)
        
        VC = storyboard?.instantiateViewController(withIdentifier: "MapListVC") as! MapListVC
        self.addChild(VC)
        VC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview(VC.view)
        VC.didMove(toParent: self)

        
    }
    
    
    
    
    //----------------------------
    // MARK: User Defined Function
    //----------------------------
    
    
    
    
    
    
    
    
    
    
    
    //----------------------
    // MARK: Button Actions
    //----------------------
    
    
    @IBAction func btnSegmentTUI(_ sender: UISegmentedControl)
    {
        if btnSegment.selectedSegmentIndex == 0
        {
            VC = storyboard?.instantiateViewController(withIdentifier: "MapListVC") as! MapListVC
                  
            
                  
                  self.addChild(VC)
                  VC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
                  self.containerView.addSubview(VC.view)
                  VC.didMove(toParent: self)
        }
        else if btnSegment.selectedSegmentIndex == 1
        {
           
            VC = storyboard?.instantiateViewController(withIdentifier: "MapLocationVC") as! MapLocationVC
            
            
            self.addChild(VC)
            VC.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.containerView.addSubview(VC.view)
            VC.didMove(toParent: self)
        }
        
        
        
        
    }
    
  
    
  
    @IBAction func btnBackTUI(_ sender: UIButton)
       {
           navigationController?.popViewController(animated: true)
       }
    
    
    @IBAction func btnSearchTUI(_ sender: Any)
    {
        searchBar.isHidden = false
        
    }
    
    
    
    //----------------------
    // MARK: Web Service
    //----------------------
    
    
    

    

}
