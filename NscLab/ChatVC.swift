//
//  ChatVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit


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
    var chatsData  = NSMutableArray()
    var  keyboardHight = CGFloat()
          var iPhoneXorNot = 0
    var msgSend = ["Hi How Are You..","When to Meet ??"]
    var msgRecive = ["I am fine."," 2:30 PM would be good ??"]
    var time = ["10:00 AM","10:05 AM"]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        ChatsApi()
    }
    
    //------------------------------------
    //MARK: Delegate method
    //------------------------------------
    
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return msgRecive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        
//        let dic = chatsData[indexPath.row] as! String
        
//       if formId == 1
//        {

            let cell = tblChat.dequeueReusableCell(withIdentifier: "tblMsgSendCell") as! tblMsgSendCell

            cell.lblSentMsg.text! = msgSend[indexPath.row]

            cell.lblTime.text =  time[indexPath.row]

//            cell.lblDate.text = (dic["sent_date"] as! String)

            cell.msgView.layer.cornerRadius = 10
            cell.msgView.clipsToBounds = true

        cell.viewImage.isHidden = true

        cell.imgUser.layer.masksToBounds = false
        cell.imgUser.layer.cornerRadius =  cell.imgUser.frame.height/2
        cell.imgUser.clipsToBounds = true
            return cell
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
            return cell
//        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        self.view.endEditing(true)
        return true
    }
    //------------------------------------
    //MARK: User Define Function
    //------------------------------------
    
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
    
    
    
//    @objc func ChatsInternetAvailable()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//            ChatsApi()
//
//        }
//        else
//        {
//            self.stopAnimating()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available")
//        }
//    }
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
//    func ChatsApi()
//    {
//
//        let parameter = ["chat_id": chatId] as [String : Any]
//
//        if Connectivity.isConnectedToInternet()
//        {
//            timer.invalidate()
//            self.start()
//
//            print( "Chats ==>" + appDelegate.ApiBaseUrl + "chat")
//
//            Alamofire.request(appDelegate.ApiBaseUrl + "chat", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON(completionHandler: { response in
//
//                switch response.result
//                {
//
//                case .success(_):
//
//
//                    let result = response.result.value as! NSDictionary
//
//                    print(result)
//
//                    if (result["status"] as! Int) == 0
//                    {
//
//
//                        print("Error")
//
//                        self.stopAnimating()
//
//                    }
//                    else
//                    {
//
//                        self.stopAnimating()
//
//
//                        self.chatsData =  (result["chat"] as! NSArray).mutableCopy() as! NSMutableArray
//
//
//
//                        self.tblChat.reloadData()
//                        self.tblChat.scrollToRow(at: IndexPath(row: self.chatsData.count-1, section: 0), at: .bottom, animated: false)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//
//            })
//
//        }
//
//        else
//        {
//            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.ChatsInternetAvailable), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//
//    }
//
    
    
}
