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
    
    @IBOutlet weak var clickedImageOutlet: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterIconImage: UIImageView!
    @IBOutlet weak var explainBubbleText: UILabel!
    @IBOutlet weak var explainBubbleImage: UIImageView!
    
    @IBAction func clickedImageBtn(_ sender: UIButton) {
        
    }
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.explainBubbleImage.layer.cornerRadius = 10
        self.explainBubbleImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
}
