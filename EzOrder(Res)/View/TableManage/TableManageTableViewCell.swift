//
//  TableManageTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class TableManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var serviceBellImageView: UIImageView!
    @IBOutlet weak var foodCompleteImageView: UIImageView!
    @IBOutlet weak var payImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
