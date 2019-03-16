//
//  MinuteController.swift
//  minuteBible4 WatchKit Extension
//
//  Created by Giovanni Saberon on 20/01/19.
//  Copyright © 2019 Giovanni Saberon. All rights reserved.
//

import WatchKit
import Foundation
import SQLite3

class MinuteController: WKInterfaceController {
    let databaseName = "kjvios2.db"
    var db: OpaquePointer?
    let sqliteDatabaseHelper = SQLiteDatabaseHelper()

    @IBOutlet var timerLabel: WKInterfaceLabel!
    

    var wordofgod = ""

    
    @IBOutlet var wordLabel: WKInterfaceLabel!
    
    @objc func copyDatabase2(){
        self.sqliteDatabaseHelper.databaseName = self.databaseName
        self.sqliteDatabaseHelper.copyDatabase()
    }
    
    @objc func openDatabase2(){
        self.sqliteDatabaseHelper.databaseName = self.databaseName
        self.sqliteDatabaseHelper.db = self.db
        self.sqliteDatabaseHelper.openDatabase()
    }
    
    func getCurrentID() -> Int {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfMonth,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
        
        let date1 = DateComponents(calendar: .current, year: 2018, month: 06, day: 23, hour: 14, minute: 45).date!
        let date2 = Date()
        
        let years = date2.years(from: date1)     // 0
        let months = date2.months(from: date1)   // 9
        let weeks = date2.weeks(from: date1)     // 39
        let days = date2.days(from: date1)       // 273
        let hours = date2.hours(from: date1)     // 6,553
        let minutes = date2.minutes(from: date1) // 393,180
        let seconds = date2.seconds(from: date1) // 23,590,800
        
        let timeOffset = date2.offset(from: date1) // "9M"
        
        let date3 = DateComponents(calendar: .current, year: 2014, month: 11, day: 28, hour: 5, minute: 9).date!
        let date4 = DateComponents(calendar: .current, year: 2015, month: 11, day: 28, hour: 5, minute: 9).date!
        
        let timeOffset2 = date4.offset(from: date3) // "1y"
        
        let date5 = DateComponents(calendar: .current, year: 2017, month: 4, day: 28).date!
        let now = Date()
        let timeOffset3 = now.offset(from: date5)
        
        var currentID = minutes+1 - 31102// "1w"
        while currentID > 31102 {
            currentID = currentID - 31102
        }
        return currentID
        
        
        
    }
    
    func readVerse(){
        openDatabase()
        let id = getCurrentID()
   
        var stmt:OpaquePointer?
        
        let queryString = "select * from kjv where id=" + String(id)
        
        //                //preparing the query
        //                if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
        //                    let errmsg = String(cString: sqlite3_errmsg(db)!)
        //                    print("error preparing insert: \(errmsg)")
        //                    return
        //                }
        //
        //                //binding the parameters
        //                if sqlite3_bind_int(stmt, 1, (book! as NSString).intValue) != SQLITE_OK{
        //                    let errmsg = String(cString: sqlite3_errmsg(db)!)
        //                    print("failure binding chapter: \(errmsg)")
        //                    return
        //                }
        //
        //                if sqlite3_bind_int(stmt, 2, (chapter! as NSString).intValue) != SQLITE_OK{
        //                    let errmsg = String(cString: sqlite3_errmsg(db)!)
        //                    print("failure binding chapter: \(errmsg)")
        //                    return
        //                }
        //
        //                if sqlite3_bind_int(stmt, 3, (verse! as NSString).intValue) != SQLITE_OK{
        //                    let errmsg = String(cString: sqlite3_errmsg(db)!)
        //                    print("failure binding verse: \(errmsg)")
        //                    return
        //                }
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){             let id = sqlite3_column_int(stmt, 0)
            let book = String(cString: sqlite3_column_text(stmt, 8))
            let chapter = sqlite3_column_int(stmt, 2)
            let verse = sqlite3_column_int(stmt, 3)
            //let word = sqlite3_column_int(stmt, 4)
            let word = String(cString: sqlite3_column_text(stmt, 4))            //let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
            //let name = String(cString: queryResultCol1!)
            //adding values to list
            wordLabel.setText(word + " \n(" + book + " " + String(chapter) + ":" + String(verse) + ")")
            wordofgod = word + " \n(" + book + " " + String(chapter) + ":" + String(verse) + ")"
            setFontSize()
            
        }
        sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK{
            print("error closing database");
        }
        else{
            print("database close")
            
        }
        
    }
    var bibleTimer: Timer!

    
    @objc func getSeconds(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        let result = formatter.string(from: date)
        var secondsLeft = 60 - Int(result)!
        timerLabel.setText(String(secondsLeft))
        if result=="00"{
            readVerse()
        }
    }
    
    @objc func copyDatabase(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("kjvios2.db") {
            let filePath = pathComponent.path
            let fileManager:FileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                do {
                    try fileManager.removeItem(atPath: filePath)
                } catch let error as NSError{
                    print (error.debugDescription)
                }
            }
                
                print("FILE NOT AVAILABLE")
                let filemanager:FileManager = FileManager.default
                let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                let dbPath = doumentDirectoryPath.appendingPathComponent("kjvios2.db")
                let path = Bundle.main.path(forResource: "kjvios2", ofType: "db")
                do{
                    try filemanager.copyItem(atPath: path!, toPath: dbPath)
                }catch let error as NSError {
                    print("error occurred, here are the details:\n \(error)")
                }
            
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
   
        
    }
    
    var fontSize = 11
    
    @IBAction func reduceFontSize() {
        fontSize = fontSize - 1
        setFontSize()
    }
    
    @IBAction func increaseFontSize() {
        fontSize = fontSize + 1
        setFontSize()
    }
    
    @objc func setFontSize(){
        let font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFont.Weight.medium)
        let attrStr = NSAttributedString(string: wordofgod, attributes: [NSAttributedString.Key.font: font])
        wordLabel.setAttributedText(attrStr)
   
    }
    
    @objc func openDatabase(){
        //        //create database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("kjvios2.db")
        
        //opening the database
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else{
            print("database is open")
        }
        
        
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        

        copyDatabase()

        
        
        bibleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getSeconds), userInfo: nil, repeats: true)
        readVerse()

        // Do any additional setup after loading the view, typically from a nib.l
        //        let path = Bundle.main.path(forResource: "kjv", ofType: "db")
        //        do{
        //            try fileManger.copyItem(atPath: path!, toPath: dbPath)
        //        }catch let error as NSError {
        //            print("error occurred, here are the details:\n \(error)")
        //        }
//        //

        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        readVerse()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
