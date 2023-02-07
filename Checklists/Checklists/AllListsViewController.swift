//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 02/03/2023 at 9:40pm.
//

import UIKit

//NEW - Chapter 16
//MARK: - List Detail View Controller Delegates
class AllListsViewController: UITableViewController,
ListDetailViewControllerDelegate, UINavigationControllerDelegate
{
   
   //Declare Variables
   let cellIdentifier = "CheckListCell"
   var dataModel: DataModel!
   
   
   //Control Functions for Adding or Editing CheckLists
   func listDetailViewControllerDidCancel(
      _ controller: ListDetailViewController)
   {
      navigationController?.popViewController(animated: true)
   }
   
   func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishAdding checkList: CheckList)
   {
      dataModel.lists.append(checkList)
      //dataModel.sortCheckLists()
      tableView.reloadData()
      
      /*
      let newRowIndex = dataModel.lists.count
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      */
      navigationController?.popViewController(animated: true)
   }
   
   func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishEditing checkList: CheckList)
   {
      /*if let index = dataModel.lists.firstIndex(of: checkList)
      {
	 let indexPath = IndexPath(row: index, section: 0)
	 
	 if let cell = tableView.cellForRow(at: indexPath)
	 {
	    cell.textLabel!.text = checkList.name
	 }
      }*/
      
      //dataModel.sortCheckLists()
      tableView.reloadData()
      
      navigationController?.popViewController(animated: true)
   }
   

   
   //MARK: - Navigation
   
   //NEW -- Chapter 16:  sends the Title of the CheckList to the Add or Show CheckList Objects
   override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?)
   {
      if segue.identifier == "ShowCheckList"
      {
	 let controller = segue.destination as! CheckListViewController
	 controller.checkList = sender as? CheckList
      }
      else if segue.identifier == "AddCheckList"
      {
	 let controller = segue.destination as! ListDetailViewController
	 controller.delegate = self
      }
   }
   
   override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath)
   {
      dataModel.lists.remove(at: indexPath.row)
      
      let indexPaths = [indexPath]
      
      tableView.deleteRows(at: indexPaths, with: .automatic)
   }

   override func tableView(
      _ tableView: UITableView,
      accessoryButtonTappedForRowWith indexPath: IndexPath)
   {
      
      let controller = storyboard!.instantiateViewController(
	 withIdentifier: "ListDetailViewController") as! ListDetailViewController

      controller.delegate = self

      let checkList = dataModel.lists[indexPath.row]

      controller.checkListToEdit = checkList
      
      navigationController?.pushViewController(controller, animated: true)
   }
   
   
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

       //Enable Large Titles
       navigationController?.navigationBar.prefersLargeTitles = true
       
       //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
       
       //NEW - Chapter 17
       //     loadCheckLists()
       //Fake Data to prevent Crashing pre-adding FirstTime Code
       //var list = CheckList(name: "Groceries")
       //dataModel.lists.append(list)
       
       //NEW -- Chapter 16
       /*
	//Add PlaceHolder Data:
       var list = CheckList(name: "Birthdays")
       dataModel.lists.append(list)
       
       list = CheckList(name: "Groceries")
       dataModel.lists.append(list)
       
       list = CheckList(name: "Cool Apps")
       dataModel.lists.append(list)
       
       list = CheckList(name: "ToDo")
       dataModel.lists.append(list)
       */
       
    }
   
   override func viewDidAppear(
      _ animated: Bool)
   {
      super.viewDidAppear(animated)
      
      navigationController?.delegate = self
      
      let index = dataModel.indexOfSelectedCheckList
      
      if index >= 0 && index < dataModel.lists.count
      {
	 let checkList = dataModel.lists[index]
	 
	 performSegue(withIdentifier: "ShowCheckList", sender: checkList)
      }
   }
   
   
   override func viewWillAppear(_ animated: Bool)
   {
      super.viewWillAppear(animated)
      tableView.reloadData()
   }

    // MARK: - Table view data source

    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int
   {
      return dataModel.lists.count  //NEW -- Chapter 16 for Multiple CheckLists
   }
   
   override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
      let cell: UITableViewCell!
      if let temp = tableView.dequeueReusableCell(
	 withIdentifier: cellIdentifier)
      {
	 cell = temp
      }
      else
      {
	 cell = UITableViewCell(style: .subtitle,
	 reuseIdentifier: cellIdentifier)
      }
      
      //NEW - Chapter 16
      let checkList = dataModel.lists[indexPath.row]
      cell.textLabel!.text = checkList.name
      cell.accessoryType = .detailDisclosureButton
      
      let count = checkList.countUnCheckedItems()
      if checkList.items.count == 0
      {
	 cell.detailTextLabel!.text = "(No Items)"
      }
      else
      {
	 cell.detailTextLabel!.text = count == 0 ? "All Done!" : "\(count) Remaining"
      }
      
      cell.imageView!.image = UIImage(named: checkList.iconName)
      
      return cell
   }
   
   override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath)
   {
      
      dataModel.indexOfSelectedCheckList = indexPath.row
      
      let checkList = dataModel.lists[indexPath.row]
      
      UserDefaults.standard.set(
	 indexPath.row,
	 forKey: "CheckListIndex")
      
      performSegue(
	 withIdentifier: "ShowCheckList",
	 sender: checkList)

   }

   //MARK: - Navigation Controller Delegates
   func navigationController(
      _ navigationController: UINavigationController,
      willShow viewController: UIViewController,
      animated: Bool)
   {
      //Was the BACK Button Tapped?
      if viewController === self
      {
	 //UserDefaults.standard.set(-1, forKey: "CheckListIndex")
	 dataModel.indexOfSelectedCheckList = -1
      }
   }
   
}
