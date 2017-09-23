//
//  SM_MainTableViewController.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 21..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit
import Firebase

class SM_MainTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var questionCount:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewTestCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        //질문 갯수 받아오기
        Database.database().reference().child(Constants.question).observeSingleEvent(of: .value, with: { (dataSnapShot) in
            self.questionCount = Int(dataSnapShot.childrenCount)
            print("===========================Count:",self.questionCount)
            self.tableView.reloadData()
        }) { (error) in
            print("===========================error!!!!!!!", error.localizedDescription)
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewTestCell", for: indexPath) as! MainTableViewCell
        cell.getQuestionData(indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView:SM_BubbleTableViewController = storyboard?.instantiateViewController(withIdentifier: "BubbleTableViewController") as! SM_BubbleTableViewController
        detailView.questionID = indexPath.row
        self.navigationController?.pushViewController(detailView, animated: true)
    }
   
}
