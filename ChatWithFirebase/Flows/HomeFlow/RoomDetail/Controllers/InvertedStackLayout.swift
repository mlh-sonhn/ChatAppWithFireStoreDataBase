//
//  InvertedStackLayout.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/30/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

protocol InvertedStackLayoutDelegate: class {
    func cellHeight(forItemAt indexPath: IndexPath) -> CGFloat
}

class InvertedStackLayout: UICollectionViewFlowLayout {
    private let defaultCellHeight: CGFloat = 100.0
    
    weak var delegate: InvertedStackLayoutDelegate?
    
    let cellHeight: CGFloat = 100.00 // Your cell height here...
    
    private var cacheAttributes: [String: UICollectionViewLayoutAttributes] = [:]
    private var currentContentSize: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        currentContentSize = 0.0
        let numOfSection = collectionView.numberOfSections
        for section in 0..<numOfSection {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                let currentCellHeight = cellHeight(at: indexPath)
                let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                layoutAttr.frame = CGRect(
                    x: 0, y: currentContentSize,
                    width: collectionView.bounds.width, height: currentCellHeight)
                currentContentSize += currentCellHeight
                cacheAttributes["\(indexPath)"] = layoutAttr
            }
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes["\(indexPath)"]
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            var bounds = CGRect.zero
            if let collectionView = self.collectionView {
                bounds = collectionView.bounds
            }

            return CGSize(width: bounds.width, height: max(currentContentSize, bounds.height))
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds,
            oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
        {
            return true
        }
        
        return false
    }
}

extension InvertedStackLayout {
    func cellHeight(at indexPath: IndexPath) -> CGFloat {
        if let cellHeigh = delegate?.cellHeight(forItemAt: indexPath) {
            return cellHeigh + 20
        }
        return defaultCellHeight
    }
}
