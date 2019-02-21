//
//  MyData.swift
//  Swift_UserDefaults
//
//  Created by 一木 英希 on 2019/02/18.
//  Copyright © 2019 一木 英希. All rights reserved.
//

import Foundation

class MyData: NSObject, NSCoding {
    
    override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        self.valueString = aDecoder.decodeObject(forKey: "valueString") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.valueString, forKey: "valueString")
    }
    
    var valueString: String?
}
