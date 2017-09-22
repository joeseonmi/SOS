//
//  BY_MainTableViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 20/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_MainTableViewController: UITableViewController {
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    //선택한 캐릭터가 있는지 확인
    var selectedCharater:String?
    
    //좋아요한 목록 표시 관련
    var isfavoriteTableView:Bool = false
    var favoriteList:[Int] = []
    
    //검색 관련
    var isSearchBarClicked:Bool = false
    
    let allResults = ["태그", "Tag"]
    
    lazy var visibleResults:[String] = self.allResults
    
    var filterString:String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleResults = allResults
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                
                visibleResults = allResults.filter { filterPredicate.evaluate(with: $0) }
            }
            
            self.isSearchBarClicked = true
            tableView.reloadData()
            print("필터스트링 디드셋됨 \(visibleResults)")
        }
    }
    
    //네비게이션 바
    @IBOutlet weak var navigationBarLogoButtonOutlet: UIButton!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarLogoButtonOutlet.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.register(UINib.init(nibName: "BY_MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        awakeFromNib()
        
        if UserDefaults.standard.object(forKey: "SelectedCharacter") != nil {
            self.selectedCharater = UserDefaults.standard.object(forKey: "SelectedCharacter") as! String
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    //테이블뷰 설정 부분
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if self.isSearchBarClicked == false {
            if self.isfavoriteTableView {
                print("좋아요 개수")
                return self.favoriteList.count //TODO: 추후 좋아요 수에 따라 조정
            }else{
                print("전체 개수")
                return 10 //TODO: 추후 데이터에 따라 조정
            }
        }else{
            print("검색 개수")
            return self.visibleResults.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BY_MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! BY_MainTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController:BY_DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! BY_DetailViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
