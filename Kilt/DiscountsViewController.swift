//
//  DiscountsViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import FirebaseDatabase

final class DiscountsViewController: UIViewController {
    
    private let viewModel = DiscountsViewModel()
    private var discounts = [Discount]()
    var dbRef: FIRDatabaseReference!
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.locationIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(pushMapViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private let discountsCellIdentifier = "discountsCellIdentifier"
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 75
            $0.tableFooterView = UIView()
            $0.registerClass(DiscountsTableViewCell.self, forCellReuseIdentifier: self.discountsCellIdentifier)
        }
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        setUpViews()
        setUpConstraints()
        dbRef = FIRDatabase.database().reference().child("bonuses")
        loadBonuses()
        //addBonuses()
    }
    
    func loadBonuses() {
        viewModel.fetchDiscounts() {
            self.tableView.reloadData()
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
    func addBonuses() {
        var images = [String: String]()
        let image1 = ""
        let image2 = ""
        let image3 = ""
        images = [
            "image1": image1, "image2": image2, "image3": image3
        ]
        let title = "Автомойка 'Car Wash'"
        let subtitle = "Бонусы для держателей карт The American Express Platinum и The American Express Gold - 5%"
        let logo = ""
        let address = "пр. Абая, 48 (Рахат Фитнес)"
        let bonus = Discount(title: title, subtitle: subtitle, percent: "3%", address: address, logo: logo, location: Location(latitude: 43.240324, longitude:  76.922207), images: images)
        bonus.save { (error) in }
    }
    
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Go!Бонусы"
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtonItem]
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
            $0.height == view.frame.height - 64
        }
        
    }
    
    // MARK: User Interaction
    
    @objc private func pushMapViewController() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
}

// MARK: UITableViewDelegate

extension DiscountsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(DiscountDetailViewController().then {
            $0.setUpWithDiscount(viewModel.discounts[indexPath.row])
            }, animated: true)
    }
    
}

// MARK: UITableViewDataSource

extension DiscountsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.discounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCellWithIdentifier(discountsCellIdentifier, forIndexPath: indexPath) as! DiscountsTableViewCell).then {
            $0.setUpWithTitle(viewModel.discounts[indexPath.row].title,
                subtitle: viewModel.discounts[indexPath.row].subtitle,
                percent: viewModel.discounts[indexPath.row].percent,
                logoImageUrl: viewModel.discounts[indexPath.row].logo)
        }
    }
    
}
