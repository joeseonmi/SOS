//
//  BY_MainTableViewCell.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase
class BY_MainTableViewCell: UITableViewCell {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    //---IBOutlet
    @IBOutlet weak var titleQuestionLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel?
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var questionID:Int?
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let realQuestionTitleText:String = self.titleQuestionLabel.text as? String else {return print("퀘스쳔타이틀 가드문에 걸림")}
        self.getQuestionIDForQuestion(title: realQuestionTitleText) { (int) in
            self.questionID = int
        }
        
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    func getLikeCount(question id:Int) {
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_QuestionId).queryEqual(toValue: id).keepSynced(true)
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_QuestionId).queryEqual(toValue: id).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? [String:[String:Any]] else { return }
            self.favoriteCountLabel.text = "\(data.count)"
            
        }) { (error) in
            print(error.localizedDescription)
        }
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_QuestionId).queryEqual(toValue: id).observeSingleEvent(of: .childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String:[String:Any]] else { return }
            self.favoriteCountLabel.text = "\(data.count)"
            
        }) { (error) in
            print("좋아요 에러", error.localizedDescription ?? "no data")
        }
    }
    
    func getQuestionIDForQuestion(title:String, completion:@escaping (_ info:Int) -> Void) {
        Database.database().reference().child(Constants.question).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let tempQuestionDatas = snapshot.value as? [[String:Any]] else {return print("질문데이터가 없습니다. \(snapshot.value)")}
            
            let tempSelectedQuestionData = tempQuestionDatas.filter({ (dic) -> Bool in
                guard let selectedQuestionTitle = dic[Constants.question_QuestionTitle] as? String else {
                    print("질문타이틀이 없습니다. \(dic[Constants.question_QuestionTitle])")
                    return false}
                
                return selectedQuestionTitle == title
            })
            
            if tempSelectedQuestionData.count == 1 {
            guard let selectedQuestionID = tempSelectedQuestionData[0][Constants.question_QuestionId] as? Int else {return print("질문아이디가 없습니다.")}

            completion(selectedQuestionID)
            }
            
        }) { (error) in
            print("QuestionID 에러", error.localizedDescription)
        }
        
    }
    
    
    
}
