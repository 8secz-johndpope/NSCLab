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
import Firebase
import FirebaseDatabase
import FirebaseStorage

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
    
    
    let uid = (UserDefaults.standard.string(forKey: "email") ?? "").replacingOccurrences(of: ".", with: "@")
    var refChats: DatabaseReference!
    var chats: [DataSnapshot]! = []
    
    var refUsers: DatabaseReference!
    var users: [DataSnapshot]! = []
    
    var refMessages: DatabaseReference!
    var messages: [DataSnapshot]! = []
    
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?

    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
   
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
        
        
        
     HeaderView.backgroundColor = Colors.HeaderColor
        
        
//
       self.tblMessageView.tableFooterView = UIView()
        
        tblMessageView.rowHeight = 80
        
        messagesApi()
        
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       print(messagesData.count + chats.count)
        return messagesData.count + chats.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tblMessageView.dequeueReusableCell(withIdentifier: "tblMessageCell") as! tblMessageCell
        
   
        if indexPath.row <= (chats.count-1)
        {
            //let cell = self.tblChat .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
            // Unpack message from Firebase DataSnapshot
            
            
            let messageSnapshot: DataSnapshot! = self.chats[indexPath.row]
                        let user = messageSnapshot.key
                        let msgQuery = refMessages.child(user).queryLimited(toLast: 1)
                        msgQuery.observe(.childAdded, andPreviousSiblingKeyWith: { snapShot, str in
                            print()
                            if snapShot.childSnapshot(forPath: "message").value as? String != nil
                            {
                                Cell.lblUserMsg.text = snapShot.childSnapshot(forPath: "message").value as? String
                                hmaFormat.timeZone = TimeZone.current
                                Cell.lblTime.text = hmaFormat.string(from: Date(timeIntervalSince1970: snapShot.childSnapshot(forPath: "time").value as? Double ?? 0))
                                
                                //Cell.lblUserMsg.text = snapShot.childSnapshot(forPath: "message").value as? String
                            }
                            else
                            {
                                Cell.lblUserMsg.text = ""
                            }
                            
                        })
                        
            //            let userQuery = refUsers
            //            userQuery.observe(.childAdded, andPreviousSiblingKeyWith: { snapShot, str in
            //                print(snapShot, "User")
            //                if snapShot.childSnapshot(forPath: "givenname").value as? String != nil
            //                {
            //                    Cell.lblUserName.text = snapShot.childSnapshot(forPath: "givenname").value as? String
            //                    //Cell.lblUserMsg.text = snapShot.childSnapshot(forPath: "message").value as? String
            //                }
            //
            //            })
                        refUsers.observe(.value, with: { snapShot in
                            
                            let val = snapShot.childSnapshot(forPath: user).value as! NSDictionary
                            let jsonVal = JSON(val)
                            Cell.lblUserName.text = jsonVal["givenname"].stringValue + " " + jsonVal["surname"].stringValue
                            let strArr =  [jsonVal["givenname"].stringValue, jsonVal["surname"].stringValue]
                            
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

                        })
        }
        else
        {
            
            
            Cell.lblUserName.text = messagesData[indexPath.row-chats.count]["givenName"].stringValue + " " + messagesData[indexPath.row-chats.count]["surname"].stringValue
            Cell.lblUserMsg.text = messagesData[indexPath.row-chats.count]["topic"].stringValue
            Cell.lblTime.text = dmyFormat.string(from: ymdFormat.date(from: messagesData[indexPath.row-chats.count]["date"].string ?? "") ?? Date())

                let strArr =  [messagesData[indexPath.row-chats.count]["givenName"].stringValue, messagesData[indexPath.row-chats.count]["surname"].stringValue]
                    
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
        
        if chats.count == 0
        {
            

            obj.tittleName = messagesData[indexPath.row]["givenName"].stringValue + " " + messagesData[indexPath.row]["surname"].stringValue
            obj.messageId = messagesData[indexPath.row]["messages_id"].stringValue
            obj.firebaseChatOrAdmin = 1
            
        }
        else if indexPath.row > chats.count-1
        {
            obj.tittleName = messagesData[indexPath.row-chats.count]["givenName"].stringValue + " " + messagesData[indexPath.row-chats.count]["surname"].stringValue
            obj.messageId = messagesData[indexPath.row-chats.count]["messages_id"].stringValue
            obj.firebaseChatOrAdmin = 1
        }
        else
        {
            let messageSnapshot: DataSnapshot! = self.chats[indexPath.row]
            let cell = tblMessageView.cellForRow(at: indexPath) as! tblMessageCell
            obj.chatUserId = messageSnapshot.key
            obj.tittleName = cell.lblUserName.text!
            obj.firebaseChatOrAdmin = 0
        }
      self.navigationController?.pushViewController(obj, animated: true)
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    deinit {
      if let refHandle = _refHandle  {
        self.refChats.child(uid).removeObserver(withHandle: refHandle)
      }
    }

    func configureDatabase() {
        refChats = Database.database().reference().child("chats").child(uid)
        refUsers = Database.database().reference().child("users")
        refMessages = Database.database().reference().child("messages").child(uid)
      // Listen for new messages in the Firebase database
        
//        let _refHandleUsers = self.refChats.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//          guard let strongSelf = self else { return }
//              strongSelf.users.append(snapshot)
//
//
//              //strongSelf.tblMessageView.reloadData()
//          //strongSelf.tblMessageView.insertRows(at: [IndexPath(row: strongSelf.chats.count-1, section: 0)], with: .automatic)
//        })
//
//        let _refHandleMessages = self.refChats.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//          guard let strongSelf = self else { return }
//              strongSelf.messages.append(snapshot)
//
//
//              //strongSelf.tblMessageView.reloadData()
//          //strongSelf.tblMessageView.insertRows(at: [IndexPath(row: strongSelf.chats.count-1, section: 0)], with: .automatic)
//        })
        
        _refHandle = self.refChats.queryOrdered(byChild: "time_stamp").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
        guard let strongSelf = self else { return }
            strongSelf.chats.append(snapshot)
            
            print(strongSelf.chats!)
            strongSelf.tblMessageView.reloadData()
        //strongSelf.tblMessageView.insertRows(at: [IndexPath(row: strongSelf.chats.count-1, section: 0)], with: .automatic)
      })
        
        
        
    }

    func configureStorage() {
      storageRef = Storage.storage().reference()
    }

    func configureRemoteConfig() {
      remoteConfig = RemoteConfig.remoteConfig()
      // Create Remote Config Setting to enable developer mode.
      // Fetching configs from the server is normally limited to 5 requests per hour.
      // Enabling developer mode allows many more requests to be made per hour, so developers
      // can test different config values during development.
      let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
      remoteConfig.configSettings = remoteConfigSettings
    }

    func fetchConfig() {
      var expirationDuration: Double = 3600
      // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
      // the server.
      if self.remoteConfig.configSettings.isDeveloperModeEnabled {
        expirationDuration = 0
      }

      // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
      // fetched and cached config would be considered expired because it would have been fetched
      // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
      // throttling is in progress. The default expiration duration is 43200 (12 hours).
      remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
        if status == .success {
            print("Config fetched!", self?.chats)
          guard let strongSelf = self else { return }
          strongSelf.remoteConfig.activateFetched()
          let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
          if friendlyMsgLength.source != .static {
            strongSelf.msglength = friendlyMsgLength.numberValue!
            print("Friendly msg length config: \(strongSelf.msglength)")
          }
        } else {
          print("Config not fetched")
          if let error = error {
            print("Error \(error)")
          }
        }
      }
    }
    
    
    
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
