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
    
    @IBOutlet weak var tagOneLabel: UILabel?
    @IBOutlet weak var tagTwoLabel: UILabel?
    @IBOutlet weak var tagThreeLabel: UILabel?
    @IBOutlet weak var tagFourLabel: UILabel?
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
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
            print(error.localizedDescription)
        }
    }
    
    
}
