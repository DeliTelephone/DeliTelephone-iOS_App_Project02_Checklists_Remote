//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Nick "Fox" Borer on 01/26/2023.
//

import UIKit
import UserNotifications


//Protocol Declarations -- to handle events automatically in the StoryBoard
protocol ItemDetailViewControllerDelegate: AnyObject
{
   func itemDetailViewControllerDidCancel(
      _ controller: ItemDetailViewController)
   
   func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishAdding item: CheckListItem
       )
   
   func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: CheckListItem
   )
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate
{
   //Declare Outlets to "hookup" to the Storyboard Controls
   //@IBOutlet weak var textFieldAddItem: UITextField!
   @IBOutlet weak var textField: UITextField!
   
   @IBOutlet weak var doneBarButton: UIBarButtonItem!
   
   @IBOutlet weak var shouldRemindSwitch: UISwitch!
   
   @IBOutlet weak var datePicker: UIDatePicker!
   
   
   weak var delegate: ItemDetailViewControllerDelegate?
   var itemToEdit: CheckListItem?
   
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

       
       //checks if the Item Edit Screen is up, and then change the Label up top to "Edit Item"
       if let item = itemToEdit
       {
	  title = "Edit Item"
	  textField.text = item.text
	  doneBarButton.isEnabled = true
	  
	  shouldRemindSwitch.isOn = item.shouldRemind
	  datePicker.date = item.dueDate
       }
       
       navigationItem.largeTitleDisplayMode = .never
       
    }

   /*
    // MARK: - Table view data source

    override func numberOfSections(
      in tableView: UITableView) -> Int
      {
        return 0
      }

    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int
      {
        return 0
      }
*/
   
   //MARK: - Actions
   
   //Close the Edit or Add Item View Screen, if Cancel Button is tapped
   @IBAction func cancel()
   {
	delegate?.itemDetailViewControllerDidCancel(self)
   }
   
   //Perform necessary "Add Item"/"Edit Item" actions after Done Button is tapped
   @IBAction func done ()
   {
          
      if let item = itemToEdit
      {
	 item.text = textField.text!
	 
	 item.shouldRemind = shouldRemindSwitch.isOn
	 item.dueDate = datePicker.date
	 
	 item.scheduleNotification()
	 
	 delegate?.itemDetailViewController(self, didFinishEditing: item)
      }
      else
      {
	 let item = CheckListItem()
	 item.text = textField.text!

	 item.shouldRemind = shouldRemindSwitch.isOn
	 item.dueDate = datePicker.date
	 
	 delegate?.itemDetailViewController(self, didFinishAdding: item)
      }
   }
   
   @IBAction func shouldRemindToggled(
      _ switchControl: UISwitch)
   {
      textField.resignFirstResponder()
      
      if switchControl.isOn
      {
	 let center = UNUserNotificationCenter.current()
	 center.requestAuthorization(options: [.alert, .sound])
	 {
	    _, _ in
	    //do nothing
	 }
      }
   }
   
   override func viewWillAppear(
      _ animated: Bool)
   {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
   }
   
   //Enable the Done Button whenever there is anything but an Empty String in the Text Box
   func textFieldShouldClear(_ textField: UITextField) -> Bool
   {
      doneBarButton.isEnabled = false
      
      return true
   }
   
   //MARK: - Table View Delegates
   
   override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath) -> IndexPath?
   {
      return nil
   }
   
   //MARK: - Text Field Delegates
   
   
   
   //This Function checks for changes in the TEXT Value of the TextField Object.
   //If empty, then disable the Done Button.
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

      /*
       The Next Line (commented out) is just another way to write the below-er code, instead of the
	long way of IF ELSE Statements, but I like the Style of the below better, as I can read it more easily.  For now I will stick with this Style, but will definitely adopt the UI Swift standard syntax, once these functions start to click a little more.
       */
       //doneBarButton.isEnabled = !newText.isEmpty
      
      if newText.isEmpty
      {
	 doneBarButton.isEnabled = false
      } else
      {
	 doneBarButton.isEnabled = true
      }
      
      return true
   }

}
