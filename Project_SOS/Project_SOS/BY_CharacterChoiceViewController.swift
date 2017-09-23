//
//  BY_CharacterChoiceViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_CharacterChoiceViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var normalBYButtonOutlet: UIButton!
    @IBOutlet weak var normalSMButtonOutlet: UIButton!
    @IBOutlet weak var normalJSButtonOutlet: UIButton!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
            UserDefaults.standard.set("보영", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
        }
    }
    
    @IBAction func selectSMButtonAction(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.setImage(#imageLiteral(resourceName: "SM_ON"), for: .normal)
            self.normalBYButtonOutlet.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
            self.normalJSButtonOutlet.setImage(#imageLiteral(resourceName: "JS_OFF"), for: .normal)
            
            UserDefaults.standard.set("선미", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "SM_OFF"), for: .normal)
        }
    }
    
    @IBAction func selectJSButtonAction(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.setImage(#imageLiteral(resourceName: "JS_ON"), for: .normal)
            self.normalBYButtonOutlet.setImage(#imageLiteral(resourceName: "BY_OFF"), for: .normal)
            self.normalSMButtonOutlet.setImage(#imageLiteral(resourceName: "SM_OFF"), for: .normal)
            
            UserDefaults.standard.set("재성", forKey: "SelectedCharacter")
        }else{
            sender.setImage(#imageLiteral(resourceName: "JS_OFF"), for: .normal)
        }
    }
    
    @IBAction func completeButtonAction(_ sender: UIButton) {
        guard let realCharacterString:String = UserDefaults.standard.object(forKey: "SelectedCharacter") as? String else {return}
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "characterSelected"), object: realCharacterString)
        self.dismiss(animated: true, completion: nil)
    }
    
    func noSelectedCharacterAlert() {
        let alert = UIAlertController(title: "이런!", message: "아무 캐릭터도 고르지 않았네요.\n취향인 캐릭터를 골라주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
