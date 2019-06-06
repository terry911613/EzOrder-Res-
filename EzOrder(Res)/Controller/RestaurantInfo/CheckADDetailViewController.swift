//
//  CheckADDetailViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class CheckADDetailViewController: UIViewController {

    @IBOutlet weak var ADImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
