//
//  JS_TestShareViewController.swift
//  Project_SOS
//
//  Created by leejaesung on 2017. 9. 29..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit

class JS_TestShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 테스트 공유 버튼 액션 정의
    @IBAction func buttonShareAction(_ sender: UIButton) {
        let text = "Hello Swift"
        
        shareTextOf(text: text)
    }
    
    
    // MARK: 텍스트 공유 기능 function 정의
    func shareTextOf(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil) // 액티비티 뷰 컨트롤러 설정
        activityVC.popoverPresentationController?.sourceView = self.view // 아이패드에서 작동하도록 pop over로 설정
        activityVC.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll ] // 제외 타입 설정
        
        self.present(activityVC, animated: true, completion: nil)
    }
}
