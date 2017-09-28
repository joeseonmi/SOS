//
//  BY_DetailViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_DetailViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    var questionID:Int?
    var byAnswer:[[String:String]] = []
	var jsAnswer:[[String:String]] = []
    var smAnswer:[[String:String]] = []
    
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
        

        self.loadData(from: questionID!)
        self.loadBYAnswer(from: questionID!)
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
        NotificationCenter.default.addObserver(self, selector: #selector(BY_DetailViewController.callNoti(_:)), name: Notification.Name("characterSelected"), object: nil)
        
        
        print("이 디테일뷰는 \(self.questionID) 번째 질문입니다.")

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("==================\n\(byAnswer)\n===============")
        print("==================ㅇㅇ\(byAnswer[0][Constants.question_AnswerContents])ㅇㅇ===================")
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
        case 1:
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "SMFace")
            self.mailingCharacterTextLabel.text = "선미에게\n메일링"
        case 2:
            self.mailingCharacterImageView.image = #imageLiteral(resourceName: "JSFace")
            self.mailingCharacterTextLabel.text = "재성에게\n메일링"
        default:
            break
        }
        
        self.detailTableView.reloadData()
        
    }
    
    //TODO: (재성님!)여기에 메일/구글링/네이버링에 대한 각각의 액션을 구현해주세요.
    @IBAction func mailingButtonAction(_ sender: UIButton) {
        print("메일 버튼이 눌렸습니다")
    }
    
    @IBAction func googlingButtonAction(_ sender: UIButton) {
        print("구글 버튼이 눌렸습니다")
    }
    
    @IBAction func naveringButtonAction(_ sender: UIButton) {
        print("네이버 버튼이 눌렸습니다")
    }
    
    
    //TODO: (재성님!)여기에 공유에 대한 기능을 구현해주세요
    @IBAction func shareButtonAction(_ sender: UIButton) {
    }
    
    //TODO: (선미님!)여기에 즐겨찾기에 대한 기능을 구현해주세요
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        guard let realFavoriteButtonImage = self.favoriteButtonOutlet.image(for: .normal) else {return}
        
        switch realFavoriteButtonImage {
        case #imageLiteral(resourceName: "Like_off"): self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "likeCountIcon"), for: .normal)
        case #imageLiteral(resourceName: "likeCountIcon"): self.favoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
        default:
            break
        }
        
        likeBtnAction()
    }

    
    //SearchVC을 통해 Present 되었을 때 네비게이션 바 역할을 할 뷰상의 버튼 설정
    //--Back Button
    @IBAction func navigationViewBackButtonAction(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    //--Share Button
    //TODO: (재성님!)여기에 공유에 대한 기능을 구현해주세요 / 기존 NavigationBar 상의 버튼에 구현했던 것과 동일
    @IBAction func navigationViewShareButtonAction(_ sender: UIButton) {
    }
    
    //--Like Button
    //TODO: (선미님!)여기에 즐겨찾기에 대한 기능을 구현해주세요 / 기존 NavigationBar 상의 버튼에 구현했던 것과 동일 + Firebase Database와 연동되어야 함
    @IBAction func navigationViewFavoriteButtonAction(_ sender: UIButton) {
        guard let realFavoriteButtonImage = self.navigationViewFavoriteButtonOutlet.image(for: .normal) else {return}
        
        switch realFavoriteButtonImage {
        case #imageLiteral(resourceName: "Like_off"): self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "likeCountIcon"), for: .normal)
        case #imageLiteral(resourceName: "likeCountIcon"): self.navigationViewFavoriteButtonOutlet.setImage(#imageLiteral(resourceName: "Like_off"), for: .normal)
        default:
            break
        }
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
            print("캐릭터를 선택해주세요")
            self.characterSelectSegmentedControl.selectedSegmentIndex = 0
        }
        
        self.detailTableView.reloadData()
    }
    
    //노티피케이션 구현 함수
    func callNoti(_ sender:Notification) {
        guard let realSelectedCharacterName:String = sender.object as? String else {return}
        self.selectSeugeForCharacter(nameOf: realSelectedCharacterName)
    }
    
}


