//
//  NavigationViewController.swift
//  To Do
//
//  Created by alper on 5/16/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit
import Firebase
//import ZoomTransitioning

class NavigationViewController: UINavigationController {

    let database = Database()
//    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        delegate = zoomNavigationControllerDelegate
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let initialViewController = InitialViewController()
        present(initialViewController, animated: true, completion: nil)
    }
}
