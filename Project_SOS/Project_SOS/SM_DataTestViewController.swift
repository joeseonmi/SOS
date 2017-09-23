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
    var userUid:String = UserDefaults.standard.object(forKey: Constants.userdefault_userUid) as? String ?? ""
    var userCount:Int = 0
    
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
        
        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userdefault_userUid)
      
        guard let realUserUid:String = UserDefaults.standard.object(forKey: Constants.userdefault_userUid) as? String else {
            print("유아이디 없음 헤헤")
            return
        }
        
        Database.database().reference().child(Constants.user).queryOrdered(byChild: Constants.user_userId).queryEqual(toValue: realUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userData:[[String:String]] = snapshot.value as? [[String:String]] else {
                print("유저가 없음 \(snapshot.value)")
                
                Database.database().reference().child(Constants.user).observe(.value, with: { (snapshot) in
                    self.userCount = Int(snapshot.childrenCount)
                })
                
                //User중에 uid와 일치하는 값이 있으면 등록 안되게 처리해야됨
                Database.database().reference().child(Constants.user).child("\(self.userCount)").child(Constants.user_userId).setValue(realUserUid)
                print("Database에 등록완료")
                
                return
            }
            
            print("유저가 있음 \(snapshot.value)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Auth.auth().currentUser?.delete(completion: { (error) in
//            print(error?.localizedDescription)
//            print("삭제되었습니다")
//        })
//        
        
    }
    
    /*******************************************/
    //MARK:-        Func                       //
    /*******************************************/
    
    func setUserWithUid(user uid:String) {
        UserDefaults.standard.set(uid, forKey: Constants.userdefault_userUid)
    }
    //
    //    func setSelectedCharacter(selectedCharacter name:String) {
    //        UserDefaults.standard.set(name, forKey: "SelectedCharacter")
    //    }
    
    //    func makeAnonymouslyUser(completion: @escaping(_ uid:String)->Void) {
    //        Auth.auth().signInAnonymously { (user, error) in
    //            print("error=", error?.localizedDescription as Any)
    //            print("uid=",user?.uid as Any)
    //            guard let realUser = user else { return }
    //            let realUserUid = realUser.uid
    //            completion(realUserUid)
    //        }
    //    }
    
    
    
}


