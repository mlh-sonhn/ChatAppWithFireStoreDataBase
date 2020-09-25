//
//  RoomsTableViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class RoomsTableViewController: UITableViewController {
    
    var viewModel: RoomsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
