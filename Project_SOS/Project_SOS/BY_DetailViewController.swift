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
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var characterSelectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    let maxHeaderHeight:CGFloat = 128
    let minHeaderHeight:CGFloat = 44
    
    var previousScrollOffset:CGFloat = 0
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagStackView: UIStackView!
    
    
    /*******************************************/
    //MARK:-        LifeCycle                  //
    /*******************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        //updateHeader()
        
        self.collectionView.register(UINib.init(nibName: "BY_DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
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
    
    
    /*******************************************/
    //MARK:-         Functions                 //
    /*******************************************/
    
  
}


//콜렉션뷰 설정
extension BY_DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BY_DetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! BY_DetailCollectionViewCell
        
        switch indexPath.item {
        case 0:
            cell.imageView.image = #imageLiteral(resourceName: "naver-logo")
            cell.textLabel.text = "고구마에게\n메일링"
        case 1:
            cell.imageView.image = #imageLiteral(resourceName: "naver-logo")
            cell.textLabel.text = "이 키워드로\n구글링"
        case 2:
           cell.imageView.image = #imageLiteral(resourceName: "naver-logo")
            cell.textLabel.text = "이 키워드로\n네이빙"
        default: cell.imageView.image = #imageLiteral(resourceName: "naver-logo")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 80*7/5)
    }
    
    

    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 메일링하기
        // 구글링하기
        // 네이빙하기
    }
}
