//
//  InterfaceController.swift
//  minuteBible3 WatchKit Extension
//
//  Created by Giovanni Saberon on 4/08/18.
//  Copyright © 2018 Giovanni Saberon. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var verseDisplay: WKInterfaceLabel!
    @IBOutlet var referenceDisplay: WKInterfaceLabel!
    @IBOutlet var bookPicker: WKInterfacePicker!
    @IBOutlet var chapterPicker: WKInterfacePicker!
    @IBOutlet var versePicker: WKInterfacePicker!
    @IBOutlet var currentTime: WKInterfaceDate!
    @IBOutlet var pickerGroup: WKInterfaceGroup!
    
    
//    @IBAction func fullScreen() {
//        let bibleVerse = Bible(book: 1, chapter: 1, verse: 1)
//        pushController(withName: "FullScreen", context: bibleVerse)
//    }
    @IBOutlet var timerLabel: WKInterfaceTimer!
    var seconds = 60
    var bookNumber = 1
    var chapterNumber = 1
    var verseNumber = 0
    var verses:[String] = []
    var fileName = "01_Genesis"
    var totalBooks = 1
    var bookList: [String] = []
    var bookIndex: [String] = []
    var chapterList: [String] = []
    var verseList: [String] = []
    var bookName = ""
    var totalChapters = 1
    var versesOfCurrentChapter: [String] = []
    var totalVerses = 1
    var bibleTimer: Timer!

    
  
    @IBAction func bookSelection(_ value: Int) {
        fileName = bookList[value]
        bookNumber = value
        chapterNumber = 1
        verseNumber = 0
        chapterList.removeAll()
        verseList.removeAll()
        getBook()
        getTotalChapters()
        loadChapterPicker()
        let bookNameSplit = fileName.components(separatedBy: "_")
        var bookName1 = bookNameSplit[1].split(separator: ".")
        bookName = String(bookName1[0])
        nextVerse()
    }
    
    @objc func runTimer(){
        
    }
    @IBAction func chapterSelection(_ value: Int) {
        chapterNumber = value+1
        verseNumber = 0
        verseList.removeAll()
        getVersesOfCurrentChapter()
        nextVerse()
    }
    
    @IBAction func verseSelection(_ value: Int) {
        verseNumber = value
        nextVerse()
    }
    
    func loadBookPicker(){
        for value in 1...totalBooks{
            bookIndex.append(String(value))
        }
        let pickerItems: [WKPickerItem] = bookIndex.map{
            let pickerItem = WKPickerItem()
            pickerItem.title = $0
            return pickerItem
        }
        bookPicker.setItems(pickerItems)
        bookPicker.setSelectedItemIndex(0)
        fileName = bookList[0]
        verseNumber = 1
        chapterList.removeAll()
        verseList.removeAll()
        getBook()
        getTotalChapters()
        loadChapterPicker()
        let bookNameSplit = fileName.components(separatedBy: "_")
        var bookName1 = bookNameSplit[1].split(separator: ".")
        bookName = String(bookName1[0])
        nextVerse()
    }
    func loadChapterPicker(){
        for value in 1...totalChapters{
            chapterList.append(String(value))
        }
        let pickerItems: [WKPickerItem] = chapterList.map{
            let pickerItem = WKPickerItem()
            pickerItem.title = $0
            return pickerItem
        }
        chapterPicker.setItems(pickerItems)
        chapterPicker.setSelectedItemIndex(0)
        
    }
    
    func loadVersePicker(){
        for value in 1...totalVerses{
            verseList.append(String(value))
        }
        let pickerItems: [WKPickerItem] = verseList.map{
            let pickerItem = WKPickerItem()
            pickerItem.title = $0
            return pickerItem
        }
        versePicker.setItems(pickerItems)
        versePicker.setSelectedItemIndex(0)
    }
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func getBooks(){
        let mainBundle = Bundle.main
        let paths = mainBundle.paths(forResourcesOfType: "txt", inDirectory: "biblefiles")
        for file in paths{
            var nameSplit = file.components(separatedBy: "/")
            let name = nameSplit[nameSplit.count-1]
            bookList.append(name)
        }
        bookList.sort()
        totalBooks = bookList.count
        //verseDisplay.setText(bookList.joined(separator: "\n"))
    }
    
    func getBibleReferences(){
        let mainBundle = Bundle.main
        let paths = mainBundle.paths(forResourcesOfType: "txt", inDirectory: "biblefiles")
        for file in paths{
            var nameSplit = file.components(separatedBy: "/")
            let name = nameSplit[nameSplit.count-1]
            bookList.append(name)
        }
        bookList.sort()
        totalBooks = bookList.count
        //verseDisplay.setText(bookList.joined(separator: "\n"))
    }
    func getBook(){
        var fileNameSplit = fileName.components(separatedBy: ".")
        let file = fileNameSplit[0]
        let  path = "biblefiles/" + file
        var data = ""
        if let path = Bundle.main.path(forResource: path, ofType: "txt") {
            do {
                data = try String(contentsOfFile: path, encoding: .utf8)
            }catch {
                let errorMessage = "does not exist"
                verseDisplay.setText(errorMessage)
            }
        }
        //let bookNameSplit = fileName.components(separatedBy: "_")
        //var bookName1 = bookNameSplit[1].split(separator: ".")
        //let bookName = bookName1[0]
        data = data.replacingOccurrences(of: "\n", with: " ");
        verses  = data.components(separatedBy: "{")
    }
    
    func getTotalChapters(){
        let totalVerses = verses.count
        let lastVerse = verses[totalVerses-1]
        var lastVerseSplit = lastVerse.components(separatedBy: ":")
        let chapters  = lastVerseSplit[0]
        totalChapters    = Int(chapters)!
        getVersesOfCurrentChapter()
        
        
    }
    
    func getVersesOfCurrentChapter(){
        versesOfCurrentChapter = []
        for verse in 0...verses.count-1{
            if verses[verse].hasPrefix(String(chapterNumber)+":")==true{
                versesOfCurrentChapter.append(verses[verse])
            }
        }
        totalVerses = versesOfCurrentChapter.count
        loadVersePicker()
    }
    func nextVerse() {

        //let bookText = getBook()
        //let bookNameSplit = fileName.components(separatedBy: "_")
        //var bookName1 = bookNameSplit[1].split(separator: ".")
        //let bookName = bookName1[0]
        //let verse = bookText.components(separatedBy: "{")
        //let selectedVerse = String(verse[verseNumber].filter { !"\n".contains($0)}) removing \n
            let selectedVerse = versesOfCurrentChapter[verseNumber].replacingOccurrences(of: "\n", with: "");
            let reference = selectedVerse.components(separatedBy: "}");
            let referenceNumber = reference[0]
            var verseText = reference[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let verseText2: [String] = verseText.components(separatedBy: " ")
            var verseText3: [String] = []
            for value in verseText2{
                let word = value.trimmingCharacters(in: .whitespacesAndNewlines)
                verseText3.append(word)
            }
            verseText = verseText3.joined(separator: " ")
            referenceDisplay.setText(bookName + " " + referenceNumber)
            verseDisplay.setText(verseText)
            //verseDisplay2.setText(verseText)
            //versePicker.setSelectedItemIndex(verseNumber)
            //verseNumber = verseNumber + 1
            
        
    }
    

    
    func previousVerse() {
        
        if verseNumber<0{
            verseNumber = 0
        }
        //let bookText = getBook()
        //let bookNameSplit = fileName.components(separatedBy: "_")
        //var bookName1 = bookNameSplit[1].split(separator: ".")
        //let bookName = bookName1[0]
        
            let selectedVerse = versesOfCurrentChapter[verseNumber-1].replacingOccurrences(of: "\n", with: " ");
            let reference = selectedVerse.components(separatedBy: "}");
            //let referenceNumber = reference[0]
            let verseText = reference[1].trimmingCharacters(in: .whitespacesAndNewlines)
        referenceDisplay.setText(bookName + " " + String(chapterNumber) + ":" + String(verseNumber+1))
            verseDisplay.setText(verseText)
        
    }
    
    @IBAction func tapNextVerse(_ sender: Any) {
        if bookNumber<67{
        if verseNumber<totalVerses-1{
        verseNumber = verseNumber + 1
        versePicker.setSelectedItemIndex(verseNumber)
        }
        if verseNumber==totalVerses-1{
            chapterNumber = chapterNumber + 0
            if chapterNumber<totalChapters-1{
            chapterPicker.setSelectedItemIndex(chapterNumber)
            }
            else{
                bookNumber = bookNumber + 1
                bookPicker.setSelectedItemIndex(bookNumber)
            }
        }
        }
        //nextVerse()
    }
    //filename = filename.split(separator: "_")
    
    @IBAction func swipePreviousVerse(_ sender: Any) {
        if verseNumber>0{
            verseNumber = verseNumber - 1
            versePicker.setSelectedItemIndex(verseNumber)
        }
    }
    
    @IBAction func swipeNextVerse(_ sender: Any) {
       
        
    }
 
    @objc func playVerse() {
  
        WKInterfaceDevice.current().play(.success)
//        timerLabel.stop()
//        let time  = NSDate(timeIntervalSinceNow: 60.0)
//        timerLabel.setDate(time as Date)
//        timerLabel.start()
        if bookNumber<67{
            if verseNumber<totalVerses-1{
                verseNumber = verseNumber + 1
                versePicker.setSelectedItemIndex(verseNumber)
            }
            if verseNumber==totalVerses-1{
                chapterNumber = chapterNumber + 0
                if chapterNumber<totalChapters-1{
                    chapterPicker.setSelectedItemIndex(chapterNumber)
                }
                else{
                    bookNumber = bookNumber + 1
                    bookPicker.setSelectedItemIndex(bookNumber)
                }
            }
        }
        
    }
    
    @IBOutlet var dateLabel: WKInterfaceLabel!
   
    @objc func getSeconds(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        let result = formatter.string(from: date)
        dateLabel.setText(result)
    }
       let defaults = UserDefaults.standard
    
    @IBAction func displayPickerView(_ sender: Any) {

    }
    
    @IBAction func hidePickerView(_ sender: Any) {
               pickerGroup.setHidden(true)
    }
    
    var state_display_picker = "on"

    @IBAction func tap_show_reference(_ sender: Any) {
        switch state_display_picker {
        case "on":
            pickerGroup.setHidden(true)
            state_display_picker = "off"
        case "off":
            pickerGroup.setHidden(false)
            state_display_picker = "on"
        default:
            pickerGroup.setHidden(true)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

 
        
        getBooks()
        loadBookPicker()
        defaults.set(bookNumber, forKey: "book")
        defaults.set(chapterNumber, forKey: "chapter")
        defaults.set(verseNumber, forKey: "verse")
//        let time  = NSDate(timeIntervalSinceNow: 60.0)
//        timerLabel.setDate(time as Date)
//        timerLabel.start()
        //bibleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getSeconds), userInfo: nil, repeats: true)
   
        


        
        //nextVerse()
        //referenceDisplay.setText("hello")
        // Configure interface objects here.
    }

 

    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        bookNumber = defaults.object(forKey: "book") as! Int
        chapterNumber = defaults.object(forKey: "chapter" ) as! Int
        verseNumber = defaults.object(forKey: "verse") as! Int
        playVerse()

        //playVerseFullScreen()

        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        defaults.set(bookNumber, forKey: "book")
        defaults.set(chapterNumber, forKey: "chapter")
        defaults.set(verseNumber, forKey: "verse")
        
        super.didDeactivate()
    }
    
}
