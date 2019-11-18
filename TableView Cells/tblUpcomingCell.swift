//
//  tblUpcomingCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 16/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblUpcomingCell: UITableViewCell {

    
    
    @IBOutlet weak var imgCon: UIImageView!
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    

    
    @IBOutlet weak var lblCalenderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
