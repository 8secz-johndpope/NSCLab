//
//  tblMsgSendCell.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 10/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit

class tblMsgSendCell: UITableViewCell {
    
    @IBOutlet weak var lblImage: UILabel!
     @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var msgView: UIView!
      
      @IBOutlet weak var lblSentMsg: UILabel!
      
      @IBOutlet weak var lblTime: UILabel!
      

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
