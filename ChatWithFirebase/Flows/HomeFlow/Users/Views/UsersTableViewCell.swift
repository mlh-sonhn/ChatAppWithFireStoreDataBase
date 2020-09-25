//
//  UsersTableViewCell.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/26/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var onlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(with user: ChatUser) {
        onlineView.isHidden = !user.isOnline
        userName.text = user.fullName
    }

}
