//
//  NV+Extensions.swift
//  msg
//
//  Created by Nathaniel Blumer on 2016-09-02.
//  Copyright © 2016 Wherecloud Inc. All rights reserved.
//

import Foundation

enum MSGUserDefaults: String {
    case DidShowTutorial = "didShowTutorial"
    case LastValidUsername = "lastValidUsername"
    
    ///MARK:- MSG
    ///The language of all the text in the App. See MSGLanguage
    case AppLanguage = "appLanguage"
    
    ///The language of all the audio in the App. See MSGLanguage
    case AudioLanguage = "audioLanguage"
    
    ///0: Automatic, 1: Manual
    case AudioMode = "audioMode"
}

extension NSAttributedString {
    
    static func + (string1: NSAttributedString, string2: NSAttributedString) -> NSAttributedString {
        
        let string = NSMutableAttributedString(attributedString: string1)
        string.append(string2)
        
        return string
    }
}
