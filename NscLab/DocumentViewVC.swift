//
//  DocumentViewVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import WebKit

class DocumentViewVC: UIViewController {
    

    @IBOutlet weak var webView: WKWebView!
    
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headerView.backgroundColor = Colors.HeaderColor
              
            if let pdfURL = Bundle.main.url(forResource: "mcwc 1.pdf", withExtension: "pdf", subdirectory: nil, localization: nil)  {
                do {
                    let data = try Data(contentsOf: pdfURL)
                    let webView = WKWebView(frame: CGRect(x:20,y:20,width:view.frame.size.width-40, height:view.frame.size.height-40))
                    webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
                   view.addSubview(webView)

                }
                catch {
                    // catch errors here
                }

            }
    }
    

    @IBAction func btnBack(_ sender: UIButton)
    {
         navigationController?.popViewController(animated: true)
    }
    
}
