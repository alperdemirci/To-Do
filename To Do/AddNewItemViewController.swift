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
    @IBOutlet weak var shareEmailTextField: UITextField!
    @IBOutlet weak var sharedContinueSwitch: UISwitch!
    @IBOutlet weak var sharedEmailTextFieldHeightContsraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerSwitch: UISwitch!
    @IBOutlet weak var addLocationSwitch: UISwitch!
    
    @IBOutlet weak var locationSnapshotImageHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessage.isHidden = true
        self.sharedContinueSwitch.isOn = false
        self.datePickerSwitch.isOn = false
        self.addLocationSwitch.isOn = false
        self.navigationController?.navigationBar.isHidden = false
        
        // calls the keyboard show and keyboard height methods
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //height adjustment for animation show/hide
        self.sharedEmailTextFieldHeightContsraint.constant = 0
        self.datePickerHeightConstraint.constant = 0
        self.locationSnapshotImageHeightConstraint.constant = 0
    }
    
    // MARK: - UI Actions
    @IBAction func sharedContinueSwitchChanged(_ sender: Any) {
//        self.shareEmailTextField.isHidden = self.sharedContinueSwitch.isOn == false ?  true : false
        self.sharedEmailTextFieldHeightContsraint.constant = self.sharedContinueSwitch.isOn == false ? 0 : 60
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addDateChanged(_ sender: Any) {
        self.datePickerHeightConstraint.constant = self.datePickerSwitch.isOn == false ? 0 : 169
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addLocationChanged(_ sender: Any) {
        if self.addLocationSwitch.isOn == true {
            let vc = UIStoryboard(name:"MapView", bundle:nil).instantiateViewController(withIdentifier: "mapView") as? MapViewController
            //vc.resultsArray = self.resultsArray
            self.navigationController?.pushViewController(vc!, animated:true)
            self.locationSnapshotImageHeightConstraint.constant = self.datePickerSwitch.isOn == false ? 0 : 335
        }
    }
    
    @IBAction func DateValueChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY" //"MM dd, YYYY hh:mm a" //
        formatter.dateStyle = .full
        let strDate = formatter.string(from: datePicker.date)
        print(strDate)
        
        
        datePicker.datePickerMode = .date
        let selectedDate = datePicker.date
        print(selectedDate)
        
     
        let myDatePicker = datePicker
        myDatePicker?.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd YYYY"
        let date = dateFormatter.string(from: (myDatePicker?.date)!)
        print(date)
        
        let myDatePicker2 = datePicker
        myDatePicker2?.datePickerMode = .date
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "hh:mm a"
        let time = dateFormatter2.string(from: (myDatePicker2?.date)!)
        print(time)

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
            self.sharedContinueSwitchChanged((Any).self)
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
    
    // MARK: - Keyboard methods
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}

