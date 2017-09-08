//
//  BY_DetailViewController.swift
//  Project_SOS
//
//  Created by Bo-Young PARK on 7/9/2017.
//  Copyright © 2017 joe. All rights reserved.
//

import UIKit

class BY_DetailViewController: UIViewController {
    
    /*******************************************/
    //MARK:-        Properties                 //
    /*******************************************/
    
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var contentsTableView: UITableView!
    @IBOutlet weak var goToAdditionalInfoCollectionView: UICollectionView!
    
    @IBOutlet weak var selectCharacterSegmentControl: UISegmentedControl!
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
    @IBAction func selectCharacterSegmentControlAction(_ sender: UISegmentedControl) {
    }
    
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.summaryTableView.register(UINib.init(nibName: "BY_DetailSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailSummaryTableViewCell")
        self.contentsTableView.register(UINib.init(nibName: "BY_DetailTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTextTableViewCell")
        self.contentsTableView.register(UINib.init(nibName: "BY_DetailImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailImageTableViewCell")
        self.goToAdditionalInfoCollectionView.register(UINib.init(nibName: "BY_DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
        awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedCharacter:String = UserDefaults.standard.object(forKey: "SelectedCharacter") as? String else {
            let characterChoiceViewController:BY_CharacterChoiceViewController = storyboard?.instantiateViewController(withIdentifier: "CharacterChoiceViewController") as! BY_CharacterChoiceViewController
            present(characterChoiceViewController, animated: true, completion: nil)
            return
        }
        
        print(selectedCharacter)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//테이블뷰 설정
extension BY_DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "default_HeaderImage"))
        
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.addSubview(contentView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier == "SummaryTableView" {
            let cell:BY_DetailSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailSummaryTableViewCell", for: indexPath) as! BY_DetailSummaryTableViewCell
            
            return cell
            
        }else{
            let textCell:BY_DetailTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTextTableViewCell", for: indexPath) as! BY_DetailTextTableViewCell
            let imageCell:BY_DetailImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailImageTableViewCell", for: indexPath) as! BY_DetailImageTableViewCell
            
            return textCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.restorationIdentifier == "SummaryTableView" {
            return 105
        }else {
            return 150
        }
    }
    
}

//콜렉션뷰 설정
extension BY_DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BY_DetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! BY_DetailCollectionViewCell
        
        switch indexPath.item {
        case 0:
            cell.imageView.image = #imageLiteral(resourceName: "default_Profile")
            cell.textLabel.text = "고구마에게 메일링"
        case 1:
            cell.imageView.image = #imageLiteral(resourceName: "default_Google")
            cell.textLabel.text = "이 키워드로 구글링"
        case 2:
            cell.imageView.image = #imageLiteral(resourceName: "defailt_Naver")
            cell.textLabel.text = "이 키워드로 네이빙"
        default: cell.imageView.image = #imageLiteral(resourceName: "default_Profile")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 메일링하기
        // 구글링하기
        // 네이빙하기
    }
}
