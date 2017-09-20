//
//  JSAdMobTestViewController.swift
//  Project_SOS
//
//  Created by leejaesung on 2017. 9. 16..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import GoogleMobileAds

class JS_AdMobTestViewController: UIViewController {
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        self.view.addSubview(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
