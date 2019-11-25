//
//  ChatVC.swift
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

class ChatVC: UIViewController ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    
    
  
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var btnSend: UIButton!
    
   @IBOutlet weak var lblTitle: UILabel!
    
   @IBOutlet weak var HeaderView: UIView!
    
    
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var tittleName = String()
    var timer = Timer()
    var tym = String()
    var toId = Int()
    var chatsData  = JSON()
    var  keyboardHight = CGFloat()
          var iPhoneXorNot = 0
    var msgSend = ["Hi How Are You..","When to Meet ??"]
    var msgRecive = ["I am fine."," 2:30 PM would be good ??"]
    var time = ["10:00 AM","10:05 AM"]
    var messageId = String()
    
    var firebaseChatOrAdmin = 0
    
    //Firebase Chat----------------------------
    
    let uid = (UserDefaults.standard.string(forKey: "email") ?? "").replacingOccurrences(of: ".", with: "@")
    var chatUserId = String()
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?

    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    
    //Firebase Chat----------------------------
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Chat----------------------------
        
        //self.tblChat.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")

        
        
        //Firebase Chat----------------------------
        
      messageView.layer.borderColor = UIColor.lightGray.cgColor
              messageView.layer.borderWidth = 0.5
                      messageView.layer.cornerRadius = 6
                      messageView.clipsToBounds = true
            
            lblTitle.text = tittleName
 
     HeaderView.backgroundColor = Colors.HeaderColor
        
        txtField.delegate = self

        
        txtField.attributedPlaceholder = NSAttributedString(string:"Type Something....",attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        

   
//        self.hideKeyboardTappedArround()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
        
     
    }
    
    override func viewWillAppear(_ animated: Bool)
    
    {
        if firebaseChatOrAdmin == 0
        {
            configureDatabase()
            configureStorage()
            configureRemoteConfig()
            fetchConfig()
            messageView.isHidden = false
        }
        else
        {
            messageView.isHidden = true
            ChatsApi()
        }
        
        
        //Firebase Chat----------------------------
        
        
        
        //Firebase Chat----------------------------
        
    }
    
    //------------------------------------
    //MARK: Delegate method
    //------------------------------------
    
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if firebaseChatOrAdmin == 0
        {
            return messages.count
        }
        else
        {
            return chatsData.count
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        
        if firebaseChatOrAdmin == 0
        {
            let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
            print(messageSnapshot, "Snap")
            let jsonMsg = JSON(messageSnapshot.value as! NSDictionary)
            hmaFormat.timeZone = TimeZone.current
            
            if messageSnapshot.childSnapshot(forPath: "from").value as? String == uid
            {
                let cell = tblChat.dequeueReusableCell(withIdentifier: "tblMsgSendCell") as! tblMsgSendCell

                cell.lblSentMsg.text = jsonMsg["message"].stringValue

                cell.lblTime.text =  jsonMsg["time"].stringValue

                //            cell.lblDate.text = (dic["sent_date"] as! String)

                            cell.msgView.layer.cornerRadius = 10
                            cell.msgView.clipsToBounds = true

                        cell.viewImage.isHidden = true

                        cell.imgUser.layer.masksToBounds = false
                        cell.imgUser.layer.cornerRadius =  cell.imgUser.frame.height/2
                        cell.imgUser.clipsToBounds = true
                cell.imgUser.sd_setImage(with: URL(string: jsonMsg["image_url"].stringValue), placeholderImage: UIImage(named: "icon_user"), options: .refreshCached, completed: nil)
                            return cell
            }
            else
            {
                let cell = tblChat.dequeueReusableCell(withIdentifier: "tblMsgReceivedCell") as! tblMsgReceivedCell

                            cell.lblRecievedMsg.text! = jsonMsg["message"].stringValue

                            cell.lblTime.text =  jsonMsg["time"].stringValue

                //            cell.lblDate.text = (dic["sent_date"] as! String)

                            cell.messageRecievedView.layer.cornerRadius = 10
                            cell.messageRecievedView.clipsToBounds = true

                        cell.viewImage.isHidden = true

                        cell.imgUser.layer.masksToBounds = false
                        cell.imgUser.layer.cornerRadius =  cell.imgUser.frame.height/2
                        cell.imgUser.clipsToBounds = true
                cell.imgUser.sd_setImage(with: URL(string: jsonMsg["image_url"].stringValue), placeholderImage: UIImage(named: "icon_user"), options: .refreshCached, completed: nil)
                            return cell
            }
            
        }
        else
        {
            
            
            let cell = tblChat.dequeueReusableCell(withIdentifier: "tblMsgReceivedCell") as! tblMsgReceivedCell

            cell.lblRecievedMsg.text! = chatsData[indexPath.row]["topic"].stringValue

                        cell.lblTime.text =  chatsData[indexPath.row]["date"].stringValue

            //            cell.lblDate.text = (dic["sent_date"] as! String)

                        cell.messageRecievedView.layer.cornerRadius = 10
                        cell.messageRecievedView.clipsToBounds = true

                    cell.viewImage.isHidden = true

                    cell.imgUser.layer.masksToBounds = false
                    cell.imgUser.layer.cornerRadius =  cell.imgUser.frame.height/2
                    cell.imgUser.clipsToBounds = true
                        return cell
            
        }
        //Firebase Chat----------------------------
        
        
        //let cell = self.tblChat .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        /*let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
          if imageURL.hasPrefix("gs://") {
            Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
              if let error = error {
                print("Error downloading: \(error)")
                return
              }
              DispatchQueue.main.async {
                cell.imageView?.image = UIImage.init(data: data!)
                cell.setNeedsLayout()
              }
            }
          } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
            cell.imageView?.image = UIImage.init(data: data)
          }
          cell.textLabel?.text = "sent by: \(name)"
        } else {
          let text = message[Constants.MessageFields.text] ?? ""
          cell.textLabel?.text = name + ": " + text
          cell.imageView?.image = UIImage(named: "ic_account_circle")
          if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
              let data = try? Data(contentsOf: URL) {
            cell.imageView?.image = UIImage(data: data)
          }
        }
        return cell*/
        
        
        //Firebase Chat----------------------------
        
        

        
        
        
        
