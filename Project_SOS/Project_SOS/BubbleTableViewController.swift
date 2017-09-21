//
//  BubbleTableViewController.swift
//  Project_SOS
//
//  Created by joe on 2017. 9. 21..
//  Copyright © 2017년 joe. All rights reserved.
//

import UIKit

class BubbleTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var tableview: UITableView!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UINib(nibName: "BubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "BubbleTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
       
    }
    
    /*******************************************/
    //MARK:-        TableView                  //
    /*******************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "BubbleTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        //나중에 데이터 갯수로 변경
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension듯
        //오토메틱으로 정할때 최소높이 정해줘야할듯
        return 200
    }

}

