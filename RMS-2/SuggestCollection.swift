//
//  SuggestCollection.swift
//  RMS-2
//
//  Created by Pondz on 1/26/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import Font_Awesome_Swift

@objc protocol SuggestMenuDelegate {
    @objc optional func didSelectedMunu(at index : Int)
}

class SuggestCollection: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var delegate : SuggestMenuDelegate?
    let menuList = ["Recomend","Nearby","Facebook","Twitter","Apple"]
    var xPositionOfCell : Array<Int> = []
    
    lazy var whiteView: UIView = {
        let size = CGSize.init(width: (self.width * 0.25), height: 5)
        let origin = CGPoint.init(x: 8, y: self.menuCollection.frame.height - 5)
        let vw = UIView.init(frame: CGRect.init(origin: origin, size: size))
        vw.backgroundColor = .white
        return vw
    }()
    
    lazy var menuCollection: UICollectionView = {
        let size = CGSize.init(width: self.frame.width, height: self.frame.height - 5)
        let origin = CGPoint.init(x: 0, y: 0)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset.left = 8
        layout.sectionInset.right = 8
        let cv = UICollectionView.init(frame: CGRect.init(origin: origin, size: size), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Color.grey.lighten1
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        menuCollection.register(SuggestCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        self.addSubview(menuCollection)
        menuCollection.addSubview(whiteView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SuggestCollectionCell
        cell.configureCell(title: menuList[indexPath.row])
        cell.frame.origin.y = 4
        if(!xPositionOfCell.contains(Int(cell.frame.origin.x))) { xPositionOfCell.append(Int(cell.frame.origin.x)) }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.width * 0.25, height: collectionView.frame.height - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            cell?.transform = .identity
        }, completion: nil)
        delegate?.didSelectedMunu!(at: indexPath.row)
    }
    
    func configureWhiteView(index : Int){
        let indexPath = IndexPath.init(row: index, section: 0)
        menuCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        _ = menuCollection.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {
            self.whiteView.frame.origin.x = CGFloat(self.xPositionOfCell[index])
        }, completion: nil)
    }
}

class SuggestCollectionCell: UICollectionViewCell {
    
    lazy var titleLb: UILabel = {
        let size = CGSize.init(width: self.frame.width, height: self.frame.height * 0.2)
        let origin = CGPoint.init(x: 0, y: self.frame.height * 0.8)
        let lb = UILabel.init(frame: CGRect.init(origin: origin, size: size))
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let size = CGSize.init(width: self.frame.width, height: self.frame.height * 0.8)
        let origin = CGPoint.init(x: 0, y: 0)
        let iv = UIImageView.init(frame: CGRect.init(origin: origin, size: size))
        iv.layer.cornerRadius = size.height / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    func configureCell(title : String){
        self.backgroundColor = Color.lightBlue.base
        titleLb.text = title
        self.cornerRadius = 8
        self.addSubview(titleLb)
        configureImageView(title: title)
    }
    
    private func configureImageView(title : String){
        if(title == "Facebook"){imageView.setFAIconWithName(icon: FAType.FAFacebook, textColor: .white)}
        else if(title == "Nearby"){imageView.setFAIconWithName(icon: FAType.FALocationArrow, textColor: .white)}
        else if(title == "Recomend"){imageView.setFAIconWithName(icon: FAType.FAThumbsUp, textColor: .white)}
        else if(title == "Twitter"){imageView.setFAIconWithName(icon: FAType.FATwitter, textColor: .white)}
        else if(title == "Apple"){imageView.setFAIconWithName(icon: FAType.FAApple, textColor: .white)}
        self.addSubview(imageView)
    }
    
}
