//
//  BubbleTableViewCell.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 21..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase

class BubbleTableViewCell: UITableViewCell {

    @IBOutlet weak var roundingBG: UIView!
    @IBOutlet weak var context: UILabel!
    @IBOutlet var characterImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundingBG.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadAnswerData(qustion id: Int) {
        Database.database().reference().child(Constants.question).child("\(id)").observeSingleEvent(of: .value, with: { (questionData) in
            guard let data = questionData.value as? [String:[String:Any]] else { return }
            guard let jsAnswer = data[Constants.question_JSAnswer] as? [String:Any] else { return }
            
            
        }) { (error) in
            print("=====================error: ",error.localizedDescription)
        }
    }
    
}
