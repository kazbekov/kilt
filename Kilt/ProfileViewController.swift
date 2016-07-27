//
//  ProfileViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class ProfileViewController: UIViewController {

    private let profileCellIdentifier = "profileCellIdentifier"
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.backgroundColor = .athensGrayColor()
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 44
            $0.tableHeaderView = ProfileTableHeaderView(frame:
                CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 156))
            $0.tableFooterView = UIView()
            $0.registerClass(ProfileTableViewCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
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
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
    
}

// MARK: UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier, forIndexPath: indexPath) as! ProfileTableViewCell).then {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0: $0.setUpWithTitle("Facebook", subtitle: "Добавить", icon: Icon.facebookIcon)
                case 1: $0.setUpWithTitle("Google", subtitle: "Добавить", icon: Icon.googleIcon)
                default: break
                }
            case 1:
                switch indexPath.row {
                case 0:
                    $0.setUpWithTitle("Выйти", subtitle: nil, icon: Icon.exitIcon)
                    $0.setTitleLabelColor(.crimsonColor())
                default: break
                }
            default: break
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView().then {
            $0.backgroundColor = .athensGrayColor()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 20
        case 1: return 84
        default: return 0
        }
    }
    
}
