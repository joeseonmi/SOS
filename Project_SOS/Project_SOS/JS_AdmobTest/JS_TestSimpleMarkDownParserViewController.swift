//
//  JS_TestSimpleMarkDownParserViewController.swift
//  Project_SOS
//
//  Created by leejaesung on 2017. 9. 19..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import SimpleMarkdownParser

class JS_TestSimpleMarkDownParserViewController: UIViewController {
    
    @IBOutlet var uiLabelMarkdownTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rawTextArray: [String] = [
            "# 첫번째 제목",
            "## 두번째 제목",
            "### 세번째 제목",
            "",
            "1. 기울림체 *테스트* -> 한글 불가능",
            "2. 볼드체 **테스트**",
            "3. 둘다 ***테스트*** -> 한글은 기울림체가 불가능",
            "4. 취소선 ~테스트~",
            "5. 특수문자 표시 \\*테스트\\*",
            "6. 소스코드(강조) 표시 `테스트` -> 지원 불가 / 커스터마이징 필요",
            "",
            "### 별표시 목록 테스트",
            "* First item",
            "* Second item",
            "",
            "### 링크 테스트",
            "Testing a link to [github](https://github.com/crescentflare/SimpleMarkdownParser).",
            ""
        ]
        // Array가 아닌, "\n"이 들어간 String으로 아래의 메소드에 던집니다.
        let markdownText:String = rawTextArray.joined(separator: "\n")
        
        // 컨버팅을 거쳐 UILabel에 뿌리는 메소드입니다.
        defaultAttributedStringConversion(markdownText: markdownText)
        
        
        // UILabel에 제스쳐를 먹여서 링크를 터치했을 때, 반응하도록 합니다.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel(_:)))
        uiLabelMarkdownTest.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: SimpleMarkdownConverter를 이용해 UILabel에 뿌리는 코드
    // 이 안에서 몇가지 커스터마이징이 가능합니다.
    func defaultAttributedStringConversion(markdownText: String) {
        let attributedString = SimpleMarkdownConverter.toAttributedString(defaultFont: uiLabelMarkdownTest.font, markdownText: markdownText)
        uiLabelMarkdownTest.attributedText = attributedString
    }
    
    // 링크를 눌렀을 때, 사파리로 웹사이트를 열도록 하는 코드
    func didTapOnLabel(_ gesture: UITapGestureRecognizer) {
        if let url: URL = gesture.findUrl(onLabel: uiLabelMarkdownTest) {
            UIApplication.shared.openURL(url)
        }
    }
    
}

