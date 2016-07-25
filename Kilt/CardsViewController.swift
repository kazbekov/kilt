//
//  CardsViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class CardsViewController: UIViewController {
    
    private let viewModel = CardsViewModel()
    
    private let cardsCellIdentifier = "cardsCellIdentifier"
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.delegate = self
            $0.dataSource = self
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CardsViewController: UITableViewDelegate {
    
}

extension CardsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cardsCellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
}
