//
//  Weather.swift
//  Promises
//
//  Created by Maksim Romanov on 27.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Weather: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var date: Date = Date.distantPast
    @objc dynamic var temperature: Double = 0
    
    @objc dynamic var icon: String = ""
    @objc dynamic var descr: String = ""
        
    convenience init(from json: JSON, city: String) {
        self.init()
        
        let dateDouble = json["dt"].doubleValue
        self.date = Date(timeIntervalSince1970: dateDouble)
        
        self.temperature = json["main"]["temp"].doubleValue
        
        self.icon = json["weather"][0]["icon"].stringValue
        self.descr = json["weather"][0]["description"].stringValue
        self.id = city + String(dateDouble)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toAnyObject() -> [String: Any] {
        return [ String(date.timeIntervalSince1970) : temperature ]
    }
}
