//
//  AnalyticsTableViewController.swift
//  Moody
//
//  Created by Peyton Gasink on 8/2/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import UIKit

class AnalyticsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mood = moodTypes[indexPath.row + 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsTableViewCell", for: indexPath)
        
        // Set the label text for the row
        cell.textLabel!.text = mood
        return cell
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MoodGraphSegue"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! PieChartViewController

                controller.moodID = indexPath.row + 1
                controller.moodName = moodTypes[indexPath.row + 1]!
            }
        }
    }
}
