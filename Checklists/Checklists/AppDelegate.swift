//
//  AppDelegate.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 01/25/2023 10:43pm.
//

import UserNotifications
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{



        func application(
	 _ application: UIApplication,
	 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
        {
	   //Notification authorization
	   let center = UNUserNotificationCenter.current()
	   /*
	    center.requestAuthorization(options: [.alert, .sound,])
	   {
	      granted, error in
	      if granted
	      {
		 print("We have permission")
	      }
	      else
	      {
		 print("Permission denied")
	      }
	   }
	   */
	   
	   center.delegate = self
	   
	   /*
	   let content = UNMutableNotificationContent()
	   content.title = "Hello!"
	   content.body = "I am a local notification"
	   content.sound = UNNotificationSound.default
	   
	   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
	   
	   let request = UNNotificationRequest(
	    identifier: "My Notification",
	    content: content,
	    trigger: trigger)
	   
	   center.add(request)
	   */
                return true
        }

        // MARK: UISceneSession Lifecycle

        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
        {
                return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
         }

   
        //Likely unnecessary, but not risking removal and then errors may follow
        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
        {
                // Called when the user discards a scene session.
                // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
                // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        }
   
   //MARK: - User Notification Delegates
   func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void)
   {
      //print("Received local notification \(notification)")
   }


}

