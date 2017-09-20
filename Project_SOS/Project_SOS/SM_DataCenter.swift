//
//  SM_DataCenter.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 16..
//  Copyright © 2017년 joe. All rights reserved.
//

import Foundation
import Firebase

class DataCenter {
    
    static let standard = DataCenter()

    
}


struct User {
    
    let user_uid:String
    
    var dictionary:[String:String] {
        return ["User_ID":self.user_uid]
    }
    
    init(data:[String:String]) {
        self.user_uid = data["User_ID"]!
    }
    
}
