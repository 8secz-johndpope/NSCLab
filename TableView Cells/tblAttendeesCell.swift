//
//  tblAttendeesCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 11/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblAttendeesCell: UITableViewCell {
    
    
    
    
    
    @IBOutlet weak var lblUserName: UILabel!
      
      @IBOutlet weak var ViewImg: UIView!
      
       @IBOutlet weak var lblUserMsg: UILabel!
       @IBOutlet weak var lblNameImg: UILabel!
       @IBOutlet weak var imgUser: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
