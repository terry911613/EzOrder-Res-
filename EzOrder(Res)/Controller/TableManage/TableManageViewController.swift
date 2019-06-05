//
//  TableManageViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class TableManageViewController: UIViewController {

    @IBOutlet weak var tableStatusTableView: UITableView!
    
    var table = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension TableManageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableStatusCell", for: indexPath) as! TableManageTableViewCell
        
        return cell
    }
    
    
    
}
