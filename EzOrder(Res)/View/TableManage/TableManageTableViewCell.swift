//
//  TableManageTableViewCell.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class TableManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableNoLabel: UILabel!
    @IBOutlet weak var serviceBellButton: UIButton!
    @IBOutlet weak var orderCompleteButton: UIButton!
    @IBOutlet weak var payImageView: UIImageView!
    
    var callBackService: ((_ clickService: Bool)->())?
    var callBackOrderComplete: ((_ clickFoodComplete: Bool)->())?
    var isSeviceOn = false
    var isOrderComplete = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isSeviceOn == false{
            serviceBellButton.setImage(UIImage(named: "服務鈴"), for: .normal)
        }
        if isOrderComplete == false{
            orderCompleteButton.setImage(UIImage(named: "餐點完成"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func serviceBellButton(_ sender: UIButton) {
        isSeviceOn = !isSeviceOn
        callBackService?(isSeviceOn)
    }
    @IBAction func orderCompleteButton(_ sender: UIButton) {
        isOrderComplete = !isOrderComplete
        callBackService?(isOrderComplete)
    }
}
