//
//  CheckListItem.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 01/26/2023 10:43pm.
//

import Foundation
import UserNotifications

//Create the CheckList: NSObject used in another function elsewhere in the Code Files

class CheckListItem: NSObject
{
   var text = ""
   var checked = false
   var dueDate = Date()
   var shouldRemind = false
   var itemID = -1
   
   override init()
   {
      super.init()
      itemID = DataModel.newCheckListItemID()
   }
   
   deinit
   {
      removeNotification()
   }
   
   
   func scheduleNotification()
   {
      removeNotification()
      
      if shouldRemind && dueDate > Date()
      {
	let content = UNMutableNotificationContent()
	 content.title = "Reminder:"
	 content.body = text
	 content.sound = UNNotificationSound.default
	 
	 let calendar = Calendar(identifier: .gregorian)
	 let components = calendar.dateComponents(
	    [.year, .month, .day, .hour, .minute],
	    from: dueDate)
	 
	 let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
	 
	 let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
	 
	 let center = UNUserNotificationCenter.current()
	 center.add(request)
	 
	 //print("Scheduled: \(request) for itemID: \(itemID)")
	 
      }
   }
   
   func removeNotification()
   {
      let center = UNUserNotificationCenter.current()
      
      center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
   }
   
}
