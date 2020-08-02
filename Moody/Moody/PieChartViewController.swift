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

class PieChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var moodRecords: [NSManagedObject] = []
    var moodID: Int = 0
    var moodName: String = ""
    
    // MARK: Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(moodName) Activities"
        GetCoreDataRecords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GetCoreDataRecords()
    }
    
    // MARK: Chart Setup
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry1)
        }
        
        let set = PieChartDataSet(entries: dataEntries, label: "Activities")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        let legend = pieChartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.xEntrySpace = 7
        legend.yEntrySpace = 0
        legend.yOffset = 0
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 2
        pFormatter.multiplier = 100.00
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .bold))
        data.setValueTextColor(.black)
        pieChartView.entryLabelColor = .black
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    // MARK: Core Data
    
    func GetCoreDataRecords() {
        //        Get mood records from core data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoodRecord")
        fetchRequest.predicate = NSPredicate(format: "moodID = %ld", moodID)
        
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
            
            if moodRecords.count > 0 {
                setChart(dataPoints: activityNames, values: percentages)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
