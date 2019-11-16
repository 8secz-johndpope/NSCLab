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

var tittleHeader = String()
class AttendeesVC: UIViewController  , UITableViewDataSource, UITableViewDelegate{

    //-------------------
    // MARK: Outlets
    //-------------------
    
     @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    //------------------------
        // MARK: Identifiers
        //------------------------
    
    
    var timer = Timer()
    
    var sections = [String]()
    
    var items = [
        
                ["Annika","Govin","Govin Aosschalk"],
                ["Annika Barton","Govin Aosschalk","Aosschalk"],
                 ["Annika","Govin Aosschalk","Govin Aosschalk"],
                  ["Annika Barton","Govin Aosschalk","Aosschalk"],
                  ["Annika Barton","Govin Aosschalk","Govin Aosschalk"],
                  ["Annika Barton","Govin Aosschalk","Govin Aosschalk"]
    ]
    
  
    
    var addr = ["354 Docland","355 Docland","355 Docland"]
    var attendessData = JSON()
    var attendessList = JSON()
    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.backgroundColor = Colors.HeaderColor
        
        tblView.rowHeight = 95
        
        lblTittle.text = tittleHeader
        
        searchBar.isHidden = true
        
        self.tblView.tableFooterView = UIView()
        
        
        AttendeesAPI()
        // Do any additional setup after loading the view.
    }
    
    //--------------------------
       // MARK: Table View Methods
       //--------------------------
       
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
           

      
                cell.lblUserName.text = attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue + " " + attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue
                cell.lblUserMsg.text = attendessList[indexPath.section]["list"][indexPath.row]["organization"].stringValue
               

        
        
        let strArr = [attendessList[indexPath.section]["list"][indexPath.row]["givenName"].stringValue, attendessList[indexPath.section]["list"][indexPath.row]["surname"].stringValue]
        
        if strArr.count > 1
        {
           
            let str = String(strArr[0].first!) + String(strArr[1].first!)
    
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
    
       
       
       
       
    @IBAction func btnEyeTUI(_ sender: UIButton)
    {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Last Name", style: .default) { _ in
            
            self.start()
            
            let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
            
            let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["surname"] as! String) < (($1 as! NSDictionary)["surname"] as! String) })
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
                    self.sections.append((dic["surname"] as! String)[0])
                    dateStr = (dic["surname"] as! String)[0]
                    arr.add(dic)
                    print(arr)
                }
                else if (dic["surname"] as! String)[0] == dateStr
                {
                    arr.add(dic)
                    print(arr)
                }
                else if (dic["surname"] as! String)[0] != dateStr
                {
                    
                    finalArray.add(["char":dateStr, "list": arr.copy()])
                    print(finalArray)
                    self.sections.append((dic["surname"] as! String)[0])
                    print(finalArray)
                    dateStr = (dic["surname"] as! String)[0]
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
           actionSheet.addAction(cancelActionButton)

           let saveActionButton = UIAlertAction(title: "First Name", style: .default)
               { _ in
                
                
                self.start()
                
                let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                
                let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["givenName"] as! String) < (($1 as! NSDictionary)["givenName"] as! String) })
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
                        self.sections.append((dic["givenName"] as! String)[0])
                        dateStr = (dic["givenName"] as! String)[0]
                        arr.add(dic)
                        print(arr)
                    }
                    else if (dic["givenName"] as! String)[0] == dateStr
                    {
                        arr.add(dic)
                        print(arr)
                    }
                    else if (dic["givenName"] as! String)[0] != dateStr
                    {
                        
                        finalArray.add(["char":dateStr, "list": arr.copy()])
                        print(finalArray)
                        self.sections.append((dic["givenName"] as! String)[0])
                        print(finalArray)
                        dateStr = (dic["givenName"] as! String)[0]
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
           actionSheet.addAction(saveActionButton)

           let deleteActionButton = UIAlertAction(title: "Organization", style: .default)
               { _ in
                  
                
                self.start()
                
                let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                
                let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["organization"] as! String) < (($1 as! NSDictionary)["organization"] as! String) })
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
                        self.sections.append((dic["organization"] as! String)[0])
                        dateStr = (dic["organization"] as! String)[0]
                        arr.add(dic)
                        print(arr)
                    }
                    else if (dic["organization"] as! String)[0] == dateStr
                    {
                        arr.add(dic)
                        print(arr)
                    }
                    else if (dic["organization"] as! String)[0] != dateStr
                    {
                        
                        finalArray.add(["char":dateStr, "list": arr.copy()])
                        print(finalArray)
                        self.sections.append((dic["organization"] as! String)[0])
                        print(finalArray)
                        dateStr = (dic["organization"] as! String)[0]
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
            
                let parameter = ["type":"attendeesList","conference_id":conferenceId] as [String : Any]
            
               let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
               print(url)
               Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                   {
                       response in
                       switch response.result
                       {
                       case .success:
                           print("Upcoming Events")
                           //let result = JSON(response.value!)
                           self.attendessData = JSON(response.value!)
                           print(self.attendessData)
                           if self.attendessData["status"].boolValue == false
                           {
                               
                            PopUp(Controller: self, title: "Error!", message: (self.attendessData["msg"].stringValue), type: .error, time: 2)
                               self.stopAnimating()
                           }
                           else
                           {
                                
                            let attendessArr = (self.attendessData["attendees_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                            
                            let sortAttendessArr = attendessArr.sorted(by: { (($0 as! NSDictionary)["givenName"] as! String) < (($1 as! NSDictionary)["givenName"] as! String) })
                            var dateStr = ""
                            //var finalDic = NSMutableDictionary()
                            let arr = NSMutableArray()
                            let finalArray = NSMutableArray()
                            for i in 0...(sortAttendessArr.count-1)
                            {
                                let dic = sortAttendessArr[i] as! NSDictionary
                                
                                if i == 0
                                {
                                    self.sections.append((dic["givenName"] as! String)[0])
                                    dateStr = (dic["givenName"] as! String)[0]
                                    arr.add(dic)
                                    print(arr)
                                }
                                else if (dic["givenName"] as! String)[0] == dateStr
                                {
                                    arr.add(dic)
                                    print(arr)
                                }
                                else if (dic["givenName"] as! String)[0] != dateStr
                                {
                                    
                                    finalArray.add(["char":dateStr, "list": arr.copy()])
                                    print(finalArray)
                                    self.sections.append((dic["givenName"] as! String)[0])
                                    print(finalArray)
                                    dateStr = (dic["givenName"] as! String)[0]
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

