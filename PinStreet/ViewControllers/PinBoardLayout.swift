//
//  PinBoardLayout.swift
//  PinStreet
//
//  Created by Shashi Shaw on 01/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit

// MARK:- Protocol to be implemented by the Collection view.
protocol PinBoardLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}


// MARK:- Custom Layout for the collection view.
class PinBoardLayout: UICollectionViewLayout {
    
    weak var delegate: PinBoardLayoutDelegate!
    
    fileprivate var nbrOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    // Array to hold the layout attributes of each pinboard item.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        get{
            guard let collectionView = collectionView else {
                return 0
            }
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
        set {
        }
    }
    
    // The size of the entire content.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(nbrOfColumns)
        // Compute xOffsets
        var xOffset = [CGFloat]()
        for column in 0 ..< nbrOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        // Compute yOffsets
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: nbrOfColumns)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // TODO: Compute the size of label heights dynamically
            // fetch the image height from the delegate.
            let imageHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let paddedHeight = cellPadding * 2 + imageHeight + 120
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: paddedHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Update the yOffet.
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + paddedHeight
            
            // set appropriate column.
            column = column < (nbrOfColumns - 1) ? (column+1) : 0
        }
    }
    
    
    // Return layout attributes for selected rect.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame .intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // Return the attributes for the item.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    // Ensure bounds are calculated when content size changes.
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldWidth = collectionView?.bounds.width {
            return oldWidth != newBounds.width
        } else if let oldHeight = collectionView?.bounds.height {
            return oldHeight != newBounds.height
        }
        return false
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        cache = []
        contentWidth = 0
        contentHeight = 0
    }
    
}
