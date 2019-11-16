//
//  tblProgramPeopleCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblProgramPeopleCell: UITableViewCell {

    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var lblAddress: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
