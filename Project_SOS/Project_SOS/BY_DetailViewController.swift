//
//  BY_DetailViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_DetailViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    //네비게이션 바
    @IBOutlet weak var navigationBarLogoButtonOutlet: UIButton!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
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
        return 3 //TODO: 추후에 답변 개수만큼 출력하도록 할 것
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
            // cell.explainBubbleText.text =
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
}
