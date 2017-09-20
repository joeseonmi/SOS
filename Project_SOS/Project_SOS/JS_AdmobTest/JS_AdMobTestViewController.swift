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
    
    @IBOutlet var uiViewAdmobBannerBackgroundView:UIView!
    // 스토리보드에서 UIView를 화면 최하단에 삽입하고, 오토레이아웃의 높이는 50으로 설정합니다.
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAdMobView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    // MARK: AdMob을 UIView에 추가하는 메소드입니다.
    // IBOutlet에서 UIView를 추가하고, 작업하면 됩니다.
    func addAdMobView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        // adSize에는 6가지 종류가 있고, 가장 보편적인 사이즈는 '320*50'입니다.
        // 쏘쓰에는 아이폰의 종류에 따라 광고 사이즈가 변하는 SmartBanner를 선택했습니다.
        // 참고: https://developers.google.com/admob/ios/banner?hl=ko
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 adUnitID
        bannerView.adUnitID = "ca-app-pub-9821073709980211/5330955915" // 실제 사용하는 adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        self.uiViewAdmobBannerBackgroundView.addSubview(bannerView)
    }

}
