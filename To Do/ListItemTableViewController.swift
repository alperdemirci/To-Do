//
//  ViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class ListItemTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    var todoListsArray = ["I will go to work", " I have to read this book", "Next week I have a dentist appointment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.todoListsArray.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemListCell") as? ListItemTableViewCell ?? ListItemTableViewCell(style: .default, reuseIdentifier: "itemListCell")
        //UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "itemListCell")
        return cell
    }
    

    @IBAction func addViewControllerCalled(_ sender: Any) {
        let vc = UIStoryboard(name:"AddNewItem", bundle:nil).instantiateViewController(withIdentifier: "addNewView") as? AddNewItemViewController
        //vc.resultsArray = self.resultsArray
        self.navigationController?.pushViewController(vc!, animated:true)
    }

}

