//
//  SM_DataTestViewController.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 14..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase

class SM_DataTestViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    var selectedCharacterName:String = ""
    var userCount:Int = 0
    
    @IBAction func deleteUser(_ sender: UIButton) {
//        deleteUser()
        
    }
    @IBOutlet weak var iconBY: UIButton!
    @IBOutlet weak var iconJS: UIButton!
    @IBOutlet weak var iconSM: UIButton!
    
    @IBAction func selectedCharacter(_ sender: UIButton) {
        guard let senderTitle = sender.currentTitle else { return }
        switch senderTitle {
        case "BY":
            iconBY.isSelected = true
            iconJS.isSelected = false
            iconSM.isSelected = false
            selectedCharacterName = "BY"
        case "JS":
            iconBY.isSelected = false
            iconJS.isSelected = true
            iconSM.isSelected = false
            selectedCharacterName = "JS"
        case "SM":
            iconBY.isSelected = false
            iconJS.isSelected = false
            iconSM.isSelected = true
            selectedCharacterName = "SM"
        default:
            print("error")
        }
    }
    
    @IBAction func clickedMakeUser(_ sender: UIButton) {
        saveUserUidAtDatabase()
    }
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*******************************************/
    //MARK:-        Func                       //
    /*******************************************/
    
    func saveUserUidAtDatabase(){
        
        //유저디폴트에 현재 유저uid를 셋해줌 앱델리게이트에서 해도될듯한데,일단 여기다해둠
        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userdefault_userUid)
        
        //유저디폴트에 uid가 있는지 바인딩해줌
        guard let realUserUid:String = UserDefaults.standard.object(forKey: Constants.userdefault_userUid) as? String else {
            print("유아이디 없음 헤헤")
            return
        }
        
        //데이터베이스에서 해당 uid가 있는지 검색함
        Database.database().reference().child(Constants.user).queryOrdered(byChild: Constants.user_userId).queryEqual(toValue: realUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userData:[[String:String]] = snapshot.value as? [[String:String]] else {
                print("유저가 없음 \(snapshot.value)")
                
                //이건 Database에 child이름을 유저숫자에 맞게 짓고싶어서 카운트 받아오려고 만든부분
                Database.database().reference().child(Constants.user).observe(.value, with: { (snapshot) in
                    self.userCount = Int(snapshot.childrenCount)
                })
                
                //Database에 uid저장함
                Database.database().reference().child(Constants.user).child("\(self.userCount)").child(Constants.user_userId).setValue(realUserUid)
                print("Database에 등록완료")
                
                return
            }
            
            print("유저가 있음 \(snapshot.value)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
//    func deleteUser() {
//
//        Database.database().reference().queryOrdered(byChild: Constants.user_userId).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let userData:[[String:String]] = snapshot.value as? [[String:String]] else { return }
//            Database.database().reference().queryOrdered(byChild: Constants.user_userId).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                guard let userData = snapshot.value as? [[String:String]] else { return }
//                let childName:String = userData
//
//            }, withCancel: { (error) in
//                print(error.localizedDescription)
//            })
//
//        }) { (error) in
//            print("===========error: ",error.localizedDescription)
//        }
//
//        Auth.auth().currentUser?.delete(completion: { (error) in
//            print(error?.localizedDescription)
//            print("삭제되었습니다")
//        })
//    }
    
    
    
}


