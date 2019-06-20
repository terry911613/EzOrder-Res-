//
//  CheckADTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/16.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class CheckADTableViewCell: UITableViewCell {
    @IBOutlet weak var ADimageView: UIImageView!
    @IBOutlet weak var adTime: UILabel!
    @IBOutlet weak var adName: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var ColerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adTime.text = "1"
        self.reloadInputViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
