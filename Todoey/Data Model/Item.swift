//
//  Item.swift
//  Todoey
//
//  Created by armagan ozdemir on 12.01.2019.
//  Copyright © 2019 armagan ozdemir. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    var title:String=""
    var done:Bool=false
}
