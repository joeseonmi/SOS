//
//  BY_DetailViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import SafariServices
import Kingfisher

//이미지 띄워지기 전 보여질 Indicator
struct BY_Indicator: Indicator {
    let view: UIView = UIView()
    
    func startAnimatingView() {
        view.isHidden = false
    }
    func stopAnimatingView() {
        view.isHidden = true
    }
    
    init() {
        view.backgroundColor = .red
    }
}

class BY_DetailViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    var questionID:Int?
    var userUid = Auth.auth().currentUser?.uid
    var byAnswer:[[String:String]] = []
    var jsAnswer:[[String:String]] = []
    var smAnswer:[[String:String]] = []
    
    //인디케이터
    let imageLoadingIndicator = BY_Indicator()
    
    //네비게이션 바
    @IBOutlet weak var navigationBarLogoButtonOutlet: UIButton!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    //SearchVC을 통해 Present 되었을 때 NavigationBar 역할할 View
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewBackButtonOutlet: UIButton!
    @IBOutlet weak var navigationViewLogoTitleButtonOutlet: UIButton!
    @IBOutlet weak var navigationViewShareButtonOutlet: UIButton!
    @IBOutlet weak var navigationViewFavoriteButtonOutlet: UIButton!
    var isPresentedBySearchVC:Bool = false
    
    //타이틀뷰
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var tagTextLabel: UILabel!
    @IBOutlet weak var hiddenTitleTextLabel: UILabel!
    
    //타이틀뷰 높이 조정하는 부분
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    let maxHeaderHeight:CGFloat = 126
    let minHeaderHeight:CGFloat = 44
    var previousScrollOffset:CGFloat = 0
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    //테이블뷰
    @IBOutlet weak var detailTableView: UITableView!
    
    //테이블뷰 헤더
    @IBOutlet weak var summaryTextLabel: UILabel!
    @IBOutlet weak var characterSelectSegmentedControl: UISegmentedControl!
    
    //테이블뷰 풋터
    @IBOutlet weak var mailingCharacterImageView: UIImageView!
    @IBOutlet weak var mailingCharacterTextLabel: UILabel!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 바 UI 설정
        self.navigationBarLogoButtonOutlet.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackButton")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackButton")
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //SearchVC을 통해 Present 되었을 때 NavigationBar 역할할 View 설정
        if self.isPresentedBySearchVC == true {
            self.navigationView.isHidden = false
            self.navigationViewLogoTitleButtonOutlet.isUserInteractionEnabled = false
        }else{
            self.navigationView.isHidden = true
        }
        
        //테이블뷰 백그라운드 이미지
        let tableViewBackgroundImage:UIImage = #imageLiteral(resourceName: "background")
        let imageView:UIImageView = UIImageView(image: tableViewBackgroundImage)
        self.detailTableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //셀라인 삭제
        self.detailTableView.separatorStyle = .none
        
        //노티: 캐릭터선택VC에서 어떤 캐릭터를 선택하냐에 따라서, 해당 캐릭터의 설명이 우선적으로 나올 수 있도록 SegmentController를 조정하는 역할을 할 것입니다.
        NotificationCenter.default.addObserver(self, selector: #selector(BY_DetailViewController.callNotiForCharacter(_:)), name: Notification.Name("characterSelected"), object: nil)
        
        //데이터 핸들링
        guard let realQuestionID:Int = self.questionID else {return print("QuestionID가 없습니다.")}
        self.loadData(from: realQuestionID)
        self.loadLikeData(questionID: realQuestionID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        updateHeader()
        
        self.detailTableView.register(UINib.init(nibName: "BY_DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        awakeFromNib()
        
        guard let selectedCharacter:String = UserDefaults.standard.object(forKey: "SelectedCharacter") as? String else {
            let characterChoiceViewController:BY_CharacterChoiceViewController = storyboard?.instantiateViewController(withIdentifier: "CharacterChoiceViewController") as! BY_CharacterChoiceViewController
            present(characterChoiceViewController, animated: true, completion: nil)
            return
        }
        selectSeugeForCharacter(nameOf: selectedCharacter)
        
        guard let realQuestionID:Int = self.questionID else {return print("QuestionID가 없습니다.")}
        self.loadAnswer(from: realQuestionID)
        
        self.detailTableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("뷰윌레이아웃/ 퀘스천아이디 \(self.questionID)")
        if self.byAnswer.count == 0 || self.smAnswer.count == 0 || self.jsAnswer.count == 0 {
            guard let realQuestionID:Int = self.questionID else {return print("QuestionID가 없습니다.")}
            loadAnswer(from: realQuestionID)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = self.detailTableView.tableHeaderView else {return}
        
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
        }
        
        self.detailTableView.tableHeaderView = headerView
        self.detailTableView.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    @IBAction func characterSelectSegmentControlAction(_ sender: UISegmentedControl) {
        
        self.characterSelectSegmentedControl.titleForSegment(at: 0) == "보영"
        self.characterSelectSegmentedControl.titleForSegment(at: 1) == "선미"
        self.characterSelectSegmentedControl.titleForSegment(at: 2) == "재성"
        
        switch self.characterSelectSegmentedControl.selectedSegmentIndex {
        case 0:
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "BYFace")
            self.mailingCharacterTextLabel.text = "보영에게\n메일링"
            Analytics.logEvent("BY_Tapped", parameters: ["id":"보영"])
        case 1:
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "SMFace")
            self.mailingCharacterTextLabel.text = "선미에게\n메일링"
            Analytics.logEvent("SM_Tapped", parameters: ["id":"선미"])
        case 2:
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "JSFace")
            self.mailingCharacterTextLabel.text = "재성에게\n메일링"
            Analytics.logEvent("JS_Tapped", parameters: ["id":"재성"])
        default:
            break
        }
        
        self.detailTableView.reloadData()
        
    }
    
    //TODO: (재성님!)여기에 메일/구글링/네이버링에 대한 각각의 액션을 구현해주세요.
    @IBAction func mailingButtonAction(_ sender: UIButton) {
        print("메일 버튼이 눌렸습니다")
        switch self.characterSelectSegmentedControl.selectedSegmentIndex {
        case 0:
            let byEmail:String = "fimuxd@gmail.com"
            sendEmailTo(emailAddress: byEmail)
        case 1:
            let smEmail:String = "jemma3136@gmail.com"
            sendEmailTo(emailAddress: smEmail)
        case 2:
            let jsEmail:String = "blackturtle2@gmail.com"
            sendEmailTo(emailAddress: jsEmail)
        default:
            break
        }
        
    }
    //TODO:- 구글만 공백을 허용하지않는것인지? 우리는 타이틀기준 검색을 할것인지 tag기준 검색을 할것인지?
    @IBAction func googlingButtonAction(_ sender: UIButton) {
        let keyword:String = "생명주기" //키워드는 공백을 허용하지 않습니다.
        guard let realKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return } // 한글 키워드를 그냥 넣으면, URL로 인코딩을 하지 못해서 웹뷰로 연결되지 않습니다.
        
        openSafariViewOf(url: "https://www.google.co.kr/search?q=swift+\(realKeyword)")
        
    }
    
    @IBAction func naveringButtonAction(_ sender: UIButton) {
        let keyword:String = "생명주기"
        guard let realKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        openSafariViewOf(url: "http://search.naver.com/search.naver?query=swift+\(realKeyword)")
    }
    
    
    //TODO: (재성님!)여기에 공유에 대한 기능을 구현해주세요
    //이부분도 공유하는내용을 어떻게쓸지 고민..........
    @IBAction func shareButtonAction(_ sender: UIButton) {
        let text = "Hello Swift"
        shareTextOf(text: text)
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        self.likeButtonAction()
    }
    
    
    //SearchVC을 통해 Present 되었을 때 네비게이션 바 역할을 할 뷰상의 버튼 설정
    //--Back Button
    @IBAction func navigationViewBackButtonAction(_ sender: UIButton) {
        
        //네비게이션 효과
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    //--Share Button
    //TODO: (재성님!)여기에 공유에 대한 기능을 구현해주세요 / 기존 NavigationBar 상의 버튼에 구현했던 것과 동일
    @IBAction func navigationViewShareButtonAction(_ sender: UIButton) {
    }
    
    //--Like Button
    @IBAction func navigationViewFavoriteButtonAction(_ sender: UIButton) {
        self.likeButtonAction()
    }
    
    //선택한 캐릭터가 있다면, 해당 캐릭터 Segue가 띄워져 있도록 설정
    func selectSeugeForCharacter(nameOf:String) {
        
        switch nameOf {
        case "보영":
            self.characterSelectSegmentedControl.selectedSegmentIndex = 0
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "BYFace")
            self.mailingCharacterTextLabel.text = "보영에게\n메일링"
        case "선미":
            self.characterSelectSegmentedControl.selectedSegmentIndex = 1
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "SMFace")
            self.mailingCharacterTextLabel.text = "선미에게\n메일링"
        case "재성":
            self.characterSelectSegmentedControl.selectedSegmentIndex = 2
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "JSFace")
            self.mailingCharacterTextLabel.text = "재성에게\n메일링"
        default:
            break
        }
        
        self.detailTableView.reloadData()
    }
    
    //노티피케이션 구현 함수
    func callNotiForCharacter(_ sender:Notification) {
        guard let realSelectedCharacterName:String = sender.object as? String else {return print("선택한 캐릭터가 없습니다. \(sender.object)")}
        self.selectSeugeForCharacter(nameOf: realSelectedCharacterName)
    }
    
    // 데이터 영역
    // BY Func: 좋아요 구현 부분 테스트
    // --- BY: 해당 질문의 좋아요 여부
    func loadLikeData(questionID:Int) {
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let tempLikeDatas = snapshot.value as? [String:[String:Any]] else {
                self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
                return print("못불러옴 \(snapshot.value)")
            }
            
            let filteredLikeData = tempLikeDatas.filter({ (dic:(key: String, value: [String : Any])) -> Bool in
                let questionNumber:Int = dic.value[Constants.like_QuestionId] as! Int
                return questionNumber == questionID
            })
            
            switch filteredLikeData.count {
            case 0:
                self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
                self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
            case 1:
                self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
                self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
            default:
                print("좋아요 이미지 에러: \(filteredLikeData)")
            }
        }, withCancel: { (error) in
            print("좋아요 불러오는 에러입니다", error.localizedDescription)
        })
    }
    
    // --- BY: 좋아요 버튼 액션. 별표(좋아요)를 누를 때마다 데이터 및 UI를 반영하여 나타냅니다.
    func likeButtonAction() {
        guard let realQuestionID = self.questionID else {return}
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount != 0 {
                guard let tempLikeDatas = snapshot.value as? [String:[String:Any]] else {return print("못불러옴 \(snapshot.value)")}
                
                let filteredLikeData = tempLikeDatas.filter({ (dic:(key: String, value: [String : Any])) -> Bool in
                    let questionNumber:Int = dic.value[Constants.like_QuestionId] as! Int
                    return questionNumber == realQuestionID
                })
                
                switch filteredLikeData.count {
                case 0:
                    self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
                    self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
                    Database.database().reference().child(Constants.like).childByAutoId().setValue([Constants.like_QuestionId:realQuestionID,
                                                                                                    Constants.like_User_Id:Auth.auth().currentUser?.uid])
                case 1:
                    self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
                    self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
                    Database.database().reference().child(Constants.like).child(filteredLikeData[0].key).setValue(nil)
                default:
                    print("좋아요 버튼액션에러: \(filteredLikeData)")
                }
            }else{
                self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
                self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Star_on"), for: .normal)
                Database.database().reference().child(Constants.like).childByAutoId().setValue([Constants.like_QuestionId:realQuestionID,
                                                                                                Constants.like_User_Id:Auth.auth().currentUser?.uid])
            }
        }) { (error) in
            print("좋아요 액션 에러", error.localizedDescription)
        }
    }
    
    func loadData(from question_ID:Int) {
        Database.database().reference().child(Constants.question).child("\(question_ID)").observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? [String:Any],
                let titleValue = data[Constants.question_QuestionTitle] as? String else { return }
            self.titleTextLabel.text = titleValue
            self.hiddenTitleTextLabel.text = titleValue
            guard let tagArray = data[Constants.question_Tag] as? String else { return }
            self.tagTextLabel.text = tagArray
            guard let summaryArray = data[Constants.question_Summary] as? [String] else { return }
            self.summaryTextLabel.text = "\(summaryArray[0])\n\(summaryArray[1])\n\(summaryArray[2])"
            
            self.detailTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadAnswer(from question_ID:Int) {
        Database.database().reference().child(Constants.question).child("\(question_ID)").child(Constants.question_BYAnswer).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let byAnswerArray = snapshot.value as? [[String:String]] else { return }
            self.byAnswer = byAnswerArray
            self.detailTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        Database.database().reference().child(Constants.question).child("\(question_ID)").child(Constants.question_JSAnswer).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let jsAnswerArray = snapshot.value as? [[String:String]] else { return }
            self.jsAnswer = jsAnswerArray
            self.detailTableView.reloadData()
        }) { (error) in
            print("error: ",error.localizedDescription)
        }
        Database.database().reference().child(Constants.question).child("\(question_ID)").child(Constants.question_SMAnswer).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let smAnswerArray = snapshot.value as? [[String:String]] else { return }
            self.smAnswer = smAnswerArray
            self.detailTableView.reloadData()
        }) { (error) in
            print("error: ",error.localizedDescription)
        }
    }
    
}


//테이블뷰 DataSource 설정 부분
extension BY_DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.characterSelectSegmentedControl.selectedSegmentIndex {
        case 0: //"보영 선택시"
            print("보영 \(self.byAnswer.count)")
            return self.byAnswer.count
        case 1: //"선미 선택시"
            print("선미 \(self.smAnswer.count)")
            return self.smAnswer.count
        case 2: //"재성 선택시"
            print("재성 \(self.jsAnswer.count)")
            return self.jsAnswer.count
        default:
            print("값 없음")
            return self.byAnswer.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BY_DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! BY_DetailTableViewCell
        
        cell.selectionStyle = .none
        
        //선택된 세그에 따라 이미지 변경
        self.characterSelectSegmentedControl.titleForSegment(at: 0) == "보영"
        self.characterSelectSegmentedControl.titleForSegment(at: 1) == "선미"
        self.characterSelectSegmentedControl.titleForSegment(at: 2) == "재성"
        
        switch self.characterSelectSegmentedControl.selectedSegmentIndex {

        case 0:
            cell.characterIconImage.image = #imageLiteral(resourceName: "BYFace")
            
            if byAnswer[indexPath.row][Constants.question_AnswerType] == Constants.answerType_TEXT {
                cell.explainBubbleImage.image = nil
                cell.explainBubbleText.isHidden = false
                cell.explainBubbleText.text = byAnswer[indexPath.row][Constants.question_AnswerContents]
            }else{
                cell.explainBubbleText.isHidden = true
                guard let imageURL = URL(string: byAnswer[indexPath.row][Constants.question_AnswerContents]!) else { return cell }
                cell.explainBubbleImage.kf.indicatorType = .activity
                cell.explainBubbleImage.kf.setImage(with:imageURL, placeholder:#imageLiteral(resourceName: "defaultImg"), completionHandler: {(image, error, cacheType, imageUrl) in
                    cell.reloadInputViews()
                })
                
            }
            
