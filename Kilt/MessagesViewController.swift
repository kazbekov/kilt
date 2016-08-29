//
//  MessagesViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

class MessagesViewController: UIViewController {
    let items = ["Fidelity", "MEXX", "Giovanni Gali"]
    let messageCellIdentifier = "messageCellIdentifier"
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 75
            $0.tableFooterView = UIView()
            $0.backgroundColor = UIColor.whiteColor()
            $0.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: self.messageCellIdentifier)
        }
    }()
    //MARK: - Life Cycle
    override func viewDidAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    func setUpViews() {
        title = "Сообщения"
        edgesForExtendedLayout = .None
        hidesBottomBarWhenPushed = true
        view.addSubview(tableView)
    }
    func setUpConstraints() {
        constrain(tableView, view) { tableView, view in
            tableView.edges == view.edges
        }
    }
    func setUpTableView() {
        view.addSubview(tableView)
    }
}
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        let destination = MessageDialogViewController()
//        let indexPath = tableView.indexPathForSelectedRow()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MessageTableViewCell
        destination.senderId = "1"
        destination.senderDisplayName = "Dias"
        destination.titleText = cell.titleLabel.text!
        
        navigationController?.pushViewController(destination, animated: true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! MessageTableViewCell
        cell.titleLabel.text = items[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        return cell
    }
}