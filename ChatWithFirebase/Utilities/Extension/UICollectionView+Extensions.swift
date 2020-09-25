//
//  UICollectionView+Extensions.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 8/3/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UICollectionView {
    func scrollToBottomAnimated(animated: Bool = true) {
        guard numberOfSections > 0 else {
            return
        }
        let items = numberOfItems(inSection: 0)
        if items == 0 { return }
        
        let collectionViewContentHeight = collectionViewLayout.collectionViewContentSize.height
        let isContentTooSmall: Bool = (collectionViewContentHeight < bounds.size.height)
        
        if isContentTooSmall {
            scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight, width: 1, height: 1), animated: animated)
            return
        }
        scrollToItem(at: IndexPath(item: items - 1, section: 0), at: .bottom, animated: animated)
    }
}

extension Reactive where Base: UICollectionView {
    public var scrollToBottomWithAnimated: Binder<Bool> {
        return Binder(self.base, binding: { (collectionView, isAnimated) in
            collectionView.scrollToBottomAnimated(animated: isAnimated)
        })
    }
}
