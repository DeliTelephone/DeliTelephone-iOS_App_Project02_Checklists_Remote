//
//  CheckList.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 02/04/2023.
//

import UIKit

//NEW -- Chapter 16, adds Initilization for Multiple CheckLists
class CheckList: NSObject, Codable
{
   var name = ""
   var iconName = "No Icon"
   var items = [CheckListItem]()
  
   
   init(name: String, iconName: String = "No Icon")
   {
      self.name = name
      self.iconName = iconName
      super.init()
   }
   
   //added next two "Fake" Functions, to make errors go away...no idea what these do or why they are needed here and Not in the TextBook Code
   func encode(to encoder: Encoder)
   {
   }
   
   required init(from decoder: Decoder)
   throws
   {
      //var dummyDecode = 0
   }
   
   func countUnCheckedItems() -> Int
   {
      var count = 0
      for item in items
      {
	 if item.checked == false
	 {
	    count = count + 1
	 }
      }
      
      return count
   }
   
}


