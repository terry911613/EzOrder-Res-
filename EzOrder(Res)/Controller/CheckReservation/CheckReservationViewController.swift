//
//  CheckReservationViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/5/15.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CheckReservationViewController: UIViewController {
    
    @IBOutlet weak var reservationSegment: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var notifyTableView: UITableView!
   
    let dateFormatter: DateFormatter = DateFormatter()
    var selectDateText = ""
    var eventDic = [String : [[String]]]()
    var now = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 讓app一啟動就是今天的日曆
        calendarView.scrollToDate(now, animateScroll: false)
        // 讓今天被選取
        calendarView.selectDates([now])
        
        //  設定日曆屬性（水平/垂直滑）、滑動方式
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
//        dateLabel.text = "2019-01"
        
        selectDateText = dateFormatter.string(from: now)
        
        //  寫死今天有三項訂位
        eventDic = ["2019-05-15" : [["小明", "2人", "10:00"], ["小明", "5人", "17:00"]],
                    "2019-04-15" : [["小明", "6人", "12:00"], ["小明", "8人", "16:00"]],
                    "2019-03-15" : [["小明", "1人", "12:00"], ["小明", "5人", "15:00"]],
                    "2019-02-15" : [["小明", "7人", "11:00"], ["小明", "10人", "12:00"]],
                    "2019-01-15" : [["小明", "5人", "11:00"], ["小明", "3人", "13:00"]]]
    }
    @IBAction func reservationSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            calendarView.isHidden = false
            notifyTableView.isHidden = true
            calendarView.reloadData()
        }
        else{
            calendarView.isHidden = true
            notifyTableView.isHidden = false
            notifyTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reservationDetailVC = segue.destination as! ReservationDetailViewController
        reservationDetailVC.eventDic = eventDic
        reservationDetailVC.selectDateText = selectDateText
//        reservationDetailVC.reservationDetailTableView.reloadData()
    }
}

extension CheckReservationViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        //  設定dateFormatter格式
        /*
         這邊比viewdidload先執行，所以可以在這邊設定dateFormatter格式
         */
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        //  設定日曆起始日期和最終日期
        let startDate = dateFormatter.date(from: "2019-01-01")!
        let endDate = dateFormatter.date(from: "2030-02-01")!
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid)
        
    }
    
    /*
     cellForItemAt 和 willDisplay 裡面要放的東西幾乎一樣
     除了 cell 在 cellForItemAt 要做重複利用（dequeueReusableJTAppleCell）
     */
    //  每一格cell要呈現的日期
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    //  滑動日曆的話
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        //  讓 navigation 的 title 顯示現在的年跟月
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        if let slideYearMonth = visibleDates.monthDates.first?.date{
            let yearMonth = formatter.string(from: slideYearMonth)
            dateLabel.text = "\(yearMonth)"
        }
    }
    //  選取日期的話
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //  判斷是不是點第二次，如果是點兩次的話跳出細項
        let cell = cell as! DateCell
        if cell.selectedView.isHidden == false{
            performSegue(withIdentifier: "reservationDetailSegue", sender: self)
//            let reservationDetailVC = storyboard?.instantiateViewController(withIdentifier: "reservationDetailVC") as! ReservationDetailViewController
//            reservationDetailVC.eventDic = eventDic
//            reservationDetailVC.selectDateText = selectDateText
//            reservationDetailVC.reservationDetailTableView.reloadData()
//            navigationController?.pushViewController(reservationDetailVC, animated: true)
        }
        
        configureCell(view: cell, cellState: cellState)
        selectDateText = dateFormatter.string(from: date)
        //  讓標籤改成選取到的日期
        dateLabel.text = selectDateText
    }
    //  取消選取的話
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell else{return}
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    //  讓不是這個月的日期變灰色
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
            cell.isHidden = false
        } else {
            cell.dateLabel.textColor = .lightGray
        }
    }
    //  按日期讓日期上有粉色的圓圈
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    //  日期裡有事件的話，在日期下方標示
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let everyCellDayDate = dateFormatter.string(from: cellState.date)
        if eventDic[everyCellDayDate] == nil{
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
    }
    
}

extension CheckReservationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationNotifyCell", for: indexPath) as! ReservationNotifyTableViewCell
        cell.reservationNameLabel.text = "小明"
        cell.reservationPeopleLabel.text = "12"
        cell.timeLabel.text = "2019年10月10號 7點30分"
        return cell
    }
}
