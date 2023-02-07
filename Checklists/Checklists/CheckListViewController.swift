//
//  ViewController.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 01/25/2023 10:43pm.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate
{
   
   //Declare Variables
   //removed, Chapter 17 to make each CheckList Unique  //var items = [CheckListItem]()
   var checkList: CheckList!
   
   
   
   //Declare View Controllers and call Navigation Controllers
   func itemDetailViewControllerDidCancel(
      _ controller: ItemDetailViewController)
   {
      navigationController?.popViewController(animated: true)
   }
   
   func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishAdding item: CheckListItem)
   {
      let newRowIndex = checkList.items.count
      checkList.items.append(item)
      
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      
      navigationController?.popViewController(animated: true)
      
      //saveCheckListItems()
   }
   
   
        override func viewDidLoad() {
                super.viewDidLoad()

	   
	   //Disable Large Titles
	   navigationItem.largeTitleDisplayMode = .never
	   
	   //Load Items
	   loadCheckLists()
	   
	   //NEW -- Chapter 16, set the name for each CheckList Item 
	   title = checkList.name
	   
	   /*
	   print("Documents Folder is \(documentsDirectory())")
	   print("DataFile Path is \(dataFilePath())")
	   */

	}
   
func documentsDirectory() -> URL
   {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
   }
   func dataFilePath() -> URL
   {
      return documentsDirectory().appendingPathComponent("Checklists.plist")
   }
   

  func loadCheckLists()
   {
      let path = dataFilePath()
      
      if let data = try? Data(contentsOf: path)
      {
	 let decoder = PropertyListDecoder()

	 do
	 {
	   let lists = try decoder.decode(
	       [CheckList].self,
	       from: data)
	 }
	 catch
	 {
	    print("Error decoding item array \(error.localizedDescription)")
	 }
      }
      
   }
   
   
   //MARK: - Navigation
   
   //Determines if the Label on the Change Item Text Value needs to say: "Edit Items" or "Add Items"
   override func  prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
      if segue.identifier == "AddItem"
      {
	 let controller = segue.destination as! ItemDetailViewController
	 controller.delegate = self
      }
      else if segue.identifier == "EditItem"
      {
	 let controller = segue.destination as! ItemDetailViewController
	 controller.delegate = self
	 
	 if let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
	 {
	    controller.itemToEdit = checkList.items[indexPath.row]
	 }
      }
      
   }
   
   
        // MARK: - Table View Data Source

   //Toggles CheckMark Icon when row is tapped
   func configureCheckmark (
      for cell: UITableViewCell,
      with item: CheckListItem)
   {
      let label = cell.viewWithTag(1702) as! UILabel
	 //702 is my favorite number, and the book says this value is arbitrary, so I just customized them.
      
      if item.checked
      {
	 label.text = "√"
      }
      else
      {
	 label.text = ""
      }
   }
   
   //Sets the Text in the selected cell for Editing.
   func configureText (
      for cell: UITableViewCell,
      with item: CheckListItem)
   {
      let label = cell.viewWithTag(702) as! UILabel
	 //702 is my favorite number, and the book says this value is arbitrary, so I just customized them.

      //label.text = item.text
      label.text = "\(item.text)"
   }

   
   //This Function Updates the Text Field in the Items List, if the use decides to change them
   func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: CheckListItem)
   {
      if let index = checkList.items.firstIndex(of: item)
      {
	 let indexPath = IndexPath(row: index, section: 0)
	 if let cell = tableView.cellForRow(at: indexPath)
	 {
	    configureText(for: cell, with: item)
	 }
      }
      navigationController?.popViewController(animated: true)
      
      //saveCheckListItems()

   }
   
   //Toggles CheckMark to appear/disappear when the respective row is tapped.
   override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath)
   {
      if let cell = tableView.cellForRow(at: indexPath)
      {
	 let item = checkList.items[indexPath.row]
	 
	 item.checked.toggle()
	 
      configureCheckmark(for: cell, with: item )
      }
      else
      {
	 print("This should never happen!!  Find out why and fix it.")
      }
      tableView.deselectRow(at: indexPath, animated: true)
      
      //saveCheckListItems()

   }

        //Get Number of Items in the CheckList
        override func tableView(
                _ tableView: UITableView,
                numberOfRowsInSection section: Int) -> Int
                {
		   return checkList.items.count
		}
   
   
        override func tableView(
                _ tableView: UITableView,
                cellForRowAt indexPath: IndexPath) -> UITableViewCell
                {
		   let cell = tableView.dequeueReusableCell(
                        withIdentifier: "CheckListItem",
  	               for: indexPath)
	   
		   let item = checkList.items[indexPath.row]
		 
		   configureText(for: cell, with: item)
		   configureCheckmark(for: cell, with: item)
	   
	 
		   return cell
		  }
          
          //Remove Items when user swipes right on a Row
          override func tableView(
                  _ tableView: UITableView,
                  commit editingStyle: UITableViewCell.EditingStyle,
                  forRowAt indexPath: IndexPath)
                  {
		     checkList.items.remove(at: indexPath.row)
      
		     let indexPaths = [indexPath]
		     tableView.deleteRows(at: indexPaths, with: .automatic)
		     
		     //saveCheckListItems()

		  }
   
   
  /*
          func documentDirectory() -> URL
          {
	     let paths = FileManager.default.urls(
	       for: .documentDirectory,
	       in: .userDomainMask)
	     
	     return paths[0]
          }
   
          func dataFilePath() -> URL
          {
	     return documentDirectory().appendingPathComponent("Checklists.plist")
	  }
   
   
           func saveCheckListItems()
           {
                let encoder = PropertyListEncoder()
                do
                {
		   let data = try encoder.encode(checkList.items)
	 
		   try data.write(
		     to: dataFilePath(),
		     options: Data.WritingOptions.atomic)
		}
	      catch
	      {
		 print("Error encountered item array: \(error.localizedDescription)")
	      }
	   }
   */
}

