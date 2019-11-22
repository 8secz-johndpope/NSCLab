//
//  ProgramPeopleVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ProgramDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    //-----------------------
    //MARK:Outlets
    //-----------------------
    
    @IBOutlet weak var HeaderView: UIView!

    
    @IBOutlet weak var tblRecordView: UITableView!
    
  @IBOutlet weak var SubDetailsView: UIView!
     
     @IBOutlet weak var lblTittle: UILabel!
     @IBOutlet weak var lblDate: UILabel!
     @IBOutlet weak var lblTime: UILabel!
     @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewDescription: UIView!

     @IBOutlet weak var lblLocation: UILabel!
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var programId = String()
    var sections = ["Presentation"]
    
    var presentationData = JSON()
  
     var tittleName = String()
    var date = String()
    var time = String()
    var desc = String()
    var addr = String()
    var timer = Timer()
    
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
     HeaderView.backgroundColor = Colors.HeaderColor
        SubDetailsView.backgroundColor = Colors.HeaderColor
            
        
        
        lblTittle.text = tittleName
        lblDate.text = date
        lblTime.text = time
        lblDescription.text = "Description: " + desc
        lblLocation.text = "Address: " + addr
        
        
                  lblTittle.textColor = UIColor.white
                  lblDate.textColor = UIColor.white
                  lblTime.textColor = UIColor.white
        
         presentationListApi()
        
//
       self.tblRecordView.tableFooterView = UIView()
        
        tblRecordView.rowHeight = 80
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           
           return self.sections[section]
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presentationData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tblRecordView.dequeueReusableCell(withIdentifier: "tblProgramPeopleCell") as! tblProgramPeopleCell
        
    

        cell.lblUserName.text   = presentationData[indexPath.row]["topic"].stringValue
        cell.lblAddress.text = presentationData[indexPath.row]["toTime"].stringValue[0..<5]  + " - " + presentationData[indexPath.row]["fromTime"].stringValue[0..<5]


        return cell
    }
    
    
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            
   
            
            let header = view as! UITableViewHeaderFooterView
            
            header.textLabel?.textColor = Colors.DarkGray
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        let obj = storyboard?.instantiateViewController(withIdentifier: "PresentationDetailVC") as! PresentationDetailVC

      
             
             obj.presentationId = presentationData[indexPath.row]["presentation_id"].stringValue
             
        
        navigationController?.pushViewController(obj, animated: true)

      
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            presentationListApi()
        }
        else
        {
            self.stopAnimating()
             PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
        }
    }
    
    
    @IBAction func btnBackTUI(_ sender: UIButton)
          {
                navigationController?.popViewController(animated: true)
          }
    
    
    //----------------------------
    //MARK: Web Services
    //----------------------------

       func presentationListApi()
       {

           if Connectivity.isConnectedToInternet()
           {

            let parameter = ["type":"presentationList","program_id":programId] as [String : Any]

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

                             PopUp(Controller: self, title:  "Error!", message: self.presentationData["msg"].stringValue, type: .error, time: 2)

                               self.stopAnimating()
                           }
                           else
                           {
                               self.stopAnimating()

                           self.presentationData = result["presentation_list"]

                            self.tblRecordView.reloadData()
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

