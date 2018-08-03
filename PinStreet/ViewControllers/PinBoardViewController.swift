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

    var pinBoardItems = [PinBoardItem]()
    
    // During the first load, activity indicator is displayed,
    // At other times, Pull to refresh, activity indicator is hidden.
    var isFirstLoad: Bool = false
    
    // refresh control for pull to refresh:
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(fetchPinBoardItems),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set ourselves as the delegate for the Layout delegate.
        if let layout = collectionView?.collectionViewLayout as? PinBoardLayout {
            layout.delegate = self
        }
        
        self.title = "PinStreet"
        view.backgroundColor = .white
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        // Initiate request to fetch items.
        // Add the refresh control.
        self.collectionView?.addSubview(self.refreshControl)
        // Set first load flag to show Activity indicator.
        self.isFirstLoad = true
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
    @objc func fetchPinBoardItems() {
        self.showActivityIndicator()
        let pinBoardController = PinBoardController()
        pinBoardController.fetchPinBoardItems(
        success: { [unowned self] (pinBoardItems) in
            // Initiate request to load image.
            DispatchQueue.main.async {
                self.pinBoardItems.append(contentsOf: pinBoardItems)
                self.collectionView?.reloadData()
                self.hideActivityIndicator()
            }
        },
        failure: { [unowned self] (errorMsg) in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if let msg = errorMsg {
                    print(msg)
                }
                self.showAlert(with: errorMsg)
                self.collectionView?.reloadData()
            }
        })
    }
    
    func showActivityIndicator() {
        if self.isFirstLoad {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideActivityIndicator() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        
        // Activity indicator only for first time launch.
        if self.isFirstLoad {
            self.isFirstLoad = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // Show alert:
    func showAlert(with message: String?) {
        guard let msg = message else {
            return
        }
        let alertView = UIAlertController.init(title: "Error",
                                               message: msg,
                                               preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertActionStyle.default,
                                          handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }

}


// MARK: - Collection View Delegate.
extension PinBoardViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFirstLoad == false {
            if pinBoardItems.count == 0 {
                collectionView.setNoContentMessage("No Content Available...")
            }
            else {
                collectionView.restore()
            }
        }
        return pinBoardItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinBoardItemCell",
                                                      for: indexPath as IndexPath) as! PinBoardItemCell
        if indexPath.item < pinBoardItems.count {
            cell.configureItem(pinBoardItems[indexPath.item], atIndexpath: indexPath)
        }
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
        return CGFloat(pinBoardItems[indexPath.item].height)
    }
}


// MARK: - No Content Message.
extension UICollectionView {
    func setNoContentMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
