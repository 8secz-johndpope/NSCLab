//
//  DocumentVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class DocumentVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    //-----------------------
    //MARK:Outlets
    //-----------------------
    
 
    
    @IBOutlet weak var headerView: UIView!
    
      
    @IBOutlet weak var tblDocumentView: UITableView!
    
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var docData = ["US cyber Security Clusters","IBM Waston Clusters","WC Gate","Australia Embassy Comissions"]
    
 
   
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        headerView.backgroundColor = Colors.HeaderColor
        
//
       self.tblDocumentView.tableFooterView = UIView()
        
        tblDocumentView.rowHeight = 80
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return docData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tblDocumentView.dequeueReusableCell(withIdentifier: "tblDocumentCell") as! tblDocumentCell
     
        cell.lblDocument.text = docData[indexPath.row]
       
    
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        let obj = storyboard?.instantiateViewController(withIdentifier: "DocumentViewVC") as! DocumentViewVC


        navigationController?.pushViewController(obj, animated: true)

      
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
