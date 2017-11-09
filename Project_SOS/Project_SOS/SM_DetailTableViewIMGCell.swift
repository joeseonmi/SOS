//
//  SM_DetailTableViewIMGCell.swift
//  Project_SOS
//
//  Created by joe on 2017. 11. 9..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit

protocol bubbleImageCellDelegate {
    func presentPopup()
}


class SM_DetailTableViewIMGCell: UITableViewCell {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var explainBubbleImage: UIImageView!
    @IBOutlet weak var characterIconImage: UIImageView!
    @IBOutlet weak var clickedImageOutlet: UIButton!
    var delegate:bubbleImageCellDelegate?
    
    
    /*******************************************/
    //MARK:-        Life cycle                 //
    /*******************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
        self.explainBubbleImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*******************************************/
    //MARK:-        Func                       //
    /*******************************************/
    
    @IBAction func clickedImageBtn(_ sender: UIButton) {
        print("이미지셀이 눌렸다능")
        self.delegate?.presentPopup()
    }
    
}
