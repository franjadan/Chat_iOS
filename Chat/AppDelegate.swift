//
//  AppDelegate.swift
//  Chat
//
//  Created by francisco.adan on 22/01/2020.
//  Copyright © 2020 francisco.adan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Override point for customization after application launch.
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            
            switch response.actionIdentifier {
                case "SLEEP_ACTION":
                    AppData.activeChat = aps["alert"]!["title"] as! String
                    sendMessage(message: "Ahora no puedo hablar")
                    break
                default:
                    AppData.activeChat = aps["alert"]!["title"] as! String
                    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let page = mainStoryboard.instantiateViewController(withIdentifier: "messages") as! ViewController
                    let rootViewController = window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(page, animated: true)
                    
                    break
            }
            
            completionHandler()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Permiso: \(granted)")
                guard granted else {return}
                
                let sleepAction = UNNotificationAction(identifier: "SLEEP_ACTION", title: "No puedo hablar", options: [.foreground])
                
                let categoria = UNNotificationCategory(identifier: "sleep", actions: [sleepAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
                
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.setNotificationCategories([categoria])
                
                self?.getNotificationsSettings()
            }
        }
    }
    
    func getNotificationsSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Configuration Push: \(settings)")
            guard settings.authorizationStatus == .authorized else {return}
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Token del dispositivo: \(token)")
    }
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error en el registro: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //Si la aplicación se está ejecutando
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String:AnyObject] else {
            completionHandler(.failed)
            return
        }
        
    
        
        /*
         
        completionHandler(.noData)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        let alert = UIAlertController(title: aps["alert"]!["title"] as! String, message: aps["alert"]!["body"] as! String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
 
        */
        
        DispatchQueue.main.async {
            AppData.messages[aps["alert"]!["title"] as! String]?.append((aps["alert"]!["title"] as! String,aps["alert"]!["body"] as! String))
            
            if AppData.activeChat == aps["alert"]!["title"] as! String {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let page = mainStoryboard.instantiateViewController(withIdentifier: "messages") as! ViewController
                let rootViewController = window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(page, animated: true)
            } /*else {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = "Hola"
                content.subtitle = ""
                content.body = aps["alert"]?["body"] as! String
                content.sound = .default
                let request = UNNotificationRequest(identifier: "NOTIFICACION", content: content, trigger: trigger)
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().add(request){ error in
                if let _ = error{
                    print("¡ERROR!")
                    }
                }
            }*/
        }
        
    }
                
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if AppData.activeChat != notification.request.content.title {
            completionHandler([.alert, .sound])
        }
        
        /*
        print("ok")
        
        DispatchQueue.main.async {
            
            if AppData.activeChat == notification.request.content.title {
                AppData.messages[AppData.activeChat]?.append((notification.request.content.title,notification.request.content.body))
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                               
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let page = mainStoryboard.instantiateViewController(withIdentifier: "messages") as! ViewController
                let rootViewController = window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(page, animated: true)
            } else {
                AppData.messages[notification.request.content.title]!.append((notification.request.content.title,notification.request.content.body))
            }
        }
 */
    }
    
    func sendMessage(message: String){
        if !message.isEmpty {
            let urlString = "https://qastusoft.es/test/estech/\(AppData.activeChat)/index.php?token=\(AppData.contacts[AppData.activeChat]!)&title=Fran&body=\(message.replacingOccurrences(of: " ", with: "%20"))"
            print(urlString)
                
                guard let url = URL(string: urlString) else { return }

                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        AppData.messages[AppData.activeChat]?.append((AppData.activeChat, message))
                        
                        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let page = mainStoryboard.instantiateViewController(withIdentifier: "messages") as! ViewController
                        let rootViewController = window!.rootViewController as! UINavigationController
                        rootViewController.pushViewController(page, animated: true)
                    }
                    
                    /*

                    guard let data = data else { return }

                    do {

                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        
                        print(json)
                        
                        
                    } catch let jsonError {
                        print(jsonError)
                    }
                     */

                }.resume()
            }
        }
    }

