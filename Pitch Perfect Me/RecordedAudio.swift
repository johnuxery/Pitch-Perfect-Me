//
//  RecordedAudio.swift
//  Pitch Perfect Me
//
//  Created by John Stefanik on 3/15/15.
//  Copyright (c) 2015 John Stefanik. All rights reserved.
//

import Foundation

// Create model object for passing data
class RecordedAudio: NSObject{
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
