//
//  SM_ImagePopupViewController.swift
//  Project_SOS
//
//  Created by joe on 2017. 10. 13..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit

class SM_ImagePopupViewController: UIViewController {
    
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    var imageURL:URL? = nil
    @IBOutlet weak var contentsImage: UIImageView!
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, res, err) in
            print("///// data 456: ", data ?? "no data")
            print("///// res 456: ", res ?? "no data")
            print("///// error 456: ", err ?? "no data")
            guard let realData = data else { return }
            DispatchQueue.main.async {
                self.contentsImage.image = UIImage(data: realData)
            }
        })
        task.resume()

    }

    /*******************************************/
    //MARK:-          Func                     //
    /*******************************************/
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
