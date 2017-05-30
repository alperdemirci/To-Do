//
//  ListItemTableViewCell.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var sharedLabelContsraint: NSLayoutConstraint!
    @IBOutlet weak var todoLabel: UILabel!

    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var uiimage: UIImageView!
    
    weak var delegate: ButtonDelegate?
    
    @IBOutlet weak var uimageConstraint: NSLayoutConstraint!
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var mapViewheightConstraints: MKMapView!
    @IBOutlet weak var sharedEmailChange: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sharedButtonPressed(_ sender: Any) {
        self.delegate?.sharedButtonPressed(sender as! UIButton, tableViewCell: self)
    }
//    @IBAction func doneEditButtonChanged(_ sender: Any) {
//        self.delegate?.doneEditButtonChanged(sender as! UIButton, tableViewCell: self)
//    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.delegate?.doneButtonPressed(sender as! UIButton, tableViewCell: self)
    
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.delegate?.editButtonPressed(sender as! UIButton, tableViewCell: self)
    
    }
}

protocol ButtonDelegate: class {
    func sharedButtonPressed(_ userAccept: UIButton, tableViewCell: ListItemTableViewCell)
    func doneButtonPressed(_ userAccept: UIButton, tableViewCell: ListItemTableViewCell)
    func editButtonPressed(_ userAccept: UIButton, tableViewCell: ListItemTableViewCell)
    
}
