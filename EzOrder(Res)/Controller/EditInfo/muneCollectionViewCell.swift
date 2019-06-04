//
//  muneCollectionViewCell.swift
//  EzOrder(Res)
//
//  Created by 劉十六 on 2019/6/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//
import UIKit

class muneCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var muneFoodImageView: UIImageView!
    @IBOutlet weak var muneFoodName: UILabel!
    @IBOutlet weak var muneFoodMoney: UILabel!
    @IBOutlet weak var statusSwich: UISwitch!
    
    @IBOutlet weak var editNameText: UITextField!
    
    @IBOutlet weak var editMoney: UITextField!
    
    @IBOutlet weak var muneView: UIView!
    @IBOutlet weak var nuberLabel: UILabel!
    @IBAction func statusAction(_ sender:
        UISwitch) {
        if sender.isOn {
            muneView.alpha = 1
                }
        else {
            muneView.alpha = 0.4
        muneFoodName.text = ""
                    }
   
    
    }
    
}
