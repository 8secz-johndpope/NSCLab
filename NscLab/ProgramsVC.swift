//
//  ProgramsVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProgramsVC: UIViewController , UITableViewDataSource, UITableViewDelegate{

    //-------------------
    // MARK: Outlets
    //-------------------
    
     @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var HeaderView: UIView!
    
    
        //------------------------
        // MARK: Identifiers
        //------------------------
    
    var timer = Timer()
    var programData = JSON()
    var programId = String()    
    var programList = JSON()
    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        print(conferenceId)
        
         programListApi()
        
        HeaderView.backgroundColor = Colors.HeaderColor
        
        tblView.rowHeight = 95
        
        self.tblView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    //--------------------------
    // MARK: Table View Methods
    //--------------------------
       
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return programList[section]["date"].stringValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return programList.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return programList[section]["list"].count
    }
       
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           let cell =  tableView.dequeueReusableCell(withIdentifier: "tblProgramCell") as! tblProgramCell
           
     
        
        cell.lblTittle.text = programList[indexPath.section]["list"][indexPath.row]["topic"].stringValue
        
     
//        cell.lblAddress.text = programData[indexPath.row]["address"].stringValue
        
        cell.lblAddress.isHidden = true
        
        cell.lblTime.text = programList[indexPath.section]["list"][indexPath.row]["toTime"].stringValue  + " - " + programList[indexPath.section]["list"][indexPath.row]["fromTime"].stringValue
        
        
       
      
           
           return cell
           
       }
       
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
           let obj = storyboard?.instantiateViewController(withIdentifier: "ProgramDetailVC") as! ProgramDetailVC
        
        obj.tittleName = programList[indexPath.section]["list"][indexPath.row]["topic"].stringValue
        
        obj.date = programList[indexPath.section]["list"][indexPath.row]["toDate"].stringValue + " - " + programList[indexPath.section]["list"][indexPath.row]["from_date"].stringValue
        
        obj.time = programList[indexPath.section]["list"][indexPath.row]["toTime"].stringValue  + " - " + programList[indexPath.section]["list"][indexPath.row]["fromTime"].stringValue
        obj.desc = programList[indexPath.section]["list"][indexPath.row]["description"].stringValue
        
        obj.addr = programList[indexPath.section]["list"][indexPath.row]["address"].stringValue
        
        obj.programId = programList[indexPath.section]["list"][indexPath.row]["program_id"].stringValue
  
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
                programListApi()
           }
           else
           {
               self.stopAnimating()
              PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }
       
       
       
       
       
       //-----------------------
       // MARK: Button Action
       //-----------------------
       
       

       
       
       
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
          navigationController?.popViewController(animated: true)
    }

       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       
//
   func programListApi()
   {

       if Connectivity.isConnectedToInternet()
       {
        
        let parameter = ["type":"programList","conference_id":conferenceId] as [String : Any]

        print(parameter)
           timer.invalidate()
           self.start()
        
        let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
           print(url)
           Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
               {
                   response in
                   switch response.result
                   {
                   case .success:
                    if response.response?.statusCode == 200
                    {

                        let result = JSON(response.value!)

                    print(result)
                    if result["status"].boolValue == false
                       {
                         
                         PopUp(Controller: self, title:  "Error!", message: self.programData["msg"].stringValue, type: .error, time: 2)
                      
                           self.stopAnimating()
                       }
                       else
                       {
                           self.stopAnimating()

                       self.programData = result["program_list"]
                        let programArr = (result["program_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                        
                        let sortProgramArr = programArr.sorted(by: { (($0 as! NSDictionary)["from_date"] as! String) < (($1 as! NSDictionary)["from_date"] as! String) })
                        var dateStr = ""
                        //var finalDic = NSMutableDictionary()
                        let arr = NSMutableArray()
                        let finalArray = NSMutableArray()
                        for i in 0...(sortProgramArr.count-1)
                        {
                            let dic = sortProgramArr[i] as! NSDictionary
                            
                            if i == 0
                            {
                                dateStr = dic["from_date"] as! String
                                arr.add(dic)
                            }
                            else if (dic["from_date"] as! String) == dateStr
                            {
                                arr.add(dic)
                            }
                            else if (dic["from_date"] as! String) != dateStr
                            {
                                finalArray.add(["date":dateStr, "list": arr.copy()])
                                dateStr = (dic["from_date"] as! String)
                                arr.removeAllObjects()
                                arr.add(dic)
                            }
                            
                            
                            if i == sortProgramArr.count-1
                            {
                                finalArray.add(["date":dateStr, "list": arr])
                            }
                        }
                        self.programList = JSON(finalArray)
                        print(self.programList)
                        //self.programData.sorted(by: ($0["number"].stringValue > $1["number"].stringValue) )
                        //self.programData.sort({ $0.meetingDate.compare($1.meetingDate) == .OrderedAscending })
                        self.tblView.reloadData()
                       }
                    }
                   case .failure(let error):
                       print(error)
                   }
           }

       }
       else
       {
           self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
           PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
       }
   }

}
