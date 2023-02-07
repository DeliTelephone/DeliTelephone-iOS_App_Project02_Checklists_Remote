//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 02/04/2023 at 9:57pm.
//


//NEW -- Entire File -- Chapter 16 for managing Multiple CheckLists
import UIKit

//Declare Protocols to pass Delegates
protocol ListDetailViewControllerDelegate: AnyObject
{
   func listDetailViewControllerDidCancel (
      _ controller: ListDetailViewController)
   
   func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishAdding checklist: CheckList)
   
   func listDetailViewController(
      _ controller: ListDetailViewController,
      didFinishEditing checklist: CheckList)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate
{
   
   //MARK: - Icon Picker View Controller Delegate
   func iconPicker(
      _ picker: IconPickerViewController,
      didPick iconName: String)
   {
      self.iconName = iconName
      IconImage.image = UIImage(named: iconName)
      navigationController?.popViewController(animated: true)
   }
   
 
   @IBOutlet var textField: UITextField!
   @IBOutlet var doneBarButton: UIBarButtonItem!
   @IBOutlet weak var IconImage: UIImageView!
   
   weak var delegate: ListDetailViewControllerDelegate?
   
   var checkListToEdit: CheckList?
   var iconName = "Folder"
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
       //Disable Large Titles
       navigationController?.navigationBar.prefersLargeTitles = false
       
       
       if let checkList = checkListToEdit
       {
	  title = "Edit CheckList"
	  textField.text = checkList.name
	  doneBarButton.isEnabled = true
	  
	  iconName = checkList.iconName
       }
       IconImage.image = UIImage(named: iconName)
    }
   
   override func viewWillAppear(
      _ animated: Bool)
   {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
   }

   
   //MARK: - Actions
   
   @IBAction func cancel()
   {
      delegate?.listDetailViewControllerDidCancel(self)
   }
   
   @IBAction func done()
   {
      if let checkList = checkListToEdit
      {
	 checkList.name = textField.text!
	 checkList.iconName = iconName
	 delegate?.listDetailViewController(
	    self,
	    didFinishEditing: checkList)
      }
      else
      {
	 let checkList = CheckList(name: textField.text!, iconName: iconName)
	 //checkList.iconName = iconName
	 delegate?.listDetailViewController(
	    self,
	    didFinishAdding: checkList)
      }
   }
   
   //MARK: - Table View Delegates
  
   override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath) -> IndexPath?
   {
      return indexPath.section == 1 ? indexPath : nil
   }
   
   //MARK: - Text Field Delegates
   func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool
   {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
	 in: stringRange,
	 with: string)
      
      doneBarButton.isEnabled = !newText.isEmpty
      
      return true
   }
   
   func textFieldShouldClear(
      _ textField: UITextField) -> Bool
   {
      doneBarButton.isEnabled = false
      
      return true
   }
   
    // MARK: - Navigation

   override func prepare(
      for segue: UIStoryboardSegue, sender: Any?)
   {
      if segue.identifier == "PickIcon"
      {
	 let controller = segue.destination as! IconPickerViewController
	 controller.delegate = self
      }
   }
   
   
   
}