        case 1:
            cell.characterIconImage.image = #imageLiteral(resourceName: "SMFace")
            if smAnswer[indexPath.row][Constants.question_AnswerType] == Constants.answerType_TEXT {
                cell.explainBubbleText.text = smAnswer[indexPath.row][Constants.question_AnswerContents]
                cell.explainBubbleImage.image = nil
                cell.explainBubbleText.isHidden = false
            }else{
                cell.explainBubbleText.isHidden = true
                guard let imageURL = URL(string: smAnswer[indexPath.row][Constants.question_AnswerContents]!) else { print("안되여?"); return cell}
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                cell.explainBubbleImage.kf.indicatorType = .activity
                cell.explainBubbleImage.kf.setImage(with:imageURL, placeholder:#imageLiteral(resourceName: "defaultImg"), options:[.processor(processor)], completionHandler: {(image, error, cacheType, imageUrl) in
                    
                })
            }
        case 2:
            cell.characterIconImage.image = #imageLiteral(resourceName: "JSFace")
            if jsAnswer[indexPath.row][Constants.question_AnswerType] == Constants.answerType_TEXT {
                cell.explainBubbleText.text = jsAnswer[indexPath.row][Constants.question_AnswerContents]
                cell.explainBubbleImage.image = nil
                cell.explainBubbleText.isHidden = false
            }else{
                cell.explainBubbleText.isHidden = true
                guard let imageURL = URL(string: jsAnswer[indexPath.row][Constants.question_AnswerContents]!) else { print("안되여?"); return cell}
                cell.explainBubbleImage.kf.indicatorType = .activity
                cell.explainBubbleImage.kf.setImage(with:imageURL, placeholder:#imageLiteral(resourceName: "defaultImg"), completionHandler: {(image, error, cacheType, imageUrl) in
                    
                })
            }
        default:
            break
        }
        
        return cell
    }
    
}

