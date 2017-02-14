//
//  OrderMenu.swift
//  RMS-2
//
//  Created by Pondz on 1/30/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import Font_Awesome_Swift

protocol OrderMenuDelegate {
    func didSelectAtIndex(index : IndexPath)
}

class OrderMenu: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    private let menu = ["menu","order","album","ic_local_offer","feedback"]
    private let title4Navbar = ["Menu List","My Order","Photo","Promotion","Feedback"]
    internal var delegate : OrderMenuDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView.init(frame: CGRect.init(origin: self.frame.origin, size: self.frame.size), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Color.lightBlue.base
        return cv
    }()
    
    private lazy var whiteView: UIView = {
        let origin = CGPoint.init(x: 0, y: self.collectionView.frame.maxY - 5)
        let size = CGSize.init(width: self.frame.width / 5, height: 5)
        let vw = UIView.init(frame: CGRect.init(origin: origin, size: size))
        vw.backgroundColor = .white
        return vw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(OrderMenuCell.self, forCellWithReuseIdentifier: "Cell")
        self.addSubview(collectionView)
        collectionView.addSubview(whiteView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OrderMenuCell
        cell.configureCell(menu: menu[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectAtIndex(index: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.frame.width / 5, height: collectionView.frame.height)
    }
    
    internal func didSelectedIndexPath(indexPath : IndexPath){
        for index in 0...menu.count - 1 {
            let cell = collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as? OrderMenuCell
            cell?.imageView.image = cell?.imageView.image?.tint(with: Color.grey.lighten1)
        }
        let cell = collectionView.cellForItem(at: indexPath) as? OrderMenuCell
        UIView.animate(withDuration: 0.3, animations: {
            self.whiteView.frame.origin.x = (cell?.frame.origin.x)!
            cell?.imageView.image = cell?.imageView.image?.tint(with: .white)
        })
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: title4Navbar[indexPath.row])
    }
}

class OrderMenuCell: UICollectionViewCell {
    
    fileprivate lazy var imageView: UIImageView = {
        let size = CGSize.init(width: self.frame.width - 16, height: self.frame.height - 16)
        let iv = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 8, y: 8), size: size))
        return iv
    }()
    
    fileprivate func configureCell(menu : String){
        self.backgroundColor = Color.lightBlue.base
        imageView.image = UIImage.init(named: menu)?.tint(with: Color.grey.lighten1)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    
    
}
















