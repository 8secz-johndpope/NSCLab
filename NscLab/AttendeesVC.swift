//
//  AttendeesVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class AttendeesVC: UIViewController  , UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{

    //-------------------
    // MARK: Outlets
    //-------------------
    

    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    //------------------------
        // MARK: Identifiers
        //------------------------
    
    var isFromPrsentation = false
    
    var timer = Timer()
    
    var sections = [String]()
    
 
    
    var attendessData = JSON()
    var attendessList = JSON()
    
    
    var searchData =  NSMutableArray()
     
  var presentationId = String()
     
     var filterData = NSMutableArray()
     
     var firstNameOrLastNameOrOrg = 2

    var presentationConfId = String()
    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.backgroundColor = Colors.HeaderColor
        
        tblView.rowHeight = 95
        
        lblTittle.text = tittleHeader
        
        searchBarHeight.constant = 0
        
        self.tblView.tableFooterView = UIView()
        
         searchBar.delegate = self
        AttendeesAPI()
        // Do any additional setup after loading the view.
    }
    
    //--------------------------
       // MARK: Table View Methods
       //--------------------------
       
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
       {
      
      
           searchData = searchText.isEmpty ? filterData : (filterData.filter({(text) -> Bool in
            
        
               let dic = text as! NSDictionary
               let tmp: NSString = ((dic["givenName"] as! String) + (dic["surname"] as! String) + (dic["organization"] as! String)) as NSString
            
        
               let range = tmp.range(of: searchText,options: NSString.CompareOptions.caseInsensitive)
            
          
               // If dataItem matches the searchText, return true to include it
               return range.location != NSNotFound
           }) as NSArray).mutableCopy() as! NSMutableArray
           
           
           if searchData.count == 0
           {
             self.attendessList = JSON([])
             self.tblView.reloadData()
              // tblView.isHidden = true
            PopUp(Controller: self, title: "Opps!", message: "NO DATA FOUND", type: .error, time: 3)
           }
           else
           {
             sortNameWise()
             
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
           let cell =  tableView.dequeueReusableCell(withIdentifier: "tblAttendeesCell") as! tblAttendeesCell
           

        
            if firstNameOrLastNameOrOrg == 0
            {
                let boldText = attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                let normalText = " "+attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue
                let normalString = NSMutableAttributedString(string:normalText)

                attributedString.append(normalString)
                
                cell.lblUserName.attributedText = attributedString
                cell.lblUserMsg.attributedText = NSAttributedString(string: attendessList[indexPath.section]["list"][indexPath.row]["organization"].stringValue)
            }
            else if firstNameOrLastNameOrOrg == 1
            {
                let boldText = attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                let normalText = " "+attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue
                let normalString = NSMutableAttributedString(string:normalText)

                attributedString.append(normalString)
                cell.lblUserName.attributedText = attributedString
                cell.lblUserMsg.attributedText = NSAttributedString(string: attendessList[indexPath.section]["list"][indexPath.row]["organization"].stringValue)
            }
            else
            {
                let boldText = attendessList[indexPath.section]["list"][indexPath.row]["organization"].stringValue
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                let normalText = ""
                let normalString = NSMutableAttributedString(string:normalText)

                attributedString.append(normalString)
                cell.lblUserName.text = attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue + " " + attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue
                cell.lblUserMsg.attributedText = attributedString
            }
      
                
               

        
        
        let strArr = [attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue, attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue]
        
        if strArr.count > 1
        {
           
            let str = String(strArr[0][0]) + String(strArr[1][0])
    
            cell.lblNameImg.text = str.uppercased()
            
        }
        else
        {
            let str = String(strArr[0][0]) + String(strArr[0][1])
         
            cell.lblNameImg.text = str.uppercased()
        }

        
                    cell.lblNameImg.textColor = Colors.HeaderColor
                    
                    
                    cell.ViewImg.layer.masksToBounds = false
                    cell.ViewImg.layer.cornerRadius =  cell.ViewImg.frame.height/2
                    cell.ViewImg.clipsToBounds = true
    
           return cell
           
       }
       
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
           let obj = storyboard?.instantiateViewController(withIdentifier: "ProgPeopleDetailVC") as! ProgPeopleDetailVC
        
        if isSpeaker == true
        {
            
            tittleHeader = "Speaker Detail"
            obj.speakerId = attendessList[indexPath.section]["list"][indexPath.row]["p_speaker_id"].stringValue
        }
        else
        {
           
            tittleHeader = "Attendees Detail"
            obj.attendeesId = attendessList[indexPath.section]["list"][indexPath.row]["attendees_id"].stringValue
        }

           navigationController?.pushViewController(obj, animated: true)

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
       
       
    func sortNameWise()
    {
        if firstNameOrLastNameOrOrg == 0
        {
            let sortAttendessArr = searchData.sorted(by: { (($0 as! NSDictionary)["givenName"] as! String).capitalized < (($1 as! NSDictionary)["givenName"] as! String).capitalized })
            
                
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
                         self.sections.append((dic["givenName"] as! String)[0].capitalized)
                         dateStr = (dic["givenName"] as! String)[0].capitalized
                         arr.add(dic)
                         print(arr)
                     }
                     else if (dic["givenName"] as! String)[0].capitalized == dateStr
                     {
                         arr.add(dic)
                         print(arr)
                     }
                     else if (dic["givenName"] as! String)[0].capitalized != dateStr
                     {
                         
                         finalArray.add(["char":dateStr, "list": arr.copy()])
                         print(finalArray)
                         self.sections.append((dic["givenName"] as! String)[0].capitalized)
                         print(finalArray)
                         dateStr = (dic["givenName"] as! String)[0].capitalized
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
        else if firstNameOrLastNameOrOrg == 1
        {
            let sortAttendessArr = searchData.sorted(by: { (($0 as! NSDictionary)["surname"] as! String).capitalized < (($1 as! NSDictionary)["surname"] as! String).capitalized })
            
                
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
                         self.sections.append((dic["surname"] as! String)[0].capitalized)
                         dateStr = (dic["surname"] as! String)[0].capitalized
                         arr.add(dic)
                         print(arr)
                     }
                     else if (dic["surname"] as! String)[0].capitalized == dateStr
                     {
                         arr.add(dic)
                         print(arr)
                     }
                     else if (dic["surname"] as! String)[0].capitalized != dateStr
                     {
                         
                         finalArray.add(["char":dateStr, "list": arr.copy()])
                         print(finalArray)
                         self.sections.append((dic["surname"] as! String)[0].capitalized)
                         print(finalArray)
                         dateStr = (dic["surname"] as! String)[0].capitalized
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
        else
        {
            let sortAttendessArr = searchData.sorted(by: { (($0 as! NSDictionary)["organization"] as! String).capitalized < (($1 as! NSDictionary)["organization"] as! String).capitalized })
            
                
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
    
       
       
       
       
    @IBAction func btnEyeTUI(_ sender: UIButton)
    {
        
        
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Last Name", style: firstNameOrLastNameOrOrg != 1 ? .default : .destructive) { _ in
            
         
            self.firstNameOrLastNameOrOrg = 1
    //------ LAST NAME ---------------------------------------------
            
            if isSpeaker == true
            {
                if self.attendessData["status"].bool != false
                {
                    self.start()
                    
                    let attendessArr = (self.attendessData["speaker_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                             
                    let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["surname"] as! String).capitalized < (($1 as! NSDictionary)["surname"] as! String).capitalized })
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
                                                     self.sections.append((dic["surname"] as! String)[0].capitalized)
                                                     dateStr = (dic["surname"] as! String)[0].capitalized
                                                     arr.add(dic)
                                                     print(arr)
                                                 }
                                                 else if (dic["surname"] as! String)[0].capitalized == dateStr
                                                 {
                                                     arr.add(dic)
                                                     print(arr)
                                                 }
                                                 else if (dic["surname"] as! String)[0].capitalized != dateStr
                                                 {
                                                     
                                                     finalArray.add(["char":dateStr, "list": arr.copy()])
                                                     print(finalArray)
                                                     self.sections.append((dic["surname"] as! String)[0].capitalized)
                                                     print(finalArray)
                                                     dateStr = (dic["surname"] as! String)[0].capitalized
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
                                             self.stopAnimating()
                }
                 
                
            }
            else
            {
                
                if self.attendessData["status"].bool != false
                {
                    self.start()
                    let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                              
                              let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["surname"] as! String).capitalized < (($1 as! NSDictionary)["surname"] as! String).capitalized })
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
                                      self.sections.append((dic["surname"] as! String)[0].capitalized)
                                      dateStr = (dic["surname"] as! String)[0].capitalized
                                      arr.add(dic)
                                      print(arr)
                                  }
                                  else if (dic["surname"] as! String)[0].capitalized == dateStr
                                  {
                                      arr.add(dic)
                                      print(arr)
                                  }
                                  else if (dic["surname"] as! String)[0].capitalized != dateStr
                                  {
                                      
                                      finalArray.add(["char":dateStr, "list": arr.copy()])
                                      print(finalArray)
                                      self.sections.append((dic["surname"] as! String)[0].capitalized)
                                      print(finalArray)
                                      dateStr = (dic["surname"] as! String)[0].capitalized
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
                              self.stopAnimating()
                }
                 
            }
          
            
           }
           actionSheet.addAction(cancelActionButton)
        
        
        
           //------ FIRST NAME ---------------------------------------------

           let saveActionButton = UIAlertAction(title: "First Name", style: firstNameOrLastNameOrOrg != 0 ? .default : .destructive)
               { _ in
                
                
              self.firstNameOrLastNameOrOrg = 0
                
                if isSpeaker == true
                {
                    
                    if self.attendessData["status"].bool != false
                    {
                        self.start()
                        let attendessArr = (self.attendessData["speaker_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                    
                                    let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["givenName"] as! String).capitalized < (($1 as! NSDictionary)["givenName"] as! String).capitalized })
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
                                            self.sections.append((dic["givenName"] as! String)[0].capitalized)
                                            dateStr = (dic["givenName"] as! String)[0].capitalized
                                            arr.add(dic)
                                            print(arr)
                                        }
                                        else if (dic["givenName"] as! String)[0].capitalized == dateStr
                                        {
                                            arr.add(dic)
                                            print(arr)
                                        }
                                        else if (dic["givenName"] as! String)[0].capitalized != dateStr
                                        {
                                            
                                            finalArray.add(["char":dateStr, "list": arr.copy()])
                                            print(finalArray)
                                            self.sections.append((dic["givenName"] as! String)[0].capitalized)
                                            print(finalArray)
                                            dateStr = (dic["givenName"] as! String)[0].capitalized
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
                                    self.stopAnimating()
                    }
                      
                                
                }
                   
                else
                {
                    if self.attendessData["status"].bool != false
                    {
                        self.start()
                        let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                    
                                    let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["givenName"] as! String).capitalized < (($1 as! NSDictionary)["givenName"] as! String).capitalized })
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
                                            self.sections.append((dic["givenName"] as! String)[0].capitalized)
                                            dateStr = (dic["givenName"] as! String)[0].capitalized
                                            arr.add(dic)
                                            print(arr)
                                        }
                                        else if (dic["givenName"] as! String)[0].capitalized == dateStr
                                        {
                                            arr.add(dic)
                                            print(arr)
                                        }
                                        else if (dic["givenName"] as! String)[0].capitalized != dateStr
                                        {
                                            
                                            finalArray.add(["char":dateStr, "list": arr.copy()])
                                            print(finalArray)
                                            self.sections.append((dic["givenName"] as! String)[0].capitalized)
                                            print(finalArray)
                                            dateStr = (dic["givenName"] as! String)[0].capitalized
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
                                    self.stopAnimating()
                    }
                      
                                
                }
                
            
                
           }
           actionSheet.addAction(saveActionButton)
        
        
        
          //------ ORGANIZATION NAME ---------------------------------------------

           let deleteActionButton = UIAlertAction(title: "Organization", style: firstNameOrLastNameOrOrg != 2 ? .default : .destructive)
               { _ in
                  self.firstNameOrLastNameOrOrg = 2
             if isSpeaker == true
             {
                if self.attendessData["status"].bool != false
                {
                    self.start()
                    
                    let attendessArr = (self.attendessData["speaker_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                    
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
                    self.stopAnimating()
                }
                
                           
                }
                else
             {
                
                if self.attendessData["status"].bool != false
                {
                    self.start()
                    
                    let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                    
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
                    self.stopAnimating()
                }
                
                           
                }
           
                
           }
           actionSheet.addAction(deleteActionButton)
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = sender.frame
           self.present(actionSheet, animated: true, completion: nil)
    }
    
       
       
       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       

       func AttendeesAPI()
       {

           if Connectivity.isConnectedToInternet()
           {

               timer.invalidate()
            
               self.start()
            var parameter = [String : Any]()
            
            if isSpeaker == true
            {
                if isFromPrsentation
                {
                    parameter = ["type":"speakerList","conference_id":presentationConfId, "prsentation_id": presentationId] as [String : Any]
                }
                else
                {
                    parameter = ["type":"speakerList","conference_id":conferenceId] as [String : Any]
                }
                 
            }
            else
            {
                  parameter = ["type":"attendeesList","conference_id":conferenceId] as [String : Any]
            }
            
          
            
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
                            
                            
                              self.stopAnimating()
                            
                            
                          
                            
                            if isSpeaker == true
                            {
                                let attendessArr = (self.attendessData["speaker_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                                         
                                                       
                                self.searchData = (self.attendessData["speaker_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                
                                
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
                                                          
                                                        
                            }
                            else
                            {
                                let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                                           
                                                          
                                self.searchData = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                
                                
                             
                                
                                
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
                                                              
                                                            dateStr = (dic["organization"] as! String)[0].capitalized
                                                              
                                                              arr.removeAllObjects()
                                                              
                                                              arr.add(dic)
                                                              
                                                          }
                                                          
                                                          
                                                          if i == sortAttendessArr.count-1
                                                          {
                                                              finalArray.add(["char":dateStr, "list": arr])
                                                              print(finalArray)
                                                          }
                                                      }
                                                      self.attendessList = JSON(finalArray)
                                                      print(self.attendessList)
                                                          
                                                        

                                                                            
                            }
                                
                           
                       

                            
                      
                            self.tblView.reloadData()
                            
                                 self.filterData = self.searchData
                              
                               
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

