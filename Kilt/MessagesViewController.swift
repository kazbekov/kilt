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
import Firebase
import FirebaseAuth
import JSQMessagesViewController

class MessagesViewController: UIViewController {
    private let viewModel = ChatsViewModel()
    private var messages = [JSQMessage]()
    var messageRef: FIRDatabaseReference!
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
            dispatch { self.tableView.reloadData() }
        }
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
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
        if let urlString = viewModel.chats[indexPath.row].company?.icon, url = NSURL(string: urlString)
        {
            cell.logoImageView.kf_setImageWithURL(url, placeholderImage: Icon.cardPlaceholderIcon,
                                                   optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            
        }
        //if indexPath.row < viewModel.chatMessages.count
        cell.lastMessageLabel.text = viewModel.chats[indexPath.row].lastMessage
        if viewModel.chats[indexPath.row].adminId == viewModel.chats[indexPath.row].senderId {
            cell.senderNameLabel.text = viewModel.chats[indexPath.row].company?.name
            
        } else {
            cell.senderNameLabel.text = viewModel.chats[indexPath.row].senderName
            
        }
        cell.titleLabel.text = viewModel.chats[indexPath.row].company?.name
        cell.accessoryType = .DisclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        //
        //        chat.ref?.child("/messages/").observeEventType(.Value) {
        //            snapshot in
        //            self.fetchLastMessage(snapshot)
        //        }
        
        //        FIRDatabase.database().reference().child("messages/\(lastMessageKey)").observeEventType(.Value, withBlock: { snapshot in
        //            if let lastMessageText = snapshot.value?["text"] as? String, senderName = snapshot.value?["senderName"] as? String, senderId = snapshot.value?["senderId"] as? String {
        //                adminKey = senderId
        //                print(lastMessageText)
        //                print(senderName)
        //                cell.lastMessageLabel.text = lastMessageText
        //                cell.senderNameLabel.text = "\(senderName): "
        //            }
        //        })
        
        
        //        chat.ref?.child("/admins/").observeEventType(.ChildAdded) {(snapshot: FIRDataSnapshot!) in FIRDatabase.database().reference().child("users/\(snapshot.key)").observeEventType(.Value, withBlock: { snapshot in
        //            if adminKey == snapshot.key {
        //                 cell.senderNameLabel.text = chat.company?.name
        //            }
        //        })
        //        }

        return cell
    }
}