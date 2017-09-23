//
//  MainTableViewCell.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 21..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewCell: UITableViewCell {
    
    
    /*******************************************/
    // MARK: -  Outlet                         //
    /*******************************************/
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    /*******************************************/
    // MARK: -  LifeCycle                      //
    /*******************************************/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = "title"
        self.tagLabel.text = "tag"
        self.likeCountLabel.text = "0"
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*******************************************/
    // MARK: -  Func                           //
    /*******************************************/
    
    func getQuestionData(indexPath:Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            Database.database().reference().child("Question").child("\(indexPath)").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = snapshot.value as? [String:Any] else { return }
                DispatchQueue.main.async {
                    guard let titleString = data["Question_Title"] as? String else { return }
                    self.titleLabel.text = titleString
                    guard let tagArray = data["Tag"] as? [String] else { return }
                    self.tagLabel.text = "#\(tagArray[0]), #\(tagArray[1]), #\(tagArray[2])"
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
}
