//
//  BY_MainTableViewCell.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

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
    //MARK:-         Functions                 //
    /*******************************************/
    
    
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    
    
}