//        let dic = chatsData[indexPath.row] as! String
        
//       if formId == 1
//        {

        ///////////////////////////Old-------------------------------
        
            
        
        ///////////////////////////Old-------------------------------
//        }
//        else
//        {
//            let cell = tblChat.dequeueReusableCell(withIdentifier: "tblMsgReceivedCell") as! tblMsgReceivedCell
//
//            cell.lblRecievedMsg.text = msgRecive[indexPath.row]
//
//            cell.lblTime.text = time[indexPath.row]
//
////            cell.lblDate.text = (dic["sent_date"] as! String)
//
//            cell.messageRecievedView.layer.cornerRadius = 5
//
//        let strArr =  msgRecive[indexPath.row].components(separatedBy: " ")
//
//               if strArr.count > 1
//               {
//
//                   let str = String(strArr[0].first!) + String(strArr[1].first!)
//                   print(str)
//                   cell.lblImage.text = str.uppercased()
//
//               }
//               else
//               {
//                   let str = String(strArr[0][0]) + String(strArr[0][1])
//                   print(str)
//                   cell.lblImage.text = str.uppercased()
//               }
       
//                   cell.lblImage.textColor = Colors.HeaderColor
//                   
//                    cell.imgUser.isHidden = true
//                   cell.viewImage.layer.masksToBounds = false
//                   cell.viewImage.layer.cornerRadius =  cell.viewImage.frame.height/2
//                   cell.viewImage.clipsToBounds = true
//                
//        }
            
//        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
//        guard let text = textField.text else { return true }
//        textField.text = ""
        view.endEditing(true)
//        let data = [Constants.MessageFields.text: text]
//        sendMessage(withData: data)
        return true
    }
    //------------------------------------
    //MARK: User Define Function
    //------------------------------------
    
    //Firebase Chat----------------------------
    
    //var uid = (UserDefaults.standard.string(forKey: "email") ?? ""))

    
    
    
