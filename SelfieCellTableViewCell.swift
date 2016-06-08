//
//  SelfieCellTableViewCell.swift
//  Selfiegram
//
//  Created by Alyssa Gauk on 2016-06-02.
//  Copyright © 2016 Alyssa Gauk. All rights reserved.
//

import UIKit

class SelfieCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    

    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
