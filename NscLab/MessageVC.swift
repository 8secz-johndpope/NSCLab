//
//  MessageVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

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

   
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
     HeaderView.backgroundColor = Colors.HeaderColor
        
        
//
       self.tblMessageView.tableFooterView = UIView()
        
        tblMessageView.rowHeight = 80
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return msgData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tblMessageView.dequeueReusableCell(withIdentifier: "tblMessageCell") as! tblMessageCell
        
   
     
        Cell.lblUserName.text = msgData[indexPath.row]
        Cell.lblUserMsg.text = msgs[indexPath.row]
        Cell.lblTime.text = time[indexPath.row]

            let strArr =  msgData[indexPath.row].components(separatedBy: " ")
                
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

        obj.tittleName = msgData[indexPath.row]
    
        self.navigationController?.pushViewController(obj, animated: true)
        
      
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    
//    @objc func InternetAvailable()
//    {
//        if Connectivity.isConnectedToInternet()
//        {
//            ChatHistoryApi()
//        }
//        else
//        {
//            self.stopAnimating()
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet not available")
//        }
//    }
    
    
    @IBAction func btnBackTUI(_ sender: UIButton)
          {
                navigationController?.popViewController(animated: true)
          }
    
    
    //----------------------------
    //MARK: Web Services
    //----------------------------
    
//
//    func ChatHistoryApi()
//    {
//
//        let parameter = ["user_id": UserDefaults.standard.integer(forKey: "userid"),"user_type":UserDefaults.standard.integer(forKey: "usertype")]
//
//        print(parameter)
//        if Connectivity.isConnectedToInternet()
//        {
//            timer.invalidate()
//            self.start()
//
//            print( "chat History ==>" + appDelegate.ApiBaseUrl + "chat_user_list")
//
//            Alamofire.request(appDelegate.ApiBaseUrl + "chat_user_list", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON(completionHandler: { response in
//
//                switch response.result
//                {
//
//                case .success(_):
//                    print("chat History")
//
//                    let result = response.result.value as! NSDictionary
//
//                    print(result)
//
//                    if (result["status"] as! Int) == 0
//                    {
//
//                        self.lblNoChatFound.isHidden = false
//                        self.tblChatView.isHidden = true
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
//                        self.lblNoChatFound.isHidden = true
//                        self.tblChatView.isHidden = false
//
//
//                        self.chatHistoryData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
//
//
////                        UserDefaults.standard.set(result["chat_id"], forKey: "chatid")
////
////                        UserDefaults.standard.integer(forKey: "chatid")
//
//                        self.tblChatView.reloadData()
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
//            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.InternetAvailable), userInfo: nil, repeats: true)
//            PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available")
//        }
//
//    }
    
    
    
 

}
