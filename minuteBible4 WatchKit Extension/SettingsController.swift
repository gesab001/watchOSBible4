//
//  SettingsController.swift
//  minuteBible4 WatchKit Extension
//
//  Created by Giovanni Saberon on 14/01/19.
//  Copyright © 2019 Giovanni Saberon. All rights reserved.
//

import WatchKit
import Foundation


class SettingsController: WKInterfaceController {

    @IBOutlet var verse_display: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        if let bibleVerse = context as? Bible{
//            let book = String(bibleVerse.bookNumber)
//            let chapter = String(bibleVerse.chapterNumber)
//            let verse = String(bibleVerse.verseNumber)
//            verse_display.setText(book + " " + chapter + " " + verse)
//        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
