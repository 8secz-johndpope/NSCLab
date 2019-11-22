//
//  DocumentViewVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class DocumentViewVC: UIViewController{
    

    @IBOutlet weak var webView: WKWebView!
    
    
    @IBOutlet weak var headerView: UIView!
    
    
    
    @IBOutlet weak var btnDownload: UIButton!
   
    var path = String()
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton(type: .custom)
        let image = UIImage(named: "icon_download")?.withRenderingMode(.alwaysTemplate)
        btnDownload.setImage(image, for: .normal)
        btnDownload.tintColor = UIColor.white
        headerView.backgroundColor = Colors.HeaderColor
        
        
      
        //let path = Bundle.main.path(forResource: "pdf", ofType: "pdf")
                   let url = URL(string: path)
        let request = URLRequest(url: url!)
                   
        self.start()
        webView.load(request)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loader), userInfo: nil, repeats: true)
    }
    
    
    @objc func loader() {
        
        if  !webView.isLoading{
            self.view.isUserInteractionEnabled = true
            self.stopAnimating()
            timer.invalidate()
        }
    }
   

    @IBAction func btnBack(_ sender: UIButton)
    {
         navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownloadTUI(_ sender: UIButton)
    {
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        self.start()
        let url = path
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
                    PopUp(Controller: self, title: "Done!", message: "Download successfull", type: .success, time: 3)
                    self.stopAnimating()
                    //result closure
                })
    
    }
}
