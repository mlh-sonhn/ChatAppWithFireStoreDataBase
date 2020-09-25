//
//  UsersViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UsersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: UsersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Users"
    }
    
    override func bindViewModel() {
        viewModel.tableSectionObserver()
            .bind(to: tableView.rx.items(cellIdentifier: "UsersTableViewCell")) { _, user, cell in
                if let cell = cell as? UsersTableViewCell {
                    cell.configCell(with: user)
                }
            }.disposed(by: disposeBag)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .map { UsersViewAction.selectUser($0) }
            .bind(to: viewModel.actionObserver())
            .disposed(by: disposeBag)
    }

}

// MARK: - Table view delegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
