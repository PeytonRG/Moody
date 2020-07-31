//
//  MoodRecord.swift
//  Moody
//
//  Created by Peyton Gasink on 7/29/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import Foundation

enum moods: Int {
    case Angry, Sad, Happy
}

enum activities: Int {
    case Sports, Gaming, Outdoor, Workout, Swimming, Walking, Running, Biking
}

struct moodRecord {
    var moodType: moods
    var activityType: activities
    var recordDate: Date
}
