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
import FirebaseAuth
import JSQMessagesViewController

class MessagesViewController: UIViewController {
    private let viewModel = ChatsViewModel()
    private var messages = [JSQMessage]()
    
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
        viewModel.fetchChats {
            dispatch {
                self.tableView.reloadData()
            }
        }
        setUpViews()
        setUpConstraints()
        
    }
    
    func setUpViews() {
        title = "Сообщения"
        edgesForExtendedLayout = .None
        hidesBottomBarWhenPushed = true
        view.addSubview(tableView)
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(pushAddChatViewController))
        navigationItem.rightBarButtonItem = add
    }
    func setUpConstraints() {
        constrain(tableView, view) { tableView, view in
            tableView.edges == view.edges
        }
    }
    func setUpTableView() {
        view.addSubview(tableView)
    }
    
    @objc private func pushAddChatViewController(){
        navigationController?.pushViewController(AddChatViewController(), animated: true)
    }
}
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let userKey = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
      
        var username = FIRAuth.auth()?.currentUser?.displayName
        if username == nil {
            username = FIRAuth.auth()?.currentUser?.email
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
        let destination = MessageDialogViewController()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MessageTableViewCell
        destination.senderId = userKey
        destination.senderDisplayName = username
        destination.titleText = cell.titleLabel.text!
        destination.chat = viewModel.chats[indexPath.row]
        destination.setLogoImage(viewModel.chats[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(messageCellIdentifier, forIndexPath: indexPath) as! MessageTableViewCell
        let chat = viewModel.chats[indexPath.row]
        
        if let urlString = chat.company?.icon, url = NSURL(string: urlString)
        {
            cell.logoImageView.kf_setImageWithURL(url, placeholderImage: Icon.cardPlaceholderIcon,
                                                   optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            
        }
//        cell.lastMessageLabel.text = "dsda"
//        cell.senderNameLabel.text = "Я" 
        cell.titleLabel.text = chat.company?.name
        cell.accessoryType = .DisclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        return cell
    }
}