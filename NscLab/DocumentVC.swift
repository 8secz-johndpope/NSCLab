//
//  DocumentVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DocumentVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    //-----------------------
    //MARK:Outlets
    //-----------------------
    
 
    
    @IBOutlet weak var headerView: UIView!
    
      
    @IBOutlet weak var tblDocumentView: UITableView!
    
    //-------------------------
    // MARK: Identifiers
    //-------------------------
    
    var timer = Timer()
    var docData = JSON()
 
    //----------------------------
    //MARK: View Life Cycle
    //----------------------------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        headerView.backgroundColor = Colors.HeaderColor
        
//
       self.tblDocumentView.tableFooterView = UIView()
        
        tblDocumentView.rowHeight = 80
        
        documentApi()
    }
    
  
    
    //----------------------------
    //MARK: Delegate Methods
    //----------------------------
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return docData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tblDocumentView.dequeueReusableCell(withIdentifier: "tblDocumentCell") as! tblDocumentCell
        
      
     
        cell.lblDocument.text = docData[indexPath.row]["documentName"].stringValue
       
        cell.btnDownload.tag = indexPath.row
    
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        let obj = storyboard?.instantiateViewController(withIdentifier: "DocumentViewVC") as! DocumentViewVC
      
        obj.path = self.docData[indexPath.row]["documentPath"].stringValue

        navigationController?.pushViewController(obj, animated: true)

      
    }
   
    //----------------------------
    //MARK: User Defined Fuction
    //----------------------------
    
    
    @objc func InternetAvailable()
    {
        if Connectivity.isConnectedToInternet()
        {
           documentApi()
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
    
    @IBAction func btnDocumentTUI(_ sender: UIButton)
    {
       let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        self.start()
        let url = self.docData[sender.tag]["documentPath"].stringValue
                 Alamofire.download(
                     url,
                     method: .get,
                     parameters: nil,
                     encoding: JSONEncoding.default,
                     headers: nil,
                     to: destination).downloadProgress(closure: { (progress) in
                         //progress closure
                         
                           print("Upload Progress: \(progress.fractionCompleted)")
                         
                         
                     }).response(completionHandler: { (DefaultDownloadResponse) in
                         //here you able to access the DefaultDownloadResponse
                         
                         print(DefaultDownloadResponse.destinationURL?.lastPathComponent)
                         
                         print(DefaultDownloadResponse.destinationURL)
                        PopUp(Controller: self, title: "Done!", message: "Download Successfull", type: .success, time: 3)
                        self.stopAnimating()
                         //result closure
                     })
         
         
    }
    
    //----------------------------
    //MARK: Web Services
    //----------------------------
    
func documentApi()
            {

                if Connectivity.isConnectedToInternet()
                {

                    let parameter = ["type":"documentList","conference_id":conferenceId] as [String : Any]

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

                                   self.docData = result["document_list"]
                                   
                                 
                                   self.tblDocumentView.reloadData()

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
