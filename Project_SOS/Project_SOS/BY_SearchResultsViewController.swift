//
//  BY_SearchResultsViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_SearchResultsViewController: BY_MainTableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard searchController.isActive else { return }
        
        filterString = searchController.searchBar.text
    }
    
}
