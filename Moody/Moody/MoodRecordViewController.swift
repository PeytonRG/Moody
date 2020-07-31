//
//  MoodRecordViewController.swift
//  Moody
//
//  Created by Peyton Gasink on 7/30/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import UIKit
import CoreData
import os.log

class MoodRecordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var selectedMood: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func angryButtonPressed(_ sender: Any) {
        selectedMood = 1
    }
    @IBAction func sadButtonPressed(_ sender: Any) {
        selectedMood = 2
    }
    @IBAction func happyButtonPressed(_ sender: Any) {
        selectedMood = 3
    }
    @IBAction func excitedButtonPressed(_ sender: Any) {
        selectedMood = 4
    }
    
    // MARK: PickerView Setup
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return activityTypes[row] }
    
    // MARK: Save to Core Data
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let row = pickerView.selectedRow(inComponent: 0)
        
        if row > 0 && selectedMood > 0 {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            // create a new entity and album object
            let entity =
                NSEntityDescription.entity(forEntityName: "MoodRecord",
                                           in: managedContext)!
            
            let moodRecord = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
            
            //            set the attributes on that object
            moodRecord.setValue(0, forKeyPath: "moodRecordID")
            moodRecord.setValue(row, forKeyPath: "activityID")
            moodRecord.setValue(selectedMood, forKeyPath: "moodID")
            moodRecord.setValue(Date(), forKeyPath: "date")
            
            //        save the album
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            performSegue(withIdentifier: "unwindToMoodRecordTableViewSegue", sender: self)
        }
        else {
            let alert = UIAlertController( title: "Error", message: "You must select an emotion and an activity to save.", preferredStyle: .alert)
            let action = UIAlertAction( title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
