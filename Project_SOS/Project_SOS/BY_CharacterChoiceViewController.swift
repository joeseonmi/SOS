//
//  BY_CharacterChoiceViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_CharacterChoiceViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var normalBYButtonOutlet: UIButton!
    @IBOutlet weak var normalSMButtonOutlet: UIButton!
    @IBOutlet weak var normalJSButtonOutlet: UIButton!
    @IBOutlet weak var completeButtonOutlet: UIButton!
    
    var userCount:Int = 0
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bgView.layer.cornerRadius = 10
        self.bgView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    @IBAction func selectBYButtonAction(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.setImage(#imageLiteral(resourceName: "BY_ON"), for: .normal)
            self.normalSMButtonOutlet.setImage(#imageLiteral(resourceName: "SM_OFF"), for: .normal)
            self.normalJSButtonOutlet.setImage(#imageLiteral(resourceName: "JS_OFF"), for: .normal)
            
            self.completeButtonOutlet.setTitle("보영! 너로 정했다!", for: .normal)
            UserDefaults.standard.set("보영", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
            self.completeButtonOutlet.setTitle("선택해주세요!", for: .normal)
        }
    }
    
    @IBAction func selectSMButtonAction(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.setImage(#imageLiteral(resourceName: "SM_ON"), for: .normal)
            self.normalBYButtonOutlet.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
            self.normalJSButtonOutlet.setImage(#imageLiteral(resourceName: "JS_OFF"), for: .normal)
            
            self.completeButtonOutlet.setTitle("선미! 너로 정했다!", for: .normal)
            UserDefaults.standard.set("선미", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "SM_OFF"), for: .normal)
            self.completeButtonOutlet.setTitle("선택해주세요!", for: .normal)
        }
    }
    
    @IBAction func selectJSButtonAction(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.setImage(#imageLiteral(resourceName: "JS_ON"), for: .normal)
            self.normalBYButtonOutlet.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
            self.normalSMButtonOutlet.setImage(#imageLiteral(resourceName: "SM_OFF"), for: .normal)
            
            self.completeButtonOutlet.setTitle("재성! 너로 정했다!", for: .normal)
            UserDefaults.standard.set("재성", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "JS_OFF"), for: .normal)
            self.completeButtonOutlet.setTitle("선택해주세요!", for: .normal)
        }
    }
    
    @IBAction func completeButtonAction(_ sender: UIButton) {
        guard let realCharacterString:String = UserDefaults.standard.object(forKey: "SelectedCharacter") as? String else {return}
        
        saveUserUidAtDatabase()
        
        //캐릭터 설정창에서 완료버튼을 눌렀을 때, 어떤 캐릭터를 설정했는지 파이어베이스에 이벤트로 저장
        switch realCharacterString {
        case "보영":
            Analytics.logEvent("BY_Selected", parameters: ["id":realCharacterString])
        case "선미":
            Analytics.logEvent("SM_Selected", parameters: ["id":realCharacterString])
        case "재성":
            Analytics.logEvent("JS_Selected", parameters: ["id":realCharacterString])
        default: break
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "characterSelected"), object: realCharacterString)
        self.dismiss(animated: true, completion: nil)
    }
    
    func noSelectedCharacterAlert() {
        let alert = UIAlertController(title: "이런!", message: "아무 캐릭터도 고르지 않았네요.\n취향인 캐릭터를 골라주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //SM func
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
}
