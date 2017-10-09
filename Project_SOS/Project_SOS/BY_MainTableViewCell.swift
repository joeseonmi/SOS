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

    var questionID:Int? {
        didSet{
            guard let realQuestionID = questionID else {return}
            questionID = realQuestionID
        }
    }

    //---IBOutlet
    @IBOutlet weak var titleQuestionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel?
    @IBOutlet weak var favoriteCountLabel: UILabel!

    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let realQuestionTitleText:String = self.titleQuestionLabel.text else {return print("퀘스쳔타이틀 가드문에 걸림")}
        self.getQuestionIDForQuestion(title: realQuestionTitleText) { (int) in
            self.questionID = int
        }
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    //보영: 특정 질문에 대한 좋아요 데이터 가져오는 부분
    func loadLikeDatafor(questionID:Int) {
        DispatchQueue.global(qos: .default).async {
            Database.database().reference().child(Constants.like).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.childrenCount != 0 {
                    guard let tempLikeDatas = snapshot.value as? [String:[String:Any]] else {return}
                    
                    let filteredLikeData = tempLikeDatas.filter({ (dic:(key: String, value: [String : Any])) -> Bool in
                        let exhibitionID:Int = dic.value[Constants.like_QuestionId] as! Int
                        return exhibitionID == questionID
                    })
                    self.favoriteCountLabel.text = "0"
                    
                    DispatchQueue.main.async {
                        self.favoriteCountLabel.text = "\(filteredLikeData.count)"
                    }
                }else{
                    guard let json = snapshot.value as? [String:Any] else {return}
                    print("좋아요 없어요")
                }
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func getQuestionIDForQuestion(title:String, completion:@escaping (_ info:Int) -> Void) {
        Database.database().reference().child(Constants.question).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let tempQuestionDatas = snapshot.value as? [[String:Any]] else {return print("질문데이터가 없습니다.: ", snapshot.value ?? "(no data)")}
            
            let tempSelectedQuestionData = tempQuestionDatas.filter({ (dic) -> Bool in
                guard let selectedQuestionTitle = dic[Constants.question_QuestionTitle] as? String else {
                    print("질문타이틀이 없습니다.: ", dic[Constants.question_QuestionTitle] ?? "(no data)")
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
