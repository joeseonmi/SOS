//
//  BY_SearchResultsViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_SearchResultsViewController: BY_MainViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard searchController.isActive else { return }
        
        filterString = searchController.searchBar.text
    }
    
    func updateCustomCell() {
        self.searchResultsTableView.register(UINib.init(nibName: "BY_MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        awakeFromNib()
    }
}
