//
//  InitialViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tempButtonForSegue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tempButtonCallListItem(_ sender: Any) {
        let vc = UIStoryboard(name:"ListItemsView", bundle:nil).instantiateViewController(withIdentifier: "listItem") as? ListItemTableViewController
        //vc.resultsArray = self.resultsArray
        self.navigationController?.pushViewController(vc!, animated:true)
    }

}
