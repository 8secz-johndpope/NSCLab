//
//  MapListVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MapListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    //-----------------------
    //MARK:Outlets
    //-----------------------
    
 
    
  
      
    @IBOutlet weak var tblMapListView: UITableView!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var mapListData = JSON()
    var timer = Timer()
    
    
 
   
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        locationApi()
//
       self.tblMapListView.tableFooterView = UIView()
        
        tblMapListView.rowHeight = 80
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeVC), name: Notification.Name("reloadMapList"), object: nil)
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mapListData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tblMapListView.dequeueReusableCell(withIdentifier: "tblMapListCell") as! tblMapListCell
     
        cell.lblName.text = mapListData[indexPath.row]["address"].stringValue
       
    
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        

        
        locationAddress = mapListData[indexPath.row]["address"].stringValue
        locationImageUrl = mapListData[indexPath.row]["mapImage"].stringValue
//        navigationController?.pushViewController(obj, animated: true)

         NotificationCenter.default.post(name: Notification.Name(rawValue: "showMap"), object: nil, userInfo: nil)
      
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    @objc func ChangeVC(_notification: Notification)
    {
        mapListData = JSON(searchDataLocation)
        tblMapListView.reloadData()
        
    }
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            locationApi()
        }
        else
        {
            self.stopAnimating()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available")
        }
    }
    
    
  
    //----------------------------
    //MARK: Web Services
    //----------------------------
    
  func locationApi()
             {

                 if Connectivity.isConnectedToInternet()
                 {

                     let parameter = ["type":"locationList","conference_id":conferenceId] as [String : Any]

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

                                   PopUp(Controller: self, title:  "Error!", message: result["msg"].stringValue, type: .error, time: 2)

                                     self.stopAnimating()
                                 }
                                 else
                                 {
                                     self.stopAnimating()

                                    self.mapListData = result["location_list"]
                                    
                             searchDataLocation =  (result["location_list"].arrayObject! as NSArray).mutableCopy() as! NSMutableArray
                                    

                                    self.tblMapListView.reloadData()

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
