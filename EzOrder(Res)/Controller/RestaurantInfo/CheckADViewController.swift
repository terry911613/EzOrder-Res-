//
//  CheckADViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/6.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class CheckADViewController: UIViewController {

    @IBOutlet weak var checkADTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CheckADViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkADCell", for: indexPath)
        cell.textLabel?.text = "KFC"
        cell.detailTextLabel?.text = "未審核"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CheckADDetailSegue", sender: self)
    }
}
