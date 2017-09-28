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
    //MARK:-         Functions                 //
    /*******************************************/
    func updateSearchResults(for searchController: UISearchController) {
        
        guard searchController.isActive else { return }
        
        filterString = searchController.searchBar.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(self.searchTableView, didSelectRowAt: indexPath)
        
        let nextViewController:BY_DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! BY_DetailViewController
        nextViewController.questionID = indexPath.row //나중에 수정해야됨
        nextViewController.isPresentedBySearchVC = true
        
        //Present를 Navigation Push(show) 처럼 보이게 설정
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(nextViewController, animated: false, completion: nil)
    }
    
    
    /*******************************************/
    //MARK:-         Functions                 //
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
    
    
}
