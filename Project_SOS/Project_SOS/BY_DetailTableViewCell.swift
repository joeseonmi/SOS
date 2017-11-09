//
//  BY_DetailTableViewCell.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 22/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit


class BY_DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var test: NSLayoutConstraint!
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterIconImage: UIImageView!
    @IBOutlet weak var explainBubbleText: UILabel!

    
    //Explain ImageView Constraints
    @IBOutlet weak var explainImageViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var explainImageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var explainImageViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var explainImageViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var explainImageViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var explainImageViewTaillingSpace: NSLayoutConstraint!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
}

extension UIView {
    func anchor(top:NSLayoutYAxisAnchor?,
                left:NSLayoutXAxisAnchor?,
                right:NSLayoutXAxisAnchor?,
                bottom:NSLayoutYAxisAnchor?,
                topConstant:CGFloat,
                leftConstant:CGFloat,
                rightConstant:CGFloat,
                bottomConstant:CGFloat,
                width:CGFloat,
                height:CGFloat,
                centerX:NSLayoutXAxisAnchor?,
                centerY:NSLayoutYAxisAnchor?,
                contentMode:UIViewContentMode) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
            self.topAnchor.constraint(equalTo: top, constant: topConstant).priority = 750
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
            self.leftAnchor.constraint(equalTo: left, constant: leftConstant).priority = 750
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
            self.rightAnchor.constraint(equalTo: right, constant: -rightConstant).priority = 750
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).priority = 750
        }
        
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
            self.centerXAnchor.constraint(equalTo: centerX).priority = 750
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
            self.centerYAnchor.constraint(equalTo: centerY).priority = 750
        }
        
        if width > 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height > 0 {
            self.heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
            self.heightAnchor.constraint(lessThanOrEqualToConstant: height).priority = 1000
        }
        
    }
}
