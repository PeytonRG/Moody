//
//  Mood.swift
//  Moody
//
//  Created by Peyton Gasink on 7/29/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import Foundation

struct mood {
    var moodID: Int
    var moodName: String
}

struct activity {
    var activityID: Int
    var activityName: String
}

struct record {
    var moodID: Int
    var activityID: Int
    var recordDate: Date
}
