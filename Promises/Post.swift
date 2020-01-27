//
//  Post.swift
//  Promises
//
//  Created by Maksim Romanov on 27.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Post: Object, Decodable {
    @objc dynamic var id = -1
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.body = json["body"].stringValue
    }

    override static func primaryKey() -> String? {
        return "id"
    }

}
