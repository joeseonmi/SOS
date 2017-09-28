//
//  BY_DetailTableViewCell.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 22/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_DetailTableViewCell: UITableViewCell {

    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterIconImage: UIImageView!
    @IBOutlet weak var explainBubbleText: UILabel!
    @IBOutlet weak var explainBubbleImage: UIImageView!
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
}
