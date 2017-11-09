//
//  BY_DetailTableViewCell.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 22/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import ActiveLabel

class BY_DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var test: NSLayoutConstraint!
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var characterIconImage: UIImageView!
    @IBOutlet weak var explainBubbleText: ActiveLabel!

    
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
        self.explainBubbleTextActiveLabelUISetting()
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
    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        print("///// alert- 8323")
    }
    
    // MARK: JS: ActiveLabel setting function
    // ActiveLabel.swift: https://github.com/optonaut/ActiveLabel.swift
    func explainBubbleTextActiveLabelUISetting() {
        self.explainBubbleText.urlMaximumLength = 31
        
        self.explainBubbleText.customize { (label) in
            label.numberOfLines = 0
            label.lineSpacing = 4
            
            label.textColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            label.hashtagColor = UIColor(red: 0.0/255.0, green: 53.0/255.0, blue: 105.0/255.0, alpha: 1.0)
            label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1.0)
            label.URLColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0)
            label.URLSelectedColor = UIColor.gray
            
            label.handleMentionTap { self.alert("Mention", message: $0) }
            label.handleHashtagTap { self.alert("Hashtag", message: $0) }
            label.handleURLTap { self.alert("URL", message: $0.absoluteString) }
        }
    }
    
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
