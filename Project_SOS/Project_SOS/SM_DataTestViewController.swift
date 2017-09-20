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
    var userUid:String = ""
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
        
        //익명유저 추가요
        makeAnonymouslyUser { (uid) in
            self.userUid = uid
        }
        
        //선택한캐릭터를 유저디폴드에저장setValue(uid, forKey: "User_ID")        setSelectedCharacter(selectedCharacter: selectedCharacterName)
 
        //만들어진 uid를 유저디폴트에저장
        setUserWithUid(user: userUid)

        //파베 User에 user_uid 저장
        saveAtFirebaseUser(user: userUid)
        
        //TODO: - 버튼을 처음눌렀을땐 빈칸이고, 두번눌러야 값이 들어간다 왜때문이죠?
        print("UserUid =", userUid)
        print("Set된 UserUid =" ,UserDefaults.standard.object(forKey: "UserUid") as Any)
        print("Set된 Character =" ,UserDefaults.standard.object(forKey: "SelectedCharacter") as Any)
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
    
    func setUserWithUid(user uid:String) {
        UserDefaults.standard.set(uid, forKey: "UserUid")
    }
    
    func setSelectedCharacter(selectedCharacter name:String) {
        UserDefaults.standard.set(name, forKey: "SelectedCharacter")
    }
    
    func makeAnonymouslyUser(completion: @escaping(_ uid:String)->Void) {
        Auth.auth().signInAnonymously { (user, error) in
            print("error=", error?.localizedDescription as Any)
            print("uid=",user?.uid as Any)
            guard let realUser = user else { return }
            let realUserUid = realUser.uid
            completion(realUserUid)
        }
    }
    
    func saveAtFirebaseUser (user uid:String) {
        Database.database().reference().child("User").observe(.value, with: { (snapshot) in
            self.userCount = Int(snapshot.childrenCount)
        })
        Database.database().reference().child("User").child("\(self.userCount)").child("User_ID").setValue(uid)
        //파베에 딕셔너리를 업로드해야됨
    }
   
}


