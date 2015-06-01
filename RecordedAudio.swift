//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Pete Castillo on 5/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation


class RecordedAudio:NSObject {
    var filePathUrl: NSURL!
    var title: String!

    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}
