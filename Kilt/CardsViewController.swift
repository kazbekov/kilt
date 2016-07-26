//
//  CardsViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CardsViewController: UIViewController {
    
    private let viewModel = CardsViewModel()
    
    private lazy var rightBarButtomItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.addCardIcon, style: UIBarButtonItemStyle.Plain,
                        target: self, action: #selector(pushAddCardViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private let cardsCellIdentifier = "cardsCellIdentifier"
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 75
            $0.tableFooterView = UIView()
            $0.registerClass(CardsTableViewCell.self, forCellReuseIdentifier: self.cardsCellIdentifier)
        }
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtomItem]
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
    
    // MARK: User Interaction
    
    @objc private func pushAddCardViewController() {
        navigationController?.pushViewController(AddCardViewController(), animated: true)
    }
    
}

// MARK: UITableViewDelegate

extension CardsViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource

extension CardsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(cardsCellIdentifier, forIndexPath: indexPath) as! CardsTableViewCell
    }
    
}
