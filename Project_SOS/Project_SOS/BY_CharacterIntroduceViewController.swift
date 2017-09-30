//
//  BY_CharacterIntroduceViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 20/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_CharacterIntroduceViewController: UIViewController {
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var introduceBYTitleLabel: UILabel!
    @IBOutlet weak var introduceBYDetailLabel: UILabel!
    
    @IBOutlet weak var introduceJSTitleLabel: UILabel!
    @IBOutlet weak var introduceJSDetailLabel: UILabel!
    @IBOutlet weak var introduceSMTitleLabel: UILabel!
    @IBOutlet weak var introduceSMDetailLabel: UILabel!
    
    
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
    @IBAction func dismissViewButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
