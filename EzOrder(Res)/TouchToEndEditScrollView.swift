//
//  TouchToEndEditScrollView.swift
//  EzOrder(Res)
//
//  Created by Lee Chien Kuan on 2019/6/20.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import Foundation
import UIKit
class TouchToEndEditScrollView: UIScrollView {
    weak var parentVC: UIViewController?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentVC?.view.endEditing(true)
    }
}
