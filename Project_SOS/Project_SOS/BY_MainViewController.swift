//
//  BY_MainViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_MainViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedCharater:String?
    
    var isfavoriteTableView:Bool = false
    var favoriteList:[Int] = []
    
    var searchController: UISearchController!
    let allResults = ["메인 질문이 들어갑니다?", "Tag1", "태그2", "Tag3태그삼", "네번째태그호호호"] //TODO: 추후에는 파베를 통해 '질문' 및 '태그' String을 가져오는 어레이로 만들어야 함
    lazy var visibleResults:[String] = self.allResults
    var filterString:String? = nil {
        didSet{
            if filterString == nil || filterString!.isEmpty {
                visibleResults = allResults
            }else{
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                
                visibleResults = allResults.filter {filterPredicate.evaluate(with: $0)}
            }
            self.mainTableView.reloadData()
        }
    }
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.mainTableView.register(UINib.init(nibName: "BY_MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        
        if UserDefaults.standard.object(forKey: "SelectedCharacter") != nil {
            self.selectedCharater = UserDefaults.standard.object(forKey: "SelectedCharacter") as! String
        }
        
        awakeFromNib()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    @IBAction func hamburgerMenuButtonAction(_ sender: UIBarButtonItem) {
        self.hamburgerMenuAlert()
    }
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        self.searchClicked()
    }
    
    @IBAction func sortTableContentsSegmentedControlAction(_ sender: UISegmentedControl) {
        self.selectSegment()
    }
    
    func hamburgerMenuAlert() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let rateAppAction:UIAlertAction = UIAlertAction.init(title: "쏘쓰 앱 평가하기", style: .default, handler: nil)
        let indroduceDevelopersAction:UIAlertAction = UIAlertAction.init(title: "개발자 소개", style: .default, handler: nil)
        let resetCharacterSettingAction:UIAlertAction = UIAlertAction.init(title: "캐릭터 설정 초기화", style: .default) { (alert) in
            UserDefaults.standard.removeObject(forKey: "SelectedCharacter")
            print("선택했던 캐릭터 값이 초기화 되었습니다. 현재 캐릭터 상태값:\(UserDefaults.standard.object(forKey: "SelectedCharacter"))")
        }
        
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(rateAppAction)
        alert.addAction(indroduceDevelopersAction)
        alert.addAction(resetCharacterSettingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func searchClicked() {
        let searchResultsController:BY_SearchResultsViewController = storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! BY_SearchResultsViewController
        
        /* TODO: (보영) 이 부분 CustomCell을 register 하는 과정에서 에러가 발생함. 좀 더 스터디 한 후 보완하겠음
        searchResultsController.updateCustomCell()
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        */
        
        searchController = UISearchController(searchResultsController: searchController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        present(searchController, animated: true, completion: nil)
    }
    
    
    func selectSegment() {
        if self.isfavoriteTableView == true {
            self.isfavoriteTableView = false
        }else{
            self.isfavoriteTableView = true
        }
        self.mainTableView.reloadData()
    }
    
    
}

//테이블 뷰 설정 부분
extension BY_MainViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isfavoriteTableView {
            return self.favoriteList.count //TODO: 추후 좋아요 수에 따라 조정
        }else if !self.isfavoriteTableView {
            return 10 //TODO: 추후 데이터에 따라 조정
        }else if !filterString!.isEmpty {
            return self.visibleResults.count
        }else{
            print("ERROR: 표시할 로우가 없습니다.")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BY_MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! BY_MainTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController:BY_DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! BY_DetailViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

