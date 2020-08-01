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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoodRecordTableViewCell", for: indexPath)
        
        
        let activityID = moodRecord.value(forKeyPath: "activityID") as? Int
        let moodID = moodRecord.value(forKeyPath: "moodID") as? Int
        
        // Set the label text for the row
        cell.textLabel!.text = activityTypes[activityID!]
        cell.detailTextLabel!.text = moodTypes[moodID!]
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
    
    //    MARK: Navigation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "AlbumDetailSegue"
//        {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let controller = segue.destination as! AlbumDetailViewController
//                let album = albums[indexPath.row]
//                controller.albumTitle = album.value(forKeyPath: "title") as? String
//                controller.artist = album.value(forKeyPath: "artist") as? String
//                controller.releaseYear = album.value(forKeyPath: "releaseYear") as? Int
//                controller.recordLabel = album.value(forKeyPath: "recordLabel") as? String
//            }
//        }
//    }
    
    //    MARK: Unwind Segue Handler
    @IBAction func unwindToMoodRecordsList(sender: UIStoryboardSegue) {
        if sender.source is MoodRecordViewController {
            //1
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            //2
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "MoodRecord")
            
            //3
            do {
                moodRecords = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            self.tableView.reloadData()
        }
    }
}

