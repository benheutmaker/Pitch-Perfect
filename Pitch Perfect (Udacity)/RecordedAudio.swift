//
//  RecordedAudio.swift
//  Pitch Perfect (Udacity)
//
//  Created by Benji on 3/15/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var title: String!
    var filePath: NSURL!
    
    init(title: String, filePath: NSURL) {
        self.title = title
        self.filePath = filePath
    }
}