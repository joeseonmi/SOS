//
//  SM_BubbleTableViewController.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 23..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase

class SM_BubbleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    var questionID:Int?
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBAction func clickedLikeBtn(_ sender: UIButton) {
     likeBtnAction()
    }
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        self.tableview.register(UINib(nibName: "BubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "BubbleTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    /*******************************************/
    //MARK:-        TableView                  //
    /*******************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        //나중에 데이터 갯수로 변경
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableViewAutomaticDimension듯
        //오토메틱으로 정할때 최소높이 정해줘야할듯
        return 200
    }
    
    /*******************************************/
    //MARK:-        Func                       //
    /*******************************************/
    
    func likeBtnAction() {
        guard let realQuestionID:Int = self.questionID else { return }
        
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
            guard let likeData = snapshot.value as? [String:[String:Any]] else { return }
            print("데이터가있슴니돠아아아아ㅏ==================:", likeData)
            let filteredData = likeData.filter({ (dic:(key:String, value:[String:Any])) -> Bool in
                var filteredQuestionID = dic.value[Constants.like_QuestionId]
                return realQuestionID == filteredQuestionID as! Int
            })
            
            print("필터된데이터!!!!!!!!!!!!!!:", filteredData)
            switch filteredData.count {
            case 0 : Database.database().reference().child(Constants.like).childByAutoId().setValue([Constants.like_QuestionId:realQuestionID,Constants.like_User_Id:Auth.auth().currentUser?.uid])
                self.getLikeCount(question:realQuestionID)
                DataCenter.standard.favoriteQuestions.append(realQuestionID)
                print("좋아요리스트!!!!!!!!!!!!!!!!",DataCenter.standard.favoriteQuestions)
            case 1 :
                Database.database().reference().child(Constants.like).child(filteredData[0].key).setValue(nil)
                self.getLikeCount(question: realQuestionID)
                if let deleteIndex:Int = DataCenter.standard.favoriteQuestions.index(of: realQuestionID) {
                    DataCenter.standard.favoriteQuestions.remove(at: deleteIndex)
                }
                print("좋아요리스트!!!!!!!!!!!!!!!!",DataCenter.standard.favoriteQuestions)
            default:
                print("error!!!!!!!!!!!!!!")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //질문아이디를 받아서 해당 질문에 좋아요가 몇개인지 count
    func getLikeCount(question id:Int) {
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_QuestionId).queryEqual(toValue: id).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = snapshot.value as? [String:[String:Any]] else { return }
            print("아이디가 다 똑같은지 확인점~",data)
            print("갯수염",data.count)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}


