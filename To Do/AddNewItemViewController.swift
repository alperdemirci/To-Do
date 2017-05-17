//
//  AddNewItemViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {
    var database = FirebaseDataAdapter()
    
    // MARK: Outlets
    @IBOutlet weak var sharedContinueSwitch: UISwitch!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var shareEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessage.isHidden = true
        self.sharedContinueSwitch.isOn = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func newTodoAdded(_ sender: Any) {
        if self.todoTextField.text != "" {
            self.errorMessage.text = "please write something first"
            self.errorMessage.isHidden = false
            self.navigationController?.popViewController(animated: true)
            
        }
        let currentDateTime = Date()
        if self.sharedContinueSwitch.isOn==true && self.shareEmailTextField.text=="" {
            self.sharedContinueSwitch.isOn = false
            self.sharedContinueSwitchChanged(Any)
            //TODO: ask user if the are sure not to share this todo with a user
        }
        self.database.writeTodoIntoDB(value: self.todoTextField.text!, date: currentDateTime, sharedEmail: self.shareEmailTextField.text ?? "" ) { (check) in
            if check {
                // TODO: all good
            } else {
                // TODO: need to save the todo to phone
            }
        }
    }
    
    @IBAction func sharedContinueSwitchChanged(_ sender: Any) {
        self.shareEmailTextField.isHidden = self.sharedContinueSwitch.isOn == false ?  true : false
    }
}
