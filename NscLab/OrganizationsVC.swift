//
//  OrganizationsVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class OrganizationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{

    //-------------------
    // MARK: Outlets
    //-------------------
    
     @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
        //------------------------
        // MARK: Identifiers
        //------------------------
    
 var timer = Timer()
      var sections = [String]()
 
  var attendessData = JSON()
  var attendessList = JSON()
    
     var searchData =  NSMutableArray()
       
    
       
       var filterData = NSMutableArray()
       
       

    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.backgroundColor = Colors.HeaderColor
        
        tblView.rowHeight = 80
        
        searchBarHeight.constant = 0
        
       searchBar.delegate = self
        
        self.tblView.tableFooterView = UIView()
        
       organizationApi()
        // Do any additional setup after loading the view.
    }
    
    //--------------------------
       // MARK: Table View Methods
       //--------------------------
       
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
          {
         
         
              searchData = searchText.isEmpty ? filterData : (filterData.filter({(text) -> Bool in
               
           
                  let dic = text as! NSDictionary
                  let tmp: NSString = ( (dic["organization"] as! String)) as NSString
               
                print(dic)
                  let range = tmp.range(of: searchText,options: NSString.CompareOptions.caseInsensitive)
               
             
                  // If dataItem matches the searchText, return true to include it
                  return range.location != NSNotFound
              }) as NSArray).mutableCopy() as! NSMutableArray
              
            print(searchData)
            
            
            
              if searchData.count == 0
              {
                self.attendessList = JSON([])
                self.tblView.reloadData()
                 // tblView.isHidden = true
               PopUp(Controller: self, title: "Opps!", message: "NO DATA FOUND", type: .error, time: 3)
              }
              else
              {
                let sortAttendessArr = searchData.sorted(by: { (($0 as! NSDictionary)["organization"] as! String) < (($1 as! NSDictionary)["organization"] as! String) })
                
                    
                     var dateStr = ""
                     //var finalDic = NSMutableDictionary()
                     let arr = NSMutableArray()
                     let finalArray = NSMutableArray()
                     for i in 0...(sortAttendessArr.count-1)
                     {
                         let dic = sortAttendessArr[i] as! NSDictionary
                         
                         if i == 0
                         {
                            self.sections.removeAll()
                             self.sections.append((dic["organization"] as! String)[0].capitalized)
                             dateStr = (dic["organization"] as! String)[0].capitalized
                             arr.add(dic)
                             print(arr)
                         }
                         else if (dic["organization"] as! String)[0].capitalized == dateStr
                         {
                             arr.add(dic)
                             print(arr)
                         }
                         else if (dic["organization"] as! String)[0].capitalized != dateStr
                         {
                             
                             finalArray.add(["char":dateStr, "list": arr.copy()])
                             print(finalArray)
                             self.sections.append((dic["organization"] as! String)[0].capitalized)
                             print(finalArray)
                             dateStr = (dic["organization"] as! String)[0].capitalized
                             print(finalArray)
                             arr.removeAllObjects()
                             print(finalArray)
                             arr.add(dic)
                             print(finalArray)
                         }
                         
                         
                         if i == sortAttendessArr.count-1
                         {
                             finalArray.add(["char":dateStr, "list": arr])
                             print(finalArray)
                         }
                     }
                     self.attendessList = JSON(finalArray)
                     print(self.attendessList)
                     
                     self.tblView.reloadData()
                  tblView.isHidden = false
                
                  
                  
              }
              
          }
          
          func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
              
              self.searchBar.endEditing(true)
              
          }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return attendessList[section]["char"].stringValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return attendessList.count
    }
   
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
           return attendessList[section]["list"].count
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
           

        
            cell.lblUserName.text = attendessList[indexPath.section]["list"][indexPath.row]["organization"].stringValue
        
           
    
           return cell
           
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
                organizationApi()
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
        searchBarHeight.constant = 56
    }
    
       
       
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
          navigationController?.popViewController(animated: true)
    }
    
       
       
       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       func organizationApi()
       {

           if Connectivity.isConnectedToInternet()
           {

               timer.invalidate()
            
               self.start()
            
                let parameter = ["type":"organizationList","conference_id":conferenceId] as [String : Any]
            
               let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
               print(url)
               Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                   {
                       response in
                       switch response.result
                       {
                       case .success:
                           
                           self.attendessData = JSON(response.value!)
                           print(self.attendessData)
                           if self.attendessData["status"].boolValue == false
                           {
                               
                            PopUp(Controller: self, title: "Error!", message: (self.attendessData["msg"].stringValue), type: .error, time: 2)
                               self.stopAnimating()
                           }
                           else
                           {
                                
                            let attendessArr = (self.attendessData["organization_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                            
                            
                            self.searchData = (self.attendessData["organization_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray

                                                                      
                                                    
                            
                            let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["organization"] as! String).capitalized < (($1 as! NSDictionary)["organization"] as! String).capitalized })
                       
                           
                            var dateStr = ""
                            //var finalDic = NSMutableDictionary()
                            let arr = NSMutableArray()
                            let finalArray = NSMutableArray()
                            for i in 0...(sortAttendessArr.count-1)
                            {
                                let dic = sortAttendessArr[i] as! NSDictionary
                                
                                if i == 0
                                {
                                    self.sections.append((dic["organization"] as! String)[0].capitalized)
                                    dateStr = (dic["organization"] as! String)[0].capitalized
                                    arr.add(dic)
                                    print(arr)
                                }
                                else if (dic["organization"] as! String)[0].capitalized == dateStr
                                {
                                    arr.add(dic)
                                    print(arr)
                                }
                                else if (dic["organization"] as! String)[0].capitalized != dateStr
                                {
                                    
                                    finalArray.add(["char":dateStr, "list": arr.copy()])
                                    print(finalArray)
                                    self.sections.append((dic["organization"] as! String)[0].capitalized)
                                    print(finalArray)
                                    dateStr = (dic["organization"] as! String)[0].capitalized
                                    print(finalArray)
                                    arr.removeAllObjects()
                                    print(finalArray)
                                    arr.add(dic)
                                    print(finalArray)
                                }
                                
                                
                                if i == sortAttendessArr.count-1
                                {
                                    finalArray.add(["char":dateStr, "list": arr])
                                    print(finalArray)
                                }
                            }
                            self.attendessList = JSON(finalArray)
                            print(self.attendessList)
                            
                            self.tblView.reloadData()
                            
                            self.filterData = self.searchData

                                self.stopAnimating()
                               
                           }
                       case .failure(let error):
                           print(error)
                       }
               }

           }
           else
           {
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 1)
           }
       }
       

}

