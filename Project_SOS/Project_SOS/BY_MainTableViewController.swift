//
//  BY_MainTableViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 20/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_MainTableViewController: UITableViewController {
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    var questionTitleData:[String] = []
    var questionTagData:[String] = []
    var selectedQuestionID:Int?
    
    
    //선택한 캐릭터가 있는지 확인
    var selectedCharater:String?
    
    //좋아요한 목록 표시 관련
    var isfavoriteTableView:Bool = false
    var favoriteQuestionIDs:[Int] = []
    
    //검색 관련
    var isSearchBarClicked:Bool = false
    
    lazy var visibleResults:[String] = self.questionTitleData
    
    var filterString:String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleResults = questionTitleData
            }
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                
                visibleResults = questionTitleData.filter { filterPredicate.evaluate(with: $0) }
            }
            
            self.isSearchBarClicked = true
            self.tableView.reloadData()
            
        }
    }
    
    //네비게이션 바
    @IBOutlet weak var navigationBarLogoButtonOutlet: UIButton!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ALL 데이터 가져오기
        Database.database().reference().child(Constants.question).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? [[String:Any]] else { return }
            let tempArray = data.map({ (dic) -> String in
                return dic[Constants.question_QuestionTitle] as! String
            })
            let tempTagArray = data.map({ (dic) -> String in
                return dic[Constants.question_Tag] as! String
            }) 
            let tempIDArray = data.map({ (dic) -> Int in
                return dic[Constants.question_QuestionId] as! Int
            })
            
            self.questionTagData = tempTagArray
            self.questionTitleData = tempArray
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        guard let realNavigationBarLogoButtonOutlet = self.navigationBarLogoButtonOutlet else {return}
        realNavigationBarLogoButtonOutlet.isUserInteractionEnabled = false
        
        //테이블뷰 백그라운드 이미지
        let tableViewBackgroundImage:UIImage = #imageLiteral(resourceName: "background")
        let imageView:UIImageView = UIImageView(image: tableViewBackgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        //셀라인 삭제
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.register(UINib.init(nibName: "BY_MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        awakeFromNib()
        
        
        if UserDefaults.standard.object(forKey: "SelectedCharacter") != nil {
            self.selectedCharater = UserDefaults.standard.object(forKey: "SelectedCharacter") as! String
        }
        
        //FAVORITE 데이터 가져오기
        if Auth.auth().currentUser?.uid != nil {
            Database.database().reference().child(Constants.like).queryOrdered(byChild: Constants.like_User_Id).queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let tempLikeData = snapshot.value as? [String:[String:Any]] else {return}
                let tempUsersLikeData = tempLikeData.map({ (dic) -> Int in
                    let likedQuestionID = dic.value[Constants.like_QuestionId] as! Int
                    return likedQuestionID
                })
                self.favoriteQuestionIDs = tempUsersLikeData.sorted()
            }, withCancel: { (error) in
                print("즐겨찾기 데이터 에러", error.localizedDescription)
            })
        }
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    //Firebase 데이터 가져오는 부분
    func requestFavoriteQuestionDataFor(questionID:Int, completion:@escaping (_ info:[[String:String]]) -> Void) {
        Database.database().reference().child(Constants.question).queryOrdered(byChild: Constants.question_QuestionId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let tempQuestionData = snapshot.value as? [[String:Any]] else {return print("좋아요테스트: 여기서 안됨 \(snapshot.value)")}
            let tempQuestionDic = tempQuestionData.map({ (dic) -> [String:String] in
                var questionTitle:String = dic[Constants.question_QuestionTitle] as! String
                var questionTag:String = dic[Constants.question_Tag] as! String
                return ["QuestionTitle":questionTitle, "QuestionTag":questionTag]
            })
            completion(tempQuestionDic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    //테이블뷰 설정 부분
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearchBarClicked == false {
            if self.isfavoriteTableView {
                return self.favoriteQuestionIDs.count
            }else{
                return self.questionTitleData.count
            }
        }else if self.isSearchBarClicked == true {
            return self.visibleResults.count
        }else{
            print("셀개수에러")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BY_MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! BY_MainTableViewCell
        
        cell.selectionStyle = .none

        
        //ALL 이냐 FAVORITE 냐
        if isfavoriteTableView == false {
            cell.titleQuestionLabel.text = self.questionTitleData[indexPath.row]
            cell.tagLabel?.text = self.questionTagData[indexPath.row]
            cell.loadLikeDatafor(questionID: indexPath.row)
        }else{
            var index:Int = self.favoriteQuestionIDs[indexPath.row]
            self.requestFavoriteQuestionDataFor(questionID: index, completion: { (dic) in
                cell.titleQuestionLabel.text = dic[index]["QuestionTitle"]
                cell.tagLabel?.text = dic[index]["QuestionTag"]
                cell.loadLikeDatafor(questionID: index)
            })
        }
        
        //SearchView냐 아니냐
        if self.isSearchBarClicked == false {
            if self.isfavoriteTableView {
                cell.titleQuestionLabel.text = ""
            }else{
                cell.titleQuestionLabel.text = self.questionTitleData[indexPath.row]
                cell.tagLabel?.text = self.questionTagData[indexPath.row]
            }
        }else if self.isSearchBarClicked == true {
            cell.titleQuestionLabel.text = self.visibleResults[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! BY_MainTableViewCell
        let nextViewController:BY_DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! BY_DetailViewController
        
        if isfavoriteTableView == false {
            self.selectedQuestionID = currentCell.questionID
        }else{
            var index:Int = self.favoriteQuestionIDs[indexPath.row]
            self.selectedQuestionID = index
        }
        
        nextViewController.questionID = self.selectedQuestionID
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
