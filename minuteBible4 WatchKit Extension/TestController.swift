//
//  TestController.swift
//  minuteBible4
//
//  Created by Giovanni Saberon on 24/01/19.
//  Copyright © 2019 Giovanni Saberon. All rights reserved.
//

import WatchKit
import Foundation
import SQLite3

class TestController: WKInterfaceController {
    let databaseName = "kjvios2.db"
    let sqliteDatabaseHelper = SQLiteDatabaseHelper()

    var bibleTimer: Timer!
    var books: [String] = []
    var db: OpaquePointer?
    let bibleInfo = BibleInfo()
    let minuteBibleVerse = MinuteBibleVerse()
    let aBook = Book()
    @IBOutlet var bookTitle: WKInterfaceLabel!
    @IBOutlet var timerDisplay: WKInterfaceLabel!
    @IBOutlet var totalVerses: WKInterfaceLabel!
    @IBOutlet var currentID: WKInterfaceLabel!
    @IBOutlet var wordOfGod: WKInterfaceLabel!
    @IBOutlet var bookPicker: WKInterfacePicker!

    @IBOutlet var tableName: WKInterfaceLabel!
    var bookSelection: Int = 1

    @objc func copyDatabase2(){
        self.sqliteDatabaseHelper.databaseName = self.databaseName
        self.sqliteDatabaseHelper.copyDatabase()
    }
    
    @objc func copyDatabase(){
        print("copying database")
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
    
    @objc func openDatabase2(){
        self.sqliteDatabaseHelper.databaseName = self.databaseName
        self.sqliteDatabaseHelper.openDatabase()
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
    
    @objc func getBooks(){
        print("getting books")
        openDatabase()
        
        
        var stmt:OpaquePointer?
        
        let queryString = "select * from BibleInfo"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let bookTitle = String(cString: sqlite3_column_text(stmt, 3))            //let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
            //let name = String(cString: queryResultCol1!)
            //adding values to list
            books.append(bookTitle)
        }
        sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK{
            print("error closing database");
        }
        else{
            print("database close")
            
        }
        
        
        
    }
    
    func loadBookPicker(){
        let pickerItems: [WKPickerItem] = books.map{
            let pickerItem = WKPickerItem()
            pickerItem.title = ($0 )
            return pickerItem
        }
        bookPicker.setItems(pickerItems)
        bookPicker.setSelectedItemIndex(0)
        
    }
    
    
    @IBAction func bookPicker(_ value: Int) {
        bookSelection = value+1
        
        //wordOfGod.setText(String(bookSelection))
        //setVerse(id: bookSelection)
        
        
    }
    
    @objc func setMinuteBibleVerse(tableName: String, currentID: Int) {
        print("getting the verse")
        openDatabase()
        
        var stmt:OpaquePointer?
        
        let queryString = "select * from " + tableName + " where id= " + String(currentID)
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
           self.aBook.id = Int(sqlite3_column_int(stmt, 0))
           self.aBook.bookID = Int(sqlite3_column_int(stmt, 1))
           self.aBook.book = String(cString: sqlite3_column_text(stmt, 2))
           self.aBook.chapter = String(cString: sqlite3_column_text(stmt, 3))
           self.aBook.verse = String(cString: sqlite3_column_text(stmt, 4))
           self.aBook.word = String(cString: sqlite3_column_text(stmt, 5))
           self.aBook.image = "test"
           self.aBook.testament = "test"//String(cString: sqlite3_column_text(stmt, 7))
           self.aBook.shortName = "test" //String(cString: sqlite3_column_text(stmt, 8))
           self.aBook.abbName = "test"
//            chapter = sqlite3_column_int(stmt, 3)
//            let verse = sqlite3_column_int(stmt, 4)
//            let word = String(cString: sqlite3_column_text(stmt, 5))
//            let book = String(cString: sqlite3_column_text(stmt, 8))
            //let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
            //let name = String(cString: queryResultCol1!)
            //adding values to list
      
            
        }
        sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK{
            print("error closing database");
        }
        else{
            print("database close")
            
        }

        
    }

    
 
    
    @objc func setBibleInfo(id: Int){
        print("getting bible info")
        openDatabase()

        var stmt:OpaquePointer?
        
        let queryString = "select * from BibleInfo where bookID = " + String(id)
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
                  self.bibleInfo.bookID = Int(sqlite3_column_int(stmt, 0))
                  self.bibleInfo.fullName = String(cString: sqlite3_column_text(stmt, 1))
                  self.bibleInfo.tableName = String(cString: sqlite3_column_text(stmt, 2))
                  self.bibleInfo.shortName = String(cString: sqlite3_column_text(stmt, 3))
                  self.bibleInfo.totalVerses = Int(sqlite3_column_int(stmt, 4))
                  self.bibleInfo.totalChapters = Int(sqlite3_column_int(stmt, 5))
                  self.bibleInfo.abbName = String(cString: sqlite3_column_text(stmt, 6))
                  self.bibleInfo.testament = String(cString: sqlite3_column_text(stmt, 7))
                  self.bibleInfo.category = String(cString: sqlite3_column_text(stmt, 8))
                  self.bibleInfo.status = String(cString: sqlite3_column_text(stmt, 9))
            //let name = String(cString: queryResultCol1!)
            //adding values to list
            
            
        }
//        let bibleInfo = BibleInfo(bookID: bookID, fullName: fullName, tableName: tableName, shortName: shortName, totalVerses: totalVerses, totalChapters: totalChapters, abbName: abbName, testament: testament, Category: category, Status: status)
        
        sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK{
            print("error closing database");
        }
        else{
            print("database close")
            
        }
        
    }

    func play(){
        let aBibleInfo = getBibleInfo(id: bookSelection)
        let totalVerses = aBibleInfo.totalVerses
        self.minuteBibleVerse.tableName = aBibleInfo.tableName
        self.minuteBibleVerse.id = getCurrentID2(totalVerses: totalVerses)
        setMinuteBibleVerse(tableName: self.minuteBibleVerse.tableName, currentID: self.minuteBibleVerse.id)
        displayVerse(aBook: aBook)
//           bibleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getSeconds), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func tap_to_play(_ sender: Any) {
        play()
    }
    @IBAction func play_button() {
        play()
 
        
    }
    func displayVerse(aBook : Book){
        let reference = aBook
        let book = reference.book
        let chapter = reference.chapter
        let verse = reference.verse
        let word = reference.word
        let referenceNumber = book! + chapter! + ":" + verse!
        bookTitle.setText(books[bookSelection-1] + " " + chapter! + ":" + verse!)
        wordOfGod.setText(word)
    }
    
    func getBibleInfo(id: Int) -> BibleInfo{
        setBibleInfo(id: id)
        return self.bibleInfo
    }
    
   
    func getCurrentID2(totalVerses: Int) -> Int {
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
        
        var currentID = minutes+1 - totalVerses// "1w"
        while currentID > totalVerses {
            currentID = currentID - totalVerses
        }
        return currentID
        
        
        
    }
  
    
    @objc func getSeconds(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        let result = formatter.string(from: date)
        let  secondsLeft = 60 - Int(result)!
        timerDisplay.setText(String(secondsLeft))
//                if result=="00"{
//                    play()
//              }
    }
    var state_display_picker = "on"
    
    @IBOutlet var play_button_display: WKInterfaceButton!
    
    @IBAction func short_tap_show_hide_reference(_ sender: Any) {
        switch state_display_picker {
        case "on":
            bookPicker.setHidden(true)
            play_button_display.setHidden(true)
            timerDisplay.setHidden(false)
            state_display_picker = "off"
        case "off":
            bookPicker.setHidden(false)
            play_button_display.setHidden(false)
            state_display_picker = "on"
            timerDisplay.setHidden(true)
        default:
            bookPicker.setHidden(true)
            play_button_display.setHidden(true)
        }
        
    }
   
    
 
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //copyDatabase()
        getBooks()
        loadBookPicker()
        //setVerse(id: bookSelection)
        totalVerses.setHidden(true)
        tableName.setHidden(true)
        currentID.setHidden(true)
        bookTitle.setHidden(false)
        bibleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getSeconds), userInfo: nil, repeats: true)
        //wordOfGod.setText(getVerse(bookIndex: 2))
      

        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        //setVerse(id: bookSelection)
        if books.isEmpty==false{
        play()
        }
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