//    func register_user(String surname, String givenname, String uid, final String organization)
//    {
//    mDatabase= FirebaseDatabase.getInstance().getReference().child("users");
//    Map userMap = new HashMap();
//    userMap.put("device_token", FirebaseInstanceId.getInstance().getToken());
//    userMap.put("surname", surname);
//    userMap.put("organization", organization);
//    userMap.put("givenname", givenname);
//    mDatabase.child(uid).setValue(userMap).addOnCompleteListener(new OnCompleteListener<Void>
//    () {
//    @Override
//    public void onComplete(@NonNull Task<Void> task1) {
//    if (task1.isSuccessful()) {
//    onBackPressed();
//    } else {
//    Toast.makeText(getApplicationContext(), "YOUR NAME IS NOT REGISTERED... MAKE
//    NEW ACCOUNT-- ", Toast.LENGTH_SHORT).show();
//    }
//    }
//    });
//    }
    
    
    
    
    
    
        deinit {
          if let refHandle = _refHandle  {
            self.ref.child(uid).removeObserver(withHandle: refHandle)
          }
        }

        func configureDatabase() {
            
            let timeDic = ["time_stamp": Date.currentTimeStamp]
            print(timeDic)
                
                Database.database().reference().child("chats").child(uid).child(chatUserId).setValue(timeDic, withCompletionBlock: {err, ref in
                    
                    
                    })
                Database.database().reference().child("chats").child(chatUserId).child(uid).setValue(timeDic, withCompletionBlock: {err, ref in
                
                
                })
            
            ref = Database.database().reference().child("messages").child(uid).child(chatUserId)
          // Listen for new messages in the Firebase database
            _refHandle = self.ref.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
                strongSelf.tblChat.reloadData()
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
                print("Config fetched!", self?.messages)
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
    
    
    func sendMessage(withData data: [String: String]) {
      var mdata = data
      mdata[Constants.MessageFields.name] = (UserDefaults.standard.string(forKey: "givenName") ?? "")
//      if let photoURL = Auth.auth().currentUser?.photoURL {
//        mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
//      }

      // Push data to Firebase Database
      self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    //Firebase Chat----------------------------
    
    
   @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            print(self.messageView.frame.origin.y)
            print(self.view.frame.maxY)
            if self.view.frame.maxY - self.messageView.frame.origin.y == 85
            {
                iPhoneXorNot = 0
            }
            else
            {
                iPhoneXorNot = 1
            }
            if self.messageView.frame.origin.y == self.view.frame.maxY - 85 || self.messageView.frame.origin.y == self.view.frame.maxY - 143
            {
                if iPhoneXorNot == 0
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y -= keyboardSize.height
                    keyboardHight = keyboardSize.height
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y + keyboardSize.height, right: 0)
                        
                    }
                }
                else
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y -= keyboardSize.height - 30
                    keyboardHight = keyboardSize.height
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y + keyboardSize.height, right: 0)
                    }
                }
                
                //self.tblChatroom.frame.origin.y -= keyboardSize.height
                print(self.messageView.frame.origin.y)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            print(keyboardSize.height)
            print(self.messageView.frame.origin.y)
            if self.messageView.frame.origin.y != self.view.frame.maxY - 85 && self.messageView.frame.origin.y != self.view.frame.maxY - 143
            {
                if iPhoneXorNot == 0
                {
                    print(keyboardSize.height)
                    self.messageView.frame.origin.y += keyboardHight
                    
                    //self.tblChatroom.frame.origin.y += keyboardSize.height
                    
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y, right: 0)
                    }
                }
                else
                {
                    self.messageView.frame.origin.y += keyboardHight - 30
                    
                    //self.tblChatroom.frame.origin.y += keyboardSize.height
                    
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tblChat.frame.origin.y, right: 0)
                    }
                }
                
                
                print(self.messageView.frame.origin.y)
                
                
            }
        }
    
    }
//
//    @objc func NotificationChatInternetAvailable()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//
//            NotificationChatAPI()
//        }
//        else
//        {
//            self.stopAnimating()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available")
//        }
//    }
//
    
    
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
            ChatsApi()

        }
        else
        {
            self.stopAnimating()
            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available", type: .error, time: 1)
        }
    }
//
    //------------------------------------
    //MARK: Button Actions
    //------------------------------------
    
    
    
//    @IBAction func btnSendMsgTUI(_ sender: UIButton)
//    {
        

