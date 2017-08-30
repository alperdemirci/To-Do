//
//  InitialViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit
import Firebase


enum passwordChecked {
    case alphabetChecked
    case lengthChecked
    case SpecialCharChecked
}

class LoginRegistrationViewController: UIViewController {
    
    var database = FirebaseDataAdapter()
    var tempConstraints: CGFloat = 60
    var isSignIn: Bool = true
    
    @IBOutlet weak var alphabetValidationCheck: UILabel!
    @IBOutlet weak var lengthValidationCheck: UILabel!
    @IBOutlet weak var specialCharValidationCheck: UILabel!
    @IBOutlet weak var passwordErrorMessages: UILabel!
    @IBOutlet weak var ValidationStackView: UIStackView!
    @IBOutlet weak var emailErrorMessages: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var signinSelector: UISegmentedControl!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var emailTFConstraintsToPicker: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.changeNames()
        if Auth.auth().currentUser?.uid != nil {
            let vc = UIStoryboard(name:"ListItemsView", bundle:nil).instantiateViewController(withIdentifier: "listItem") as? ListItemTableViewController
            self.navigationController?.pushViewController(vc!, animated:true)
//            let vc = UIStoryboard(name:"MainTest", bundle:nil).instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController
//            self.navigationController?.pushViewController(vc!, animated:true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        self.passwordErrorMessages.isHidden = false
        if (self.passwordTextField != nil) {
            let passwordlength = self.passwordTextField.text?.characters.count
            let passwordAlphabet = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z]).*[a-z].{1,}")
            let passwordSpecialC = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[!@#$&*]).{1,}")
            if passwordlength! <= 8 {
                self.lengthValidationCheck.textColor = .red
            } else {
                self.lengthValidationCheck.textColor = .green
            }
            if passwordAlphabet.evaluate(with: self.passwordTextField.text) != true {
                self.alphabetValidationCheck.textColor = .red
            } else {
                self.alphabetValidationCheck.textColor = .green
            }
            if passwordSpecialC.evaluate(with: self.passwordTextField.text) != true {
                self.specialCharValidationCheck.textColor = .red
            } else {
                self.specialCharValidationCheck.textColor = .green
            }
        }
        
    }
    
    @IBAction func signinSelectorChanged(_ sender: Any) {
        self.isSignIn = !self.isSignIn
        self.changeNames()
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        guard let email = emailtextField.text, let password = passwordTextField.text, let userName = self.userNameTextField.text else {
            
            // you need to fill out both rext field alert box
            return
        }
        if self.isSignIn {
            self.database.userSignIn(email, password: password, completionBlock: { (user, error) in
                if error != nil {
                    //wrong password
                    return
                }
                let vc = UIStoryboard(name:"ListItemsView", bundle:nil).instantiateViewController(withIdentifier: "listItem") as? ListItemTableViewController
                //vc.resultsArray = self.resultsArray
                self.navigationController?.pushViewController(vc!, animated:true)
//                let vc = UIStoryboard(name:"MainTest", bundle:nil).instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController
//                //vc.resultsArray = self.resultsArray
//                self.navigationController?.pushViewController(vc!, animated:true)
                
            })
        } else {
            //check if the users validation all .green to go
            guard self.specialCharValidationCheck.textColor == .green, self.alphabetValidationCheck.textColor == .green, self.lengthValidationCheck.textColor == .green else {
                return
            }
            self.database.CreateUserAccount(email, password: password, userName: userName, completionBlock: { (user, error) in
                // after sign in, write user name to db, also sign the user in, Also look into how to keep the users signed in
                // next app prompts
                guard self.specialCharValidationCheck.textColor == .green, self.alphabetValidationCheck.textColor == .green, self.lengthValidationCheck.textColor == .green else {
                    return
                }
                if error != nil {
                    guard let errorM = error?.localizedDescription else {
                        return
                    }
                    self.passwordErrorMessages.text = errorM
                    self.passwordErrorMessages.isHidden = false
                    return
                }
                print("your account is all signed in")
//                let vc = UIStoryboard(name:"MainTest", bundle:nil).instantiateViewController(withIdentifier: "MainTableViewController") as? MainTableViewController
//                //vc.resultsArray = self.resultsArray
//                self.navigationController?.pushViewController(vc!, animated:true)
                let vc = UIStoryboard(name:"ListItemsView", bundle:nil).instantiateViewController(withIdentifier: "listItem") as? ListItemTableViewController
                //vc.resultsArray = self.resultsArray
                self.navigationController?.pushViewController(vc!, animated:true)
            })
        }
    }
    func changeNames() {
        if self.isSignIn {
            signinButton.setTitle("Sign In", for: .normal)
            self.userNameTextField.isHidden = true
            self.ValidationStackView.isHidden = true
            self.emailTFConstraintsToPicker.constant = 15
        } else {
            signinButton.setTitle("Register", for: .normal)
            self.userNameTextField.isHidden = false
            self.ValidationStackView.isHidden = false
            self.emailTFConstraintsToPicker.constant = self.tempConstraints
        }
    }
    
//    func isPasswordValid(_ password : String) -> Bool{
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
//    }
    @IBAction func tempFastLoginAlper(_ sender: Any) {
        self.database.userSignIn("Alper123@alper.com", password: "Alper123!") { (user, error) in
            let vc = UIStoryboard(name:"ListItemsView", bundle:nil).instantiateViewController(withIdentifier: "listItem") as? ListItemTableViewController
            //vc.resultsArray = self.resultsArray
            self.navigationController?.pushViewController(vc!, animated:true)
        }
    }
    
}
