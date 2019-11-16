//
//  tblProgramCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 09/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblProgramCell: UITableViewCell {

    
    
   
    @IBOutlet weak var lblTime: UILabel!
    
       @IBOutlet weak var lblTittle: UILabel!
       
       
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
