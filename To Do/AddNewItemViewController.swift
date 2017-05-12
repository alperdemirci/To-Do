//
//  AddNewItemViewController.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {

    @IBOutlet weak var todoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let amountOfLinesToBeShown:CGFloat = 6
        let maxHeight:CGFloat = todoTextField.font!.lineHeight * amountOfLinesToBeShown
        todoTextField.sizeThatFits(CGSize(width:todoTextField.frame.size.width, height:maxHeight))

    }

}
