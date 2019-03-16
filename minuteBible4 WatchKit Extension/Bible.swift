//
//  Bible.swift
//  minuteBible4 WatchKit Extension
//
//  Created by Giovanni Saberon on 14/01/19.
//  Copyright © 2019 Giovanni Saberon. All rights reserved.
//

import Foundation

class BibleInfo {
    
    var bookID : Int = 0
    var fullName : String!
    var tableName : String!
    var shortName : String!
    var totalVerses : Int = 0
    var totalChapters : Int = 0
    var abbName : String!
    var testament : String!
    var category : String!
    var status: String!
    
}

class MinuteBibleVerse{

  var tableName : String!
  var id: Int = 0
}

class Book {
    var id : Int = 0
    var bookID : Int = 0
    var book : String!
    var chapter : String!
    var verse : String!
    var word : String!
    var image : String!
    var testament : String!
    var shortName : String!
    var abbName : String!

}
