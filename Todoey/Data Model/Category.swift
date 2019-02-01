//
//  Category.swift
//  Todoey
//
//  Created by armagan ozdemir on 20.01.2019.
//  Copyright © 2019 armagan ozdemir. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String=""
    @objc dynamic var color:String=""
    let items=List<Item>()
}
