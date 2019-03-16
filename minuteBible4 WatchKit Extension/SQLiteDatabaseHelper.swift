//
//  SQLiteDatabaseHelper.swift
//  minuteBible4
//
//  Created by Giovanni Saberon on 25/01/19.
//  Copyright © 2019 Giovanni Saberon. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabaseHelper {
    
    var db: OpaquePointer?
    var databaseName: String!
    
    @objc func copyDatabase(){
        print("copying database")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(self.databaseName) {
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
            let dbPath = doumentDirectoryPath.appendingPathComponent(self.databaseName)
            var fileNameArray = self.databaseName.components(separatedBy: ".")
            let resourceName: String = fileNameArray[0]
            let nameType: String = fileNameArray[1]
            let path = Bundle.main.path(forResource: resourceName, ofType: nameType)
            do{
                try filemanager.copyItem(atPath: path!, toPath: dbPath)
            }catch let error as NSError {
                print("error occurred, here are the details:\n \(error)")
            }
            
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        
    }
    
    @objc func openDatabase(){
        //        //create database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.databaseName)
        
        //opening the database
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        else{
            print("database is open")
        }
        
    }
}
