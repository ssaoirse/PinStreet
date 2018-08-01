//
//  PinBoardViewController.swift
//  PinStreet
//
//  Created by Shashi Shaw on 01/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class PinBoardViewController: UICollectionViewController {

    var items = [Photo]()//Photo.allPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set ourselves as the delegate for the Layout delegate.
        if let layout = collectionView?.collectionViewLayout as? PinBoardLayout {
            layout.delegate = self
        }
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        // Initiate request to fetch items.
        fetchPinBoardItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // Fetch the pin board items from server.
    func fetchPinBoardItems() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let pinBoardController = PinBoardController()
        pinBoardController.fetchPinBoardItems(
        success: { [unowned self](pinBoardItems) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.items.append(contentsOf: Photo.allPhotos())
            self.collectionView?.reloadData()
        },
        failure: { (errorMsg) in
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

}



// MARK: - Collection View Delegate.
extension PinBoardViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinBoardItemCell",
                                                      for: indexPath as IndexPath) as! PinBoardItemCell
        cell.photo = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}


// MARK: - PinBoardLayout Delegate extension.
extension PinBoardViewController: PinBoardLayoutDelegate {
    // Returns the image height of the current image.
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return items[indexPath.item].image.size.height
    }
}
