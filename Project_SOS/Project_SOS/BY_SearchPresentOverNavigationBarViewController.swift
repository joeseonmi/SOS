//
//  BY_SearchPresentOverNavigationBarViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 20/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_SearchPresentOverNavigationBarViewController: BY_MainTableViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    var searchController: UISearchController!
    @IBOutlet weak var sortTableContentsSegmentedControlOutlet: UISegmentedControl!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        self.sortTableContentsSegmentedControlOutlet.titleForSegment(at: 0) == "All"
        self.sortTableContentsSegmentedControlOutlet.selectedSegmentIndex = 0
        self.isfavoriteTableView = false
        
        self.tableView.reloadData()
    }
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    @IBAction func searchButtonClicked(_ button: UIBarButtonItem) {
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)

        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! BY_SearchResultsViewController
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        searchResultsController.isSearchBarClicked = true
        
        
        present(searchController, animated: true, completion: nil)
        
        self.searchController.delegate = self
        
    }
    
    //햄버거 메뉴부분
    @IBAction func hamburgerMenuButtonAction(_ sender: UIBarButtonItem) {
        self.hamburgerMenuAlert()
    }
    
    @IBAction func sortTableContentsSegmentedControlAction(_ sender: UISegmentedControl) {
        self.selectSegment()
    }
    
    func hamburgerMenuAlert() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        let rateAppAction:UIAlertAction = UIAlertAction.init(title: "쏘쓰 앱 평가하기", style: .default) { (alert) in
            self.rateSOS() //TODO:- (보영) 재성님, 여기에 '쏘쓰 앱 평가하기' 에 대한 함수명을 기입해주세요.
        }
        let indroduceDevelopersAction:UIAlertAction = UIAlertAction.init(title: "개발자 소개", style: .default) { (alert) in
            self.segueToCharacterIntroduceView()
        }
        
        let resetFavoriteSettingAction:UIAlertAction = UIAlertAction.init(title: "즐겨찾기 초기화", style: .default) { (alert) in
            self.resetFavoriteDatas()
            self.informFavoriteSettingReset()
        }
        
        let resetCharacterSettingAction:UIAlertAction = UIAlertAction.init(title: "캐릭터 설정 초기화", style: .default) { (alert) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            UserDefaults.standard.removeObject(forKey: "SelectedCharacter")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.informCharacterSettingReset()
        }
        
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(rateAppAction)
        alert.addAction(indroduceDevelopersAction)
        alert.addAction(resetFavoriteSettingAction)
        alert.addAction(resetCharacterSettingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //세그(전체/좋아요) 선택부분
    func selectSegment() {
        if self.sortTableContentsSegmentedControlOutlet.selectedSegmentIndex == 0 {
            self.isfavoriteTableView = false
        }else{
            self.isfavoriteTableView = true
        }
        tableView.reloadData()
    }
    
    //TODO:- (보영) 재성님, 여기에 '쏘쓰 앱 평가하기' 에 대한 기능을 구현해주세요.
    func rateSOS() {
        //함수명은 가제입니다. 자유롭게 구현해주세요.
    }
    
    //보영: 햄버거메뉴_'개발자소개' 액션
    func segueToCharacterIntroduceView() {
        let characterIntroduceViewController:BY_CharacterIntroduceViewController = self.storyboard?.instantiateViewController(withIdentifier: "CharacterIntroduceViewController") as! BY_CharacterIntroduceViewController
        self.present(characterIntroduceViewController, animated: true, completion: nil)
    }
    
    //보영: 햄버거메뉴_'즐겨찾기 초기화' 액션
    func resetFavoriteDatas() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let tempLikeData = snapshot.value as? [String:[String:Any]] else {return}
            let tempLikeKeyString = tempLikeData.map({ (dic) -> String in
                return dic.key
            })
            
            for index in 0..<tempLikeKeyString.count {
                Database.database().reference().child(Constants.like).child(tempLikeKeyString[index]).setValue(nil)
            }
            
            self.favoriteQuestionIDs = []
            self.tableView.reloadData()
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func informFavoriteSettingReset() {
        let alert = UIAlertController.init(title: "알림", message: "모든 즐겨찾기가 초기화 되었습니다.", preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        let informFavoriteSettingResetAlertAction:UIAlertAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(informFavoriteSettingResetAlertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //보영: 햄버거메뉴_'캐릭터 설정 초기화' 액션
    func informCharacterSettingReset() {
        let alert = UIAlertController.init(title: "알림", message: "선택하신 캐릭터 설정이 초기화 되었습니다.", preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        let informFavoriteSettingResetAlertAction:UIAlertAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(informFavoriteSettingResetAlertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension BY_SearchPresentOverNavigationBarViewController:UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        requestFavoriateQuestionData()
        tableView.reloadData()
    }
}
