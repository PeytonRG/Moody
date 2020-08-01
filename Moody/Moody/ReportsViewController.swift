//
//  SecondViewController.swift
//  Moody
//
//  Created by Peyton Gasink on 7/26/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import UIKit
import CoreData
import Charts

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var moodRecords: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        GetCoreDataRecords()
        //        setChart(dataPoints: Array(activityTypes.values), values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry1)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Activities")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
    
    func GetCoreDataRecords() {
        //        Get mood records from core data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MoodRecord")
        //        fetchRequest.predicate = NSPredicate(format: "moodID = %ld", 5)
        
        do {
            moodRecords = try managedContext.fetch(fetchRequest)
            var values: [Int] = []
            for record in moodRecords {
                let activityID = record.value(forKeyPath: "activityID") as? Int
                values.append(activityID!)
            }
            
            let mappedItems = values.map { ($0, 1) }
            let dict = Dictionary(mappedItems, uniquingKeysWith: +)
            var activityNames: [String] = []
            var percentages: [Double] = []
            
            for pair in dict {
                let activityCount = pair.value
                let fraction = Double(activityCount) / Double(values.count)
                percentages.append(fraction)
                let activityName = activityTypes[pair.key]!
                activityNames.append(activityName)
            }
            
            setChart(dataPoints: activityNames, values: percentages)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
