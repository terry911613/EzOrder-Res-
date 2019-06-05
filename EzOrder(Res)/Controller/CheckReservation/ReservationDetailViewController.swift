//
//  ReservationDetailViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class ReservationDetailViewController: UIViewController {

    @IBOutlet weak var reservationDetailTableView: UITableView!
    
    var eventDic = [String : [[String]]]()
    var selectDateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reservationDetailTableView.reloadData()
    }
}

extension ReservationDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventArray = eventDic[selectDateText]{
            return eventArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationDetailCell", for: indexPath) as! ReservationDetailTableViewCell
        if let eventArray = eventDic[selectDateText]{
            if eventArray.isEmpty == false{
                cell.reservationNameLabel.text = eventArray[indexPath.row][0]
                cell.reservationPeopleLabel.text = eventArray[indexPath.row][1]
                cell.timeLabel.text = eventArray[indexPath.row][2]
                
                return cell
            }
        }
        return cell
    }
}
