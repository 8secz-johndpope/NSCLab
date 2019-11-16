//
//  OrganizationsVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class OrganizationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //-------------------
    // MARK: Outlets
    //-------------------
    
     @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var HeaderView: UIView!
    
  
    @IBOutlet weak var searchBar: UISearchBar!
    
        //------------------------
        // MARK: Identifiers
        //------------------------
    
    
    var sections = ["A","B","C"]
    
    var items = [
        
                ["NSCLab","NSCLab","NSCLab"],
                ["NSC Lab","NSC Lab","NSC Lab"],
                 ["NSCLab","NSCLab","NSCLab"]
    ]
    

    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.backgroundColor = Colors.HeaderColor
        
        tblView.rowHeight = 80
        
        searchBar.isHidden = true
        
      
        
        self.tblView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    //--------------------------
       // MARK: Table View Methods
       //--------------------------
       
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           
           return self.sections[section]
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return self.sections.count
       }
      
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
          {
              return items[section].count
          }
          
       
       func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
       {
           return ([UITableView.indexSearch] + UILocalizedIndexedCollation.current().sectionIndexTitles as NSArray).index(of: title) - 1
       }
       

       func sectionIndexTitles(for tableView: UITableView) -> [String]?
       {
           return sections
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 44
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           let cell =  tableView.dequeueReusableCell(withIdentifier: "tblOrganizationCell") as! tblOrganizationCell
           

        
                cell.lblUserName.text = items[indexPath.section][indexPath.row]
            
               

    
           return cell
           
       }
       
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
//           let obj = storyboard?.instantiateViewController(withIdentifier: "ProgramsDetailVC") as! ProgramsDetailVC
//  
//           navigationController?.pushViewController(obj, animated: true)
           
       }
       

       
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
//        view.tintColor = UIColor.lightGray
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = Colors.HeaderColor
    }
       
       
       //-----------------------------
       // MARK: User Defined Function
       //-----------------------------
       
       
       @objc func InternetAvailable()
       {
           if Connectivity.isConnectedToInternet()
           {
//               ConferenceApi()
           }
           else
           {
               self.stopAnimating()
               showAlert(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
           }
       }
       
       
       
       
       
       //-----------------------
       // MARK: Button Action
       //-----------------------
       
       

    @IBAction func btnSearchTUI(_ sender: UIButton)
    {
        searchBar.isHidden = false
        
    }
    
       
       
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
          navigationController?.popViewController(animated: true)
    }
    
       
       
       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       
//
//       func ConferenceApi()
//       {
//
//           if Connectivity.isConnectedToInternet()
//           {
//
//               timer.invalidate()
//               self.start()
//               print(appDelegate.ApiBaseUrl + "upcommingEvent")
//               Alamofire.request( appDelegate.ApiBaseUrl + "upcommingEvent" , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
//                   {
//                       response in
//                       switch response.result
//                       {
//                       case .success:
//                           print("Upcoming Events")
//                           let result = response.result.value! as! NSDictionary
//                           print(result)
//                           if (result["status"] as! Int) == 0
//                           {
//                               self.lblNoEvents.isHidden = true
//                               PopUp(Controller: self, title: "Error!", message: (result["msg"] as! String))
//                               self.stopAnimating()
//                           }
//                           else
//                           {
//                               self.stopAnimating()
//
//
//                               self.upcomingEventData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
//
//                               if self.upcomingEventData.count == 0
//                               {
//                                   self.lblNoEvents.isHidden = false
//
//                               }
//                               else
//                               {
//
//                                   self.lblNoEvents.isHidden = true
//
//
//                               self.tblView.reloadData()
//                           }
//                           }
//                       case .failure(let error):
//                           print(error)
//                       }
//               }
//
//           }
//           else
//           {
//               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
//               PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//           }
//       }
       

}

