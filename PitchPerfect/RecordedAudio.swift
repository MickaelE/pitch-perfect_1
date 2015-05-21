//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Mickael Eriksson on 2015-05-18.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    let filePathUrl: NSURL!
    let title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl;
        self.title = title;
    }
}