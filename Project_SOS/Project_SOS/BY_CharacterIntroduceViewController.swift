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
    @IBOutlet weak var introduceBYLabel: UILabel!
    @IBOutlet weak var introduceJSLabel: UILabel!
    @IBOutlet weak var introduceSMLabel: UILabel!
    
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
