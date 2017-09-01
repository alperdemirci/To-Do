//
//  AddNewItemViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

enum dataMode {
    case dataEdit
    case dataNew
}

class AddNewItemViewController: UIViewController, ScreenshotProtocol {
    var database = FirebaseDataAdapter()
    var addMapView = MapViewController()
    // MARK: Outlets
    
    var modeCheck: String = ""
    var timeAndDate: String = ""
    
    var screenshot: UIImage?
    var currentCellDataToBeEdited: Users?
    
    @IBOutlet weak var imagePreview: UIImageView!
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
        self.sharedContinueSwitch.isOn = false
        self.datePickerSwitch.isOn = false
        self.addLocationSwitch.isOn = false

        self.errorMessage.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        // calls the keyboard show and keyboard height methods
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //height adjustment for animation show/hide
        self.sharedEmailTextFieldHeightContsraint.constant = 0
        self.datePickerHeightConstraint.constant = 0
        self.locationSnapshotImageHeightConstraint.constant = 0
        
        self.modeChecker()
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
            self.locationSnapshotImageHeightConstraint.constant = 335
            let vc = UIStoryboard(name:"MapView", bundle:nil).instantiateViewController(withIdentifier: "mapView") as? MapViewController
            
            vc!.delegate = self
            self.navigationController?.pushViewController(vc!, animated:true)
        } else {
            self.locationSnapshotImageHeightConstraint.constant = 0
            self.screenshot = nil
            
        }
    }
    
    @IBAction func DateValueChanged(_ sender: Any) {
        //TODO: push the date to db
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let timeString = datePicker.date.iso8601
        self.timeAndDate = timeString
    }
    
    func screenshotImage(image: UIImage) {
        self.screenshot = image
        self.imagePreview.image = image
    }
    
    @IBAction func newTodoAdded(_ sender: Any) {
        if self.todoTextField.text != "" {
            self.errorMessage.text = "please write something first"
            self.errorMessage.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
//        let currentDateTime = Date()
        if self.sharedContinueSwitch.isOn==true && self.shareEmailTextField.text=="" {
            self.sharedContinueSwitch.isOn = false
            self.sharedContinueSwitchChanged((Any).self)
            //TODO: ask user if the are sure not to share this todo with a user
        }
        
        self.database.writeTodoIntoDB(image: self.screenshot, value: self.todoTextField.text!, date: self.timeAndDate, sharedEmail: self.shareEmailTextField.text ?? "" ) { (check) in
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
    
//    func callingViewController(_ toNew: dataMode)  {
//        switch toNew {
//        case .dataNew:
////            self.testing = "New"
//            self.modeChecker()
////            print("Data New")
//            break
//            //new settings will not change
//        case .dataEdit:
////            print("Data Edit", self.currentCellDataToBeEdited ?? " ")
//            break
//            //fetch user data from DB
//        }
//    }
    
    func modeChecker() {
        
        //TODO: datepicker show real date from db
        //self.datePicker.date = self.currentCellDataToBeEdited?.timestamp

        if self.modeCheck == "Edit" {
            //map Switch
            self.currentCellDataToBeEdited?.locationAdded == "true" ? addLocationSwitch.setOn(true, animated: true) : addLocationSwitch.setOn(false, animated: true)
            //Shared Switch
            self.currentCellDataToBeEdited?.sharedEmail != "" ? (self.sharedContinueSwitch.isOn = true) : (self.sharedContinueSwitch.isOn = false)
            self.currentCellDataToBeEdited?.sharedEmail != "" ? (self.sharedEmailTextFieldHeightContsraint.constant = 60) : (self.sharedEmailTextFieldHeightContsraint.constant = 0)
            //Date Swich
            if self.currentCellDataToBeEdited?.timestampcurrent != nil {
                let date = Date.dateFromISOString((self.currentCellDataToBeEdited?.timestampcurrent)!)
                datePicker.date = date
            }
            self.datePickerHeightConstraint.constant = self.currentCellDataToBeEdited?.timestampcurrent == nil ? 0 : 169
            self.currentCellDataToBeEdited?.timestampcurrent != nil ? self.datePickerSwitch.setOn(true, animated: true) : self.datePickerSwitch.setOn(false, animated: true)
            //Shared Email Switch
            self.shareEmailTextField.text = self.currentCellDataToBeEdited?.sharedEmail
            self.sharedEmailTextFieldHeightContsraint.constant = self.sharedContinueSwitch.isOn == false ? 0 : 60
            self.currentCellDataToBeEdited?.value != nil ? (self.todoTextField.text = self.currentCellDataToBeEdited?.value) : (self.todoTextField.text = nil)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            if self.currentCellDataToBeEdited != nil {
                print(self.currentCellDataToBeEdited ?? "Nothing ")
                        }

        } else if self.modeCheck == "Add" {
            
        }
        
        else {
            print("Wrong mode")
        }
    }
}










