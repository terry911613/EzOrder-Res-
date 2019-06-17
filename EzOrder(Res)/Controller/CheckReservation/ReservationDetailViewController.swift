//
//  ReservationDetailViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase

class ReservationDetailViewController: UIViewController {

    @IBOutlet weak var reservationDetailTableView: UITableView!
    
    var selectDateText = ""
    var bookingArray = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ReservationDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationDetailCell", for: indexPath) as! ReservationDetailTableViewCell
        
        let booking = bookingArray[indexPath.row]
        if let userID = booking.data()["userID"] as? String,
            let period = booking.data()["period"] as? String,
            let people = booking.data()["people"] as? String{
            
            cell.reservationNameLabel.text = userID
            cell.reservationPeopleLabel.text = "\(people)人"
            cell.timeLabel.text = period
        }
        return cell
    }
}
