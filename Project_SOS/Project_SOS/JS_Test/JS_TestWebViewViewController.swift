//
//  JS_TestWebViewViewController.swift
//  Project_SOS
//
//  Created by leejaesung on 2017. 9. 28..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import SafariServices

class JS_TestWebViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: URL 지정해서 웹뷰 열기
    @IBAction func buttonGoogle(_ sender:UIButton) {
        // openSafariViewOf()의 parameter 값에 url을 던지면 됩니다.
        openSafariViewOf(url: "http://google.com")
    }
    
    @IBAction func buttonNaver(_ sender:UIButton) {
        openSafariViewOf(url: "http://naver.com")
    }
    
    @IBAction func buttonblackturtle2(_ sender:UIButton) {
        openSafariViewOf(url: "http://blackturtle2.net")
    }
    
    // MARK: 구글링 버튼 예시
    @IBAction func buttonGoogling(_ sender:UIButton) {
        let keyword:String = "생명주기" //키워드는 공백을 허용하지 않습니다.
        guard let realKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return } // 한글 키워드를 그냥 넣으면, URL로 인코딩을 하지 못해서 웹뷰로 연결되지 않습니다.
        
        openSafariViewOf(url: "https://www.google.co.kr/search?q=swift+\(realKeyword)")
    }
    
    // MARK: 네이버링 버튼 예시
    @IBAction func buttonNavering(_ sender:UIButton) {
        let keyword:String = "생명주기"
        guard let realKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        openSafariViewOf(url: "http://search.naver.com/search.naver?query=swift+\(realKeyword)")
    }
    
    // MARK: 인앱웹뷰 열기 function 정의
    // `SafariServices`의 import가 필요합니다.
    func openSafariViewOf(url:String) {
        guard let realURL = URL(string: url) else { return }
        
        // iOS 9부터 지원하는 `SFSafariViewController`를 이용합니다.
        let safariViewController = SFSafariViewController(url: realURL)
        safariViewController.delegate = self // 사파리 뷰에서 `Done` 버튼을 눌렀을 때의 액션 정의를 위한 Delegate 초기화입니다.
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}
// MARK: Extension - SFSafariViewControllerDelegate
extension JS_TestWebViewViewController: SFSafariViewControllerDelegate {
    
    // SFSafariViewController에서 Done 버튼을 눌렀을 때의 액션을 정의합니다.
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