//            let date = Date()
//
//            let dateFormat = DateFormatter()
//
//            dateFormat.timeStyle = .medium
//
//            dateFormat.dateStyle = .long
//
//            dateFormat.dateFormat = "dd/MMM/YYYY"
//            let timeFormat = DateFormatter()
//
//            timeFormat.timeStyle = .medium
//
//            timeFormat.dateFormat = "hh:mm a"
//
//
//        tym = timeFormat.string(from: date)
//
//
//
//
//          NotificationChatAPI()
//
//
//            txtField.text = ""

        
//    }
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendTUI(_ sender: UIButton)
    {
        if firebaseChatOrAdmin == 0
        {
            if txtField.text != ""
            {
                let rootRef = Database.database().reference()
                
                let curr_user_ref = "messages/" + uid + "/" + chatUserId
                let chat_user_ref = "messages/" + chatUserId + "/" + uid
                
                
                let userMsgPush = rootRef.child("messages").child(uid).child(chatUserId).childByAutoId()
                let pushKey = userMsgPush.key!
                
                hmaFormat.timeZone = TimeZone(identifier: "Australia/Sydney")
                
                print(hmaFormat.string(from: Date()))
                let messageDic = ["message": txtField.text!, "seen": false, "type":"text", "time": hmaFormat.string(from: Date()), "from": uid, "image_url":(UserDefaults.standard.string(forKey: "profilePic")) ?? ""] as [String : Any]
                
                if chatUserId == uid
                {
                    let messageUserDic = ["\(curr_user_ref)/\(pushKey)": messageDic]
                    print(messageUserDic)
                    
                    
                    rootRef.updateChildValues( messageUserDic, withCompletionBlock: { error, ref in
                        if error != nil
                        {
                            
                        }
                        else
                        {
                            self.view.endEditing(true)
                            self.txtField.text = ""
                        }
                        
                    })
                }
                else
                {
                    let messageUserDic = ["\(curr_user_ref)/\(pushKey)": messageDic, "\(chat_user_ref)/\(pushKey)": messageDic]
                    print(messageUserDic)
                    
                    
                    rootRef.updateChildValues( messageUserDic, withCompletionBlock: { error, ref in
                        if error != nil
                        {
                            
                        }
                        else
                        {
                            self.view.endEditing(true)
                            self.txtField.text = ""
                        }
                        
                    })
                }
                
                
                
            }
            
            
            
        }
    }
    
    //------------------------------------
    //MARK:Web services
    //------------------------------------
    
//
//    func NotificationChatAPI()
//    {
//        var chatIdPara = ""
//        if UserDefaults.standard.integer(forKey: "usertype") == 2
//        {
//            chatIdPara = chatId
//        }
//        else
//        {
//            chatIdPara = "chat_" + String(toId) + "_" + String(UserDefaults.standard.integer(forKey:"userid"))
//        }
//
//        let parameter = ["chat_id": chatIdPara  ,"from":UserDefaults.standard.integer(forKey:"userid"),"to":toId,"message": txtField.text!,"time":tym] as [String : Any]
//
//        print("http://34.202.173.112/smartevent/api/add/chat")
//
//        print(parameter)
//
//        if Connectivity.isConnectedToInternet()
//        {
//            timer.invalidate()
//            self.start()
//
//        Alamofire.request("http://34.202.173.112/smartevent/api/add/chat",method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
//            {
//                response in
//                switch response.result
//                {
//                case .success:
//
//                    let result = response.result.value! as! NSDictionary
//                    print(result)
//                    if (result["status"] as! Int) == 0
//                    {
//
//                        print("Error")
//
//                        self.stopAnimating()
//                    }
//                    else
//                    {
//                         self.stopAnimating()
//
//                        self.ChatsApi()
//
//                        self.tblChat.reloadData()
//
//
//                    }
//
//
//                case .failure(let error):
//                    print(error)
//                }
//        }
//
//
//        }
//        else
//        {
//            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.NotificationChatInternetAvailable), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//
//    }
//
//
//
//
    func ChatsApi()
    {

        if Connectivity.isConnectedToInternet()
        {

            let parameter = ["type":"messageNotificationList","attendees_id":/*UserDefaults.standard.integer(forKey: "attendeesid")*/18, "messages_id": messageId] as [String : Any]

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

                           self.chatsData = result["message_list"]
                           
                         
                           self.tblChat.reloadData()

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
