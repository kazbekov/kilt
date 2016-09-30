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
    
    private var viewModel = CardsViewModel()
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.addCardIcon, style: UIBarButtonItemStyle.Plain,
                        target: self, action: #selector(pushScanViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private let cardsCellIdentifier = "cardsCellIdentifier"
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.separatorColor = .athensGrayColor()
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
        viewModel.fetchCards {
            dispatch { self.tableView.reloadData() }
        }
        
        setUpViews()
        setUpConstraints()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        if viewModel.cards.count == 0 {
//            viewModel.noDataLabel.text             = "Нет карточек"
//            viewModel.noDataLabel.textColor        = UIColor.grayColor()
//            viewModel.noDataLabel.textAlignment    = .Center
//            tableView.backgroundView = viewModel.noDataLabel
            tableView.separatorStyle = .None
            
        }
    }
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtonItem]
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
    
    // MARK: User Interaction
    
    @objc private func pushScanViewController() {
        navigationController?.pushViewController(ScanViewController(), animated: true)
    }
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
}

// MARK: UITableViewDelegate

extension CardsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(CardDetailViewController().then {
            guard viewModel.cards.count > 0 else {
                return
            }
            $0.setUpWithCard(viewModel.cards[indexPath.row])
            }, animated: true)
    }
    
}

// MARK: UITableViewDataSource

extension CardsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.cards.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCellWithIdentifier(cardsCellIdentifier, forIndexPath: indexPath) as! CardsTableViewCell).then {
            
            var reversedArray = [Card]()
            for index in (viewModel.cards.count - 1).stride(through: 0, by: -1) {
                reversedArray.append(viewModel.cards[index])
            }
            
            
            let card = reversedArray[indexPath.row]
            
            if let urlString = card.company?.icon, url = NSURL(string: urlString) {
                $0.logoImageView.kf_setImageWithURL(url, placeholderImage: Icon.cardPlaceholderIcon,
                    optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            }
            $0.setUpWithTitle(card.company?.name)
        }
        
        
    }
    
}
