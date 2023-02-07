//
//  DataModel.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 02/06/2023
//

import Foundation

class DataModel
{
   var lists = [CheckList]()
   
   init()
   {
      loadCheckLists()
      registerDefaults()
      handleFirstTime()
   }
   
      //MARK: - Data Saving
   func documentsDirectory() -> URL
   {
      let paths = FileManager.default.urls(
	 for: .documentDirectory,
	 in: .userDomainMask)
      
      return paths[0]
   }
   
   func dataFilePath() -> URL
   {
      print( documentsDirectory().appendingPathComponent("Checklists.plist") )
      
      return documentsDirectory().appendingPathComponent("Checklists.plist")
   }
   
   func saveCheckLists()
   {
      let encoder = PropertyListEncoder()
      
      do
      {
	 let data = try encoder.encode(lists)
	 try data.write(
	    to: dataFilePath(),
	    options: Data.WritingOptions.atomic)
      }
      catch
      {
	 print("Error encoding list array: \(error.localizedDescription)")
      }
   }
   
   func loadCheckLists()
   {
      let path = dataFilePath()
      if let data = try? Data(contentsOf: path)
      {
	 let decoder = PropertyListDecoder()
	 
	 do
	 {
	    lists = try decoder.decode(
	       [CheckList].self,
	       from: data)
	    //sortCheckLists()
	 }
	 catch
	 {
	    print("Error decoding list array: \(error.localizedDescription)")
	 }
      }
   }
   
   func registerDefaults()
   {
      let dictionary = ["CheckListIndex": -1,
			"FirstTime": true]
			as [String: Any]
      
      UserDefaults.standard.register(defaults: dictionary)
   }
   
   var indexOfSelectedCheckList: Int
   {
      get
      {
	 return UserDefaults.standard.integer(forKey: "CheckListIndex")
      }
      set
      {
	 UserDefaults.standard.set(newValue, forKey: "CheckListIndex")
      }
   }
   
   func handleFirstTime()
   {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")
      
      if firstTime
      {
	 let checkList = CheckList(name: "List")
	 lists.append(checkList)
	 
	 indexOfSelectedCheckList = 0
	 userDefaults.set(false, forKey: "FirstTime")
      }
   }
   
   //Does NOT work.  Perhaps they took just Sort() away in the latest update, or the book gave wrong code.  Got like 5 errors trying to leave this uncommented:
   /*
   func sortCheckLists()
   {
      lists.sort {list1, list2, in return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
       
      }
   }
    */
   
   class func newCheckListItemID() -> Int
   {
      let userDefaults = UserDefaults.standard
      let itemID = userDefaults.integer(forKey: "CheckListItemID")
      userDefaults.set(itemID + 1, forKey: "CheckListItemID")
      
      return itemID
   }
   
}
