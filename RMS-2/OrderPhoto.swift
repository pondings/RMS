//
//  OrderPhoto.swift
//  RMS-2
//
//  Created by Pondz on 1/31/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import Alamofire
import SKPhotoBrowser

class OrderPhoto: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    private var imageUrl : [String]! = []
    private var images = [SKPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = Color.grey.lighten1
        configureAlamofire(path: "Menu", dowloadComlete: { result in
            self.imageUrl = result
            self.collectionView?.reloadData()
        })
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrl.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OrderPhotoCell
        let url = imageUrl[indexPath.row]
        let photo = SKPhoto.photoWithImageURL(url)
        photo.shouldCachePhotoURLImage = true
        images.append(photo)
        cell.configureCell(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.width / 2) - 16, height: collectionView.frame.height * 0.2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
    
}

class OrderPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(url : String){
        let urlString = url
        self.cornerRadius = 8
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            DispatchQueue.main.async { self.imageView.image = UIImage.init(data: data!) }
        }.resume()
    }
    
}
