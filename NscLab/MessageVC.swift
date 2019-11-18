//
//  MessageVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    //-----------------------
    //MARK:Outlets
    //-----------------------
    
    @IBOutlet weak var HeaderView: UIView!

    
    @IBOutlet weak var tblMessageView: UITableView!
      
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var msgData = ["Anika Barton","Kevin Gosschalk","Dafina","Kevin Gosschalk"]
    
    var msgs = ["Hi how are you."," Hi"," Dockland","Australia"]
    
    var time = ["10:00 AM","1:00 PM","08/11/19","30/10/19"]
    var timer = Timer()
    var messagesData = JSON()
   
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
     HeaderView.backgroundColor = Colors.HeaderColor
        
        
//
       self.tblMessageView.tableFooterView = UIView()
        
        tblMessageView.rowHeight = 80
        
        messagesApi()
        
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tblMessageView.dequeueReusableCell(withIdentifier: "tblMessageCell") as! tblMessageCell
        
   
     
        Cell.lblUserName.text = messagesData[indexPath.row]["givenName"].stringValue + " " + messagesData[indexPath.row]["surname"].stringValue
        Cell.lblUserMsg.text = ""
        Cell.lblTime.text = messagesData[indexPath.row]["date"].stringValue

            let strArr =  [messagesData[indexPath.row]["givenName"].stringValue, messagesData[indexPath.row]["surname"].stringValue]
                
                if strArr.count > 1
                {
                   
                    let str = String(strArr[0].first!) + String(strArr[1].first!)
                    Cell.lblNameImg.text = str.uppercased()
                    
                }
                else
                {
                    let str = String(strArr[0][0]) + String(strArr[0][1])
                    Cell.lblNameImg.text = str.uppercased()
                }
        
            Cell.lblNameImg.textColor = Colors.HeaderColor
            
            
            Cell.ViewImg.layer.masksToBounds = false
            Cell.ViewImg.layer.cornerRadius =  Cell.ViewImg.frame.height/2
            Cell.ViewImg.clipsToBounds = true
      
//        else
//        {
//
//
//             Cell.ViewImg.isHidden = true
//
//            Cell.imgUser.sd_setImage(with: URL(string:  (dic["image"] as! String)), placeholderImage: UIImage(named: "icon_profile"), options: .refreshCached, completed: nil)
//
//
//
//            Cell.imgUser.layer.masksToBounds = false
//            Cell.imgUser.layer.cornerRadius =  Cell.imgUser.frame.height/2
//            Cell.imgUser.clipsToBounds = true
//        }

    
        return Cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {


        let obj = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC

        obj.tittleName = messagesData[indexPath.row]["givenName"].stringValue + " " + messagesData[indexPath.row]["surname"].stringValue
        obj.messageId = messagesData[indexPath.row]["messages_id"].stringValue
        
        self.navigationController?.pushViewController(obj, animated: true)
        
      
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            messagesApi()
        }
        else
        {
            self.stopAnimating()
            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available", type: .error, time: 1)
        }
    }
    
    
    @IBAction func btnBackTUI(_ sender: UIButton)
          {
                navigationController?.popViewController(animated: true)
          }
    
    
    //----------------------------
    //MARK: Web Services
    //----------------------------
    
func messagesApi()
{

    if Connectivity.isConnectedToInternet()
    {

        let parameter = ["type":"messageNotificationList","attendees_id":/*UserDefaults.standard.integer(forKey: "attendeesid")*/18] as [String : Any]

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

                       self.messagesData = result["message_list"]
                       
                     
                       self.tblMessageView.reloadData()

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
