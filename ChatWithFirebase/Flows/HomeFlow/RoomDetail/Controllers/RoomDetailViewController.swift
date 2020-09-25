//
//  RoomDetailViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/26/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import RxSwift
import RxCocoa

class RoomDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var disposeBag = DisposeBag()
    
    var viewModel: RoomDetailViewModel!
    private let inputBarAccessoryView = InputBarAccessoryView()
    
    override var inputAccessoryView: UIView? {
        
        return inputBarAccessoryView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let invertedStackLayout = collectionView.collectionViewLayout as? InvertedStackLayout {
            invertedStackLayout.delegate = self
        }
        bindViewModel()
        inputBarAccessoryView.delegate = self
        inputBarAccessoryView.inputTextView.tintColor = .blue
        inputBarAccessoryView.sendButton.setTitleColor(.blue, for: .normal)
        inputBarAccessoryView.sendButton.setTitleColor(
            UIColor.blue.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    private func bindViewModel() {
        viewModel.messagesObserver()
            .bind(to: collectionView.rx.items(cellIdentifier: MessageCollectionCell.className, cellType: MessageCollectionCell.self)) { index, chatMessage, cell in
                cell.configCell(with: chatMessage)
        }.disposed(by: disposeBag)
        viewModel.messagesObserver()
            .map { _ in return false }
            .bind(to: collectionView.rx.scrollToBottomWithAnimated)
            .disposed(by: disposeBag)
    }
    
}

extension RoomDetailViewController: InvertedStackLayoutDelegate {

    func cellHeight(forItemAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sizeOfItem(at: indexPath, with: collectionView.bounds.width)
    }
    
}

extension RoomDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.sendMessage(text)
        inputBar.inputTextView.text = ""
        inputBar.reloadPlugins()
        inputBar.inputTextView.resignFirstResponder()
        collectionView.rx.scrollToBottomWithAnimated.onNext(true)
    }
}
