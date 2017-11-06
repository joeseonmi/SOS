//
//  BY_SearchResultsViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit
import Firebase

class BY_SearchResultsViewController: BY_MainTableViewController, UISearchResultsUpdating {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    @IBOutlet var searchTableView: UITableView!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child(Constants.question).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? [[String:Any]] else { return }
            let tempArray = data.map({ (dic) -> String in
                return dic[Constants.question_QuestionTitle] as! String
            })
            let tempTagArray = data.map({ (dic) -> String in
                return dic[Constants.question_Tag] as! String
            })
            self.questionTagData = tempTagArray
            self.questionTitleData = tempArray
            
            self.tableView.reloadData()
            //            self.searchTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    func updateSearchResults(for searchController: UISearchController) {
        
        guard searchController.isActive else { return }
        
        filterString = searchController.searchBar.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(self.searchTableView, didSelectRowAt: indexPath)
        
        let nextViewController:BY_DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! BY_DetailViewController
        nextViewController.isPresentedBySearchVC = true
        
        //선택한 셀의 아이디 값을 전달
        let currentCell = tableView.cellForRow(at: indexPath) as! BY_MainTableViewCell
        self.selectedQuestionID = currentCell.questionID!
        nextViewController.questionID = self.selectedQuestionID

        //좋아요 갯수 연동
        currentCell.loadLikeDatafor(questionID: indexPath.row)
        
        //Present를 Navigation Push(show) 처럼 보이게 설정
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)

        present(nextViewController, animated: false, completion: nil)
    }
}
