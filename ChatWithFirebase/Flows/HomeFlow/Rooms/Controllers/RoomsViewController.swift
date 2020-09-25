//
//  RoomsViewController.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/23/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
import RxSwift

class RoomsViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    var viewModel: RoomsViewModel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier.elementsEqual(RoomsTableViewController.className),
            let tableViewController = segue.destination as? RoomsTableViewController {
            tableViewController.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Rooms"
    }
    
    override func bindViewModel() {
        let searchTextChangeObserver = searchBar.rx.text
            .distinctUntilChanged()
            .compactMap { text -> RoomsAction? in
                return text == nil ? nil : .searchTextChange(text!)
            }
        
        Observable.of(searchTextChangeObserver)
            .merge()
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

}
