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
    
    var favoriteQuestions:[Int] = []
    
}

//struct QuestionData {
//
//    var question_Title:String
//    var question_Tag:[String]
//
//    init(id:Int) {
//        Database.database().reference().child(Constants.question).child("\(id)").observeSingleEvent(of: .value, with: { (data) in
//            guard let data = data.value as? [String:Any] else { return }
//            self.question_Title = data[Constants.question_QuestionTitle] as! String
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
//
//}

