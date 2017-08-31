//
//  ListItemTableViewCell.swift
//  To Do
//
//  Created by alper on 5/11/17.
//  Copyright © 2017 alper. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {

    weak var delegate: ButtonDelegate?
    
    @IBOutlet weak var sharedLabelContsraint: NSLayoutConstraint!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var sharedWith: UILabel!
    @IBOutlet weak var sharedWithLabel: UILabel!
    @IBOutlet weak var uiimage: UIImageView!
    @IBOutlet weak var uimageConstraint: NSLayoutConstraint!
    @IBOutlet weak var sharedEmailChange: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ButtonPressed(_ sender: Any) {
        self.delegate?.ButtonPressed(sender as! UIButton, tableViewCell: self)
    }

}

protocol ButtonDelegate: class {
    func ButtonPressed(_ userAccept: UIButton, tableViewCell: ListItemTableViewCell)
}
