//
//  tblMessageCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblMessageCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var ViewImg: UIView!
    
     @IBOutlet weak var lblUserMsg: UILabel!
     @IBOutlet weak var lblNameImg: UILabel!
     @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTime : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
