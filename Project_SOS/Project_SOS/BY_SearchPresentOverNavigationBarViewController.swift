//
//  BY_SearchPresentOverNavigationBarViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 20/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_SearchPresentOverNavigationBarViewController: BY_MainTableViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    var searchController: UISearchController!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    
    
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
        
        let rateAppAction:UIAlertAction = UIAlertAction.init(title: "쏘쓰 앱 평가하기", style: .default, handler: nil)
        let indroduceDevelopersAction:UIAlertAction = UIAlertAction.init(title: "개발자 소개", style: .default) { (alert) in
            let characterIntroduceViewController:BY_CharacterIntroduceViewController = self.storyboard?.instantiateViewController(withIdentifier: "CharacterIntroduceViewController") as! BY_CharacterIntroduceViewController
            self.present(characterIntroduceViewController, animated: true, completion: nil)
        }
        let resetCharacterSettingAction:UIAlertAction = UIAlertAction.init(title: "캐릭터 설정 초기화", style: .default) { (alert) in
            UserDefaults.standard.removeObject(forKey: "SelectedCharacter")
            print("선택했던 캐릭터 값이 초기화 되었습니다. 현재 캐릭터 상태값:\(UserDefaults.standard.object(forKey: "SelectedCharacter") ?? "선택된 캐릭터가 없습니다.")")
        }
        
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(rateAppAction)
        alert.addAction(indroduceDevelopersAction)
        alert.addAction(resetCharacterSettingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //세그(전체/좋아요) 선택부분
    func selectSegment() {
        if self.isfavoriteTableView == true {
            self.isfavoriteTableView = false
        }else{
            self.isfavoriteTableView = true
        }
        tableView.reloadData()
    }
}
