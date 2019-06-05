//
//  ReservationDetailTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class ReservationDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var reservationNameLabel: UILabel!
    @IBOutlet weak var reservationPeopleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
