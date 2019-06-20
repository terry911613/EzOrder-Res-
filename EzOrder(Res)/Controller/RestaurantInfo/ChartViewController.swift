//
//  ChartViewController.swift
//  EzOrder(Res)
//
//  Created by 李泰儀 on 2019/6/20.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var typeDocumentIDArray = [String]()
    var foodAmountDic = [String: Int]()
    var values = [PieChartDataEntry]()
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    var selectDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "yyyy年M月d日"
        getDatePicker()
        selectDate = formatter.string(from: Date())
        if let selectDate = selectDate{
            getFoodAmount(date: selectDate)
            dateLabel.text = selectDate
        }
        navigationItem.title = "統計"
    }
    func getDatePicker(){
        //  顯示 datePicker 方式和大小
        datePicker.locale = Locale(identifier: "zh_TW")
        formatter.dateStyle = .medium
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
    }
    
    func getFoodAmount(date: String){
        
        foodAmountDic.removeAll()
        values.removeAll()
        pieChartView.isHidden = true
        
        let db = Firestore.firestore()
        if let resID = Auth.auth().currentUser?.email{
            
            db.collection("res").document(resID).collection("foodType").getDocuments { (type, error) in
                if let type = type{
                    if type.documents.isEmpty == false{
                        for type in type.documents{
                            if let typeDocumentID = type.data()["typeDocumentID"] as? String{
                                self.typeDocumentIDArray.append(typeDocumentID)
                                db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").getDocuments(completion: { (food, error) in
                                    
                                    if let food = food{
                                        if food.documents.isEmpty == false{
                                            for food in food.documents{
                                                if let foodDocumentID = food.data()["foodDocumentID"] as? String{
                                                    db.collection("res").document(resID).collection("foodType").document(typeDocumentID).collection("menu").document(foodDocumentID).collection("foodAmount").document(date).getDocument(completion: { (foodAmount, error) in
                                                        
                                                        if let foodAmountData = foodAmount?.data(){
                                                            if let foodAmount = foodAmountData["foodAmount"] as? Int,
                                                                let foodName = foodAmountData["foodName"] as? String{
                                                                self.foodAmountDic[foodName] = foodAmount
                                                                self.getChart(food: foodName, value: foodAmount)
                                                            }
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getChart(food: String, value: Int){
        
        pieChartView.isHidden = false
        
        let foodEntry = PieChartDataEntry(value: Double(value), label: food)
        values.append(foodEntry)
        
        let dataSet = PieChartDataSet(entries: values, label: "食物（點餐次數）")
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        //        pieChartView.chartDescription?.text = "Share of Widgets by Type"
        // Color
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [.black]
        pieChartView.backgroundColor = .white
        pieChartView.holeColor = .clear
        pieChartView.chartDescription?.textColor = .black
        pieChartView.legend.textColor = .black
        
        // Text
        pieChartView.legend.font = UIFont(name: "Futura", size: 10)!
        pieChartView.chartDescription?.font = UIFont(name: "Futura", size: 12)!
        pieChartView.chartDescription?.xOffset = pieChartView.frame.width
        pieChartView.chartDescription?.yOffset = pieChartView.frame.height * (2/3)
        pieChartView.chartDescription?.textAlign = NSTextAlignment.left
        
        // Refresh chart with new data
        pieChartView.notifyDataSetChanged()
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            
            self.selectDate = self.formatter.string(from: self.datePicker.date)
            if let selectDate = self.selectDate{
                self.getFoodAmount(date: selectDate)
                self.dateLabel.text = self.selectDate
            }
            print(self.datePicker.date)
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        self.present(dateAlert, animated: true, completion: nil)
    }
    
}
