//
//  AppDelegate.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 07/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import SwiftMessageBar
import DropDown
import Alamofire
import SwiftyJSON


let appDelegate = UIApplication.shared.delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

      var window: UIWindow?

     var ApiBaseUrl = "http://ausnsclab.esy.es/api/api.php"
    
  var ApiImageUrl = "http://ausnsclab.esy.es/api/upload_image.php"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = SwiftMessageBar.Config.Builder()
                 .withErrorColor(errorColor)
                 .withSuccessColor(successColor)
                 .withInfoColor(themeColor)
                 .withMessageColor(blackColor)
                 .withTitleColor(blackColor)
                 .build()
             SwiftMessageBar.setSharedConfig(config)
             
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

