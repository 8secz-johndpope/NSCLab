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
import Firebase


let appDelegate = UIApplication.shared.delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate
{

      var window: UIWindow?
    var FcmId = String()
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
        
        
        if #available(iOS 10.0, *)
        {
            // For iOS 10 display notification (sent via APNS)
            
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
           
            if #available(iOS 11.0, *) {
                
                UNUserNotificationCenter.current().setNotificationCategories([])
                
            } else {
                // Fallback on earlier versions
            }
            
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
             
        FirebaseApp.configure()

        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.FcmId = result.token
            }
        }

        dmyFormat.dateFormat = "dd/MM/yyyy"
        ymdFormat.dateFormat = "yyyy-MM-dd"
        dmmmyFormat.dateFormat = "dd MMM yyyy"
        hmaFormat.dateFormat = "hh:mma"
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
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            Messaging.messaging().apnsToken = deviceToken
            print(deviceTokenString)
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            
            print("i am not available in simulator \(error)")
            
            UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
                
                switch settings.soundSetting{
                case .enabled:
                    
                    print("enabled sound setting")
                    
                case .disabled:
                    
                    print("setting has been disabled")
                    
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        }
        
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
        {
            
            print("i receive notification")
            Messaging.messaging().appDidReceiveMessage(userInfo)
            
            if let messageID = userInfo["reference_id"] {
                print("Message ID: \(messageID)")
            }
            print(userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
            
        }
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
        {
            
            let userInfo = response.notification.request.content.userInfo
            
            Messaging.messaging().appDidReceiveMessage(userInfo)
            print(response.actionIdentifier)
            print(userInfo)
            switch response.actionIdentifier
            {
            
            default:
                let title = (userInfo["title"] as! String)
                let body = (userInfo["body"] as! String)
                
                let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
    //            if userInfo["notiType"] as! String == "1"
    //            {
    ////                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    ////                let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "RequestVC") as UIViewController
    ////                if let navigationController = self.window?.rootViewController as? UINavigationController
    ////                {
    ////                    navigationController.pushViewController(initialViewControlleripad, animated: false)
    ////                }
    ////                else
    ////                {
    ////                    print("Navigation Controller not Found")
    ////                }
    //            }
    //            else
    //            {
    //
    //            }
                
                
                
                print("no option selected")
                
            }
            
            print(userInfo)
            print(response)
            completionHandler()
        }
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            print("i will present notification")
            let userInfo = notification.request.content.userInfo
            Messaging.messaging().appDidReceiveMessage(userInfo)
            let dict = notification.request.content.userInfo["aps"] as! NSDictionary
            var messageBody:String?
            var messageTitle:String = "Alert"
            
            if let alertDict = dict["alert"] as? Dictionary<String, String> {
                  messageBody = alertDict["body"]!
                if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
                
            } else {
                messageBody = dict["alert"] as? String
            }
            
            print("Message body is \(messageBody!) ")
            print("Message messageTitle is \(messageTitle) ")
            
            print(notification)
            print(userInfo)
            let alertController = UIAlertController(title: messageTitle, message: messageBody, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            completionHandler([.sound, .alert])
            
        }
        func application(received remoteMessage: MessagingRemoteMessage)
        {
            print("i received remoteMessage")
            print(remoteMessage.appData)
            Messaging.messaging().appDidReceiveMessage(remoteMessage.appData)
        }
        
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            Messaging.messaging().shouldEstablishDirectChannel = true
        }
        func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
        {
            print("i did receive remoteMessage")
            print(remoteMessage.debugDescription)
            print(remoteMessage.appData)
        }


}

