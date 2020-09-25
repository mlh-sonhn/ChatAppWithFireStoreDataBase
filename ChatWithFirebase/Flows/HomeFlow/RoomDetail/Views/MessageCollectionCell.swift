//
//  MessageCollectionCell.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/30/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func configCell(with chatMessage: ChatMessage) {
        messageLabel.text = chatMessage.message
        if chatMessage.senderId == Auth.auth().currentUser?.uid {
            containerView.semanticContentAttribute = .forceRightToLeft
        } else {
            containerView.semanticContentAttribute = .forceLeftToRight
        }
    }
    
}