//헤더 높이 조절을 위한 TableView Delegate 설정 부분
extension BY_DetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.detailTableView.contentOffset = CGPoint(x: self.detailTableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        self.titleTopConstraint.constant = -openAmount + 10
        self.titleTextLabel.alpha = percentage
        self.tagTextLabel.alpha = percentage
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    //MARK: - 재성님 email
    // MARK: 메일 보내기 function 정의
    // [주의] `MessageUI` import가 필요합니다!
    func sendEmailTo(emailAddress email:String) {
        let userSystemVersion = UIDevice.current.systemVersion // 현재 사용자 iOS 버전
        let userAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String // 현재 사용자 SOS 앱 버전
        
        // 메일 쓰는 뷰컨트롤러 선언
        let mailComposeViewController = configuredMailComposeViewController(emailAddress: email, systemVersion: userSystemVersion, appVersion: userAppVersion!)
        
        //사용자의 아이폰에 메일 주소가 세팅되어 있을 경우에만 mailComposeViewController()를 태웁니다.
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } // else일 경우, iOS 에서 자체적으로 메일 주소를 세팅하라는 메시지를 띄웁니다.
    }
    
    // MARK: 메일 보내는 뷰컨트롤러 속성 세팅
    func configuredMailComposeViewController(emailAddress:String, systemVersion:String, appVersion:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // 메일 보내기 Finish 이후의 액션 정의를 위한 Delegate 초기화.
        
        mailComposerVC.setToRecipients([emailAddress]) // 받는 사람 설정
        mailComposerVC.setSubject("[SOS] 사용자로부터 도착한 편지") // 메일 제목 설정
        mailComposerVC.setMessageBody("* iOS Version: \(systemVersion) / App Version: \(appVersion)\n** 고맙습니다. 무엇이 궁금하신가요? :D", isHTML: false) // 메일 내용 설정
        
        return mailComposerVC
    }
    
    //MARK:- 재성님 웹뷰부분
    // 인앱웹뷰 열기 function 정의
    // `SafariServices`의 import가 필요합니다.
    func openSafariViewOf(url:String) {
        guard let realURL = URL(string: url) else { return }
        
        // iOS 9부터 지원하는 `SFSafariViewController`를 이용합니다.
        let safariViewController = SFSafariViewController(url: realURL)
        safariViewController.delegate = self // 사파리 뷰에서 `Done` 버튼을 눌렀을 때의 액션 정의를 위한 Delegate 초기화입니다.
        self.present(safariViewController, animated: true, completion: nil)
    }

    // MARK: 텍스트 공유 기능 function 정의
    func shareTextOf(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil) // 액티비티 뷰 컨트롤러 설정
        activityVC.popoverPresentationController?.sourceView = self.view // 아이패드에서 작동하도록 pop over로 설정
        activityVC.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll ] // 제외 타입 설정
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
// MARK: Extension - MFMailComposeViewControllerDelegate
extension BY_DetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension BY_DetailViewController: SFSafariViewControllerDelegate {
    
    // SFSafariViewController에서 Done 버튼을 눌렀을 때의 액션을 정의합니다.
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