//테이블뷰 DataSource 설정 부분
extension BY_DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return byAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BY_DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! BY_DetailTableViewCell
        cell.explainBubbleText.text = byAnswer[indexPath.row][Constants.question_AnswerContents]
        cell.selectionStyle = .none
        
        //선택된 세그에 따라 이미지 변경
        self.characterSelectSegmentedControl.titleForSegment(at: 0) == "보영"
        self.characterSelectSegmentedControl.titleForSegment(at: 1) == "선미"
        self.characterSelectSegmentedControl.titleForSegment(at: 2) == "재성"
        
        switch self.characterSelectSegmentedControl.selectedSegmentIndex {
        case 0:
            cell.characterIconImage.image = #imageLiteral(resourceName: "BYFace")
            cell.explainBubbleImage.isHidden = true
            
        case 1:
            cell.characterIconImage.image = #imageLiteral(resourceName: "SMFace")
        case 2:
            cell.characterIconImage.image = #imageLiteral(resourceName: "JSFace")
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
    
    // SM Func
    func likeBtnAction() {

        guard let realQuestionID:Int = self.questionID else { return print("가드렛걸림")}
        
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let likeData = snapshot.value as? [String:[String:Any]] else { return }
            print("데이터가있슴니돠아아아아ㅏ==================:", likeData)
            let filteredData = likeData.filter({ (dic:(key:String, value:[String:Any])) -> Bool in
                var filteredQuestionID = dic.value[Constants.like_QuestionId]
                return realQuestionID == filteredQuestionID as! Int
            })
            print("필터된데이터!!!!!!!!!!!!!!:", filteredData)
            switch filteredData.count {
            case 0 : Database.database().reference().child(Constants.like).childByAutoId().setValue([Constants.like_QuestionId:realQuestionID,Constants.like_User_Id:Auth.auth().currentUser?.uid])
//            self.getLikeCount(question:realQuestionID)
            DataCenter.standard.favoriteQuestions.append(realQuestionID)
            print("좋아요리스트!!!!!!!!!!!!!!!!",DataCenter.standard.favoriteQuestions)
            case 1 :
                Database.database().reference().child(Constants.like).child(filteredData[0].key).setValue(nil)
//                self.getLikeCount(question: realQuestionID)
                if let deleteIndex:Int = DataCenter.standard.favoriteQuestions.index(of: realQuestionID) {
                    DataCenter.standard.favoriteQuestions.remove(at: deleteIndex)
                }
                print("좋아요리스트!!!!!!!!!!!!!!!!",DataCenter.standard.favoriteQuestions)
            default:
                print("error!!!!!!!!!!!!!!")
            }
            
        }) { (error) in
            print("좋아요 error: \(error.localizedDescription)")
        }
    }
    func loadData(from question_ID:Int) {
        Database.database().reference().child(Constants.question).child("\(question_ID)").observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            self.titleTextLabel.text = data[Constants.question_QuestionTitle] as! String
            self.hiddenTitleTextLabel.text = data[Constants.question_QuestionTitle] as! String
            guard let tagArray = data[Constants.question_Tag] as? String else { return }
            self.tagTextLabel.text = tagArray
            guard let summaryArray = data[Constants.question_Summary] as? [String] else { return }
            self.summaryTextLabel.text = "\(summaryArray[0])\n\(summaryArray[1])\n\(summaryArray[2])"
     
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func loadBYAnswer(from question_ID:Int) {
        Database.database().reference().child(Constants.question).child("\(question_ID)").child(Constants.question_BYAnswer).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let byAnswerArray = snapshot.value as? [[String:String]] else { return }
            self.byAnswer = byAnswerArray
            self.detailTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
