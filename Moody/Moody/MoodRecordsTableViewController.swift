//
//  FirstViewController.swift
//  Moody
//
//  Created by Peyton Gasink on 7/26/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import UIKit
import CoreData

class MoodRecordsTableViewController: UITableViewController {
    
    var moodRecords: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moodRecord = moodRecords[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoodRecordTableViewCell", for: indexPath) as? MoodRecordTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MoodRecordTableViewCell.")
        }
        
        
        let activityID = moodRecord.value(forKeyPath: "activityID") as? Int
        let moodID = moodRecord.value(forKeyPath: "moodID") as? Int
        let date = moodRecord.value(forKeyPath: "date") as? Date
        
        // convert the date from the entity to a string for the label
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: date!)
        
        // Set the label text for the row
        cell.activityLabel!.text = activityTypes[activityID!]
        cell.moodLabel!.text = moodTypes[moodID!]
        cell.dateLabel!.text = dateString
        return cell
    }
    
    //    MARK: Table View Delete Support
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                // Remove the album from core data
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                managedContext.delete(moodRecords[indexPath.row])
                
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            moodRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Core Data Fetch
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
        
        do {
            moodRecords = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //    MARK: Navigation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetCoreDataRecords()
    }
    
    //    MARK: Unwind Segue Handler
    @IBAction func unwindToMoodRecordsList(sender: UIStoryboardSegue) {
        if sender.source is MoodRecordViewController {
            GetCoreDataRecords()
            self.tableView.reloadData()
        }
    }
}

