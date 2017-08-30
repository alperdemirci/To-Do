//
//  ViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit
import Firebase

class ListItemTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ButtonDelegate {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    var isbuttonPressed: Bool = false
    var didselect: Int!
    var contentHeights : [CGFloat] = [0.0, 0.0]
    var addNewItemView = AddNewItemViewController()
    
    //MARK:
    let database = FirebaseDataAdapter()
    var addNavBarButton: UIButton!
    var todoListsArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBar()
        self.fetchTodoList()
        
        
        //        self.uiimageHeightContstraint.constant = 0
        
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                // User is Logged in.
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    // MARK: Nav Bar
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "back")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addNewTodo))
        navItem.rightBarButtonItem = doneItem
        self.navigationItem.setRightBarButton(doneItem, animated: true)
    }
    
    
    // MARK: Table View
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoListsArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemListCell") as? ListItemTableViewCell ?? ListItemTableViewCell(style: .default, reuseIdentifier: "itemListCell")
        //UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "itemListCell")
        let user = self.todoListsArray[indexPath.row]
        cell.todoLabel.text = user.value
        DispatchQueue.main.async {
            self.database.retriveScreenshotOfMapview(uuid: user.uniqueID) { (image) in
                cell.uiimage.image = image
            }
        }
        if user.sharedEmail != nil {
            cell.sharedButton.setTitle(user.sharedEmail!,for: .normal)
            cell.sharedButton.isHidden = false
            cell.sharedButton.isEnabled = true
        }
        cell.delegate = self
        return cell
    }
    
    func fetchTodoList() {
        self.database.getTodoList() { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.setValuesForKeys(dict)
                self.todoListsArray.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.didselect != nil && indexPath.row == self.didselect {
            contentHeights = [250.0]
            return 250
        } else {
            contentHeights = [65.0]
            return 65
        }
    }
    
    
    //MARK: Button action
    func ButtonPressed(_ userAccept: UIButton, tableViewCell: ListItemTableViewCell) {
        guard let buttonName = userAccept.titleLabel?.text else {
            return
        }
        switch buttonName {
        case  "Edit":
            let vc = UIStoryboard(name:"AddNewItem", bundle:nil).instantiateViewController(withIdentifier: "addNewView") as? AddNewItemViewController
            self.addNewItemView.callingViewController(.dataEdit)
            self.navigationController?.pushViewController(vc!, animated:true)
        case "I am done":
            //TODO: DB call to save the new data back to DB
            break
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselect", indexPath.row)
        if self.didselect == nil || self.didselect != indexPath.row {
            self.didselect = indexPath.row
        } else {
            self.didselect = nil
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addNewTodo() {
        let vc = UIStoryboard(name:"AddNewItem", bundle:nil).instantiateViewController(withIdentifier: "addNewView") as? AddNewItemViewController
        self.addNewItemView.callingViewController(.dataNew)
        self.navigationController?.pushViewController(vc!, animated:true)
        
    }
}



