//
//  File.swift
//  RMS-2
//
//  Created by Pondz on 2/9/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

extension ActionSheetTitle {
    
    internal func configureMainOrder(){
        if(style == .MainOrder){
            self.addSubview(collectionView)
            collectionView.snp.makeConstraints({ (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(self.snp.height).offset( -self.frame.height * 0.1)
            })
            self.addSubview(submitButton)
            submitButton.snp.makeConstraints({ (make) in
                make.top.equalTo(collectionView.snp.bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(self.frame.height * 0.05)
            })
            self.addSubview(cancelButton)
            cancelButton.snp.makeConstraints({ (make) in
                make.top.equalTo(submitButton.snp.bottom)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            })
        }
    }
    
    
    func submitOrderClicked(){
        self.delegate?.confirmButtonClicked!()
    }
    
    func cancelOrderClicked(){
        self.delegate?.cancelButtonClicked!()
    }
    
    func userCancelOrder(){
        firPath.removeValue()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionSheetCollectionViewCell
        let order = orderList[indexPath.row]
        cell.configureCell(Order: Menus.init(ordDict: order))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 20, height: collectionView.frame.height * 0.25)
    }
    
    func configureFirebase(){
        if(isSelfInit) {return}
        firPath.observe(.childAdded, with: { [weak self] (snap) -> Void in
            guard
                let strongSelf = self,
                let data = snap.value as? Dictionary<String,AnyObject>
            else {return}
            strongSelf.orderList.append(data)
            strongSelf.collectionView.reloadData()
        })
        firPath.observe(.childChanged, with: { [weak self] (snap) -> Void in
            guard
                let strongSelf = self,
                let data = snap.value as? Dictionary<String,AnyObject>
            else {return}
            let changeData = Menus.init(ordDict: data)
            for (index,element) in strongSelf.orderList.enumerated() {
                let currentElement = Menus.init(ordDict: element)
                if(changeData.title! == currentElement.title!){
                    strongSelf.orderList[index] = data
                    strongSelf.collectionView.reloadData()
                }
            }
        })
        firPath.observe(.childRemoved, with: {[weak self] (snap) -> Void in
            guard
                let strongSelf = self ,
                let data = snap.value as? Dictionary<String,AnyObject>
            else {return}
            let removeData = Menus.init(ordDict: data)
            for (index,element) in strongSelf.orderList.enumerated(){
                let currentElement = Menus.init(ordDict: element)
                if(removeData.title! == currentElement.title!){
                    strongSelf.orderList.remove(at: index)
                    strongSelf.collectionView.reloadData()
                }
            }
        })
        isSelfInit = true
    }
}
