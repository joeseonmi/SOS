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
    
    @IBOutlet var searchTableView: UITableView!

    func updateSearchResults(for searchController: UISearchController) {
        
        guard searchController.isActive else { return }
        
        filterString = searchController.searchBar.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("Question").observe(.value, with: { (snapshot) in
            guard let questionDatas:[[String:Any]] = snapshot.value as? [[String:Any]] else {return print("데이터 가드에 걸렸네영 \(snapshot.value)")}
            
            let questionTitles = questionDatas.map({ (dic) -> String in
                return dic["Question_Title"] as! String
            })
            
            print("클로저 안 \(questionTitles)")
            
            self.allResults = questionTitles
            
            self.tableView.reloadData()
            self.searchTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
