//
//  MessageDialogViewController.swift
//  
//
//  Created by Dias Dosymbaev on 8/23/16.
//
//

import Foundation
import UIKit
import Cartography
import Sugar
import JSQMessagesViewController
import Firebase
import FirebaseDatabase

class MessageDialogViewController: JSQMessagesViewController {

    // MARK: Properties
    var titleText: String?
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var messages = [JSQMessage]()
    let rootRef = FIRDatabase.database().reference()
    var messageRef: FIRDatabaseReference!
    let logoImageView = UIImageView().then {
        $0.image = Icon.placeholderIcon
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 3.27
        $0.clipsToBounds = true
    }
    var rightBarButtonItem = UIBarButtonItem()
    var userIsTypingRef: FIRDatabaseReference!
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    var usersTypingQuery: FIRDatabaseQuery!

    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        setUpRightBarButton()
        setupBubbles()
        messageRef = rootRef.child("messages")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        observeMessages()
        observeTyping()
    }
    //MARK: - Actions

    func setUpViews() {
        collectionView.backgroundColor = UIColor.athensGrayColor()
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        tabBarController?.tabBar.hidden = true
        if let titleText = titleText {
            self.navigationItem.titleView = setTitle(titleText, subtitle: "Online")
        }
        inputToolbar.contentView.rightBarButtonItem.setTitle("Отпр", forState: .Normal)
        inputToolbar.contentView.textView.placeHolder = "Отправить сообщение"
    }
    override func didPressAccessoryButton(sender: UIButton!) {
        callActionSheet()
    }
    func callActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Снять фото или видео", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let galleryAction = UIAlertAction(title: "Фото/Видео", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let locationlAction = UIAlertAction(title: "Мое местоположение", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let contactAction = UIAlertAction(title: "Контакт", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        [cameraAction, galleryAction, locationlAction, contactAction, cancelAction].forEach {
            optionMenu.addAction($0)
        }
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.appColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.whiteColor())
    }

    func setUpConstraints() {
    }
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping = textView.text != ""
    }

    //MARK: -FireBase

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "text": text,
            "senderId": senderId
        ]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        isTyping = false
    }
    private func observeMessages() {
        let messagesQuery = messageRef.queryLimitedToLast(25)
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            self.addMessage(id, text: text)
            self.finishReceivingMessage()
        }
    }
    private func observeTyping() {
        let typingIndicatorRef = rootRef.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        usersTypingQuery.observeEventType(.Value) { (data: FIRDataSnapshot!) in
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }
    }
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        // messages from someone else
//        addMessage("foo", text: "Добрый день Жандос, мы очень рады, что вы с нами! Можем вам предложить новую карту и плюс три новых гостевых посящений. ")
//        addMessage("foo", text: "Yoooo!")
//        // messages sent from local sender
//        addMessage(senderId, text: "Отлично, буду очень рад. Хотел бы узнать, когда вы сможете отправить мне новую майку от Головкина?")
//        addMessage(senderId, text: "Hello!")
//        addMessage(senderId, text: "How are ya?")
//        // animates the receiving of a new message on the view
//        finishReceivingMessage()
//    }

    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    func setUpRightBarButton() {
        rightBarButtonItem.customView = logoImageView
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRectMake(0, 3, 0, 0))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = .whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.text = title
        titleLabel.sizeToFit()
        let subtitleLabel = UILabel(frame: CGRectMake(0, 25, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = .whiteColor()
        subtitleLabel.font = UIFont.systemFontOfSize(11)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 40))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        let widthDiff = titleLabel.frame.size.width - subtitleLabel.frame.size.width
        if widthDiff > 0 {
            var frame = subtitleLabel.frame
            frame.origin.x = widthDiff / 2
            subtitleLabel.frame = frame
        } else {
            var frame = titleLabel.frame
            frame.origin.x = (subtitleLabel.frame.size.width - titleLabel.frame.size.width) / 2
            titleLabel.frame = frame
        }
        return titleView
    }

    //MARK: - Delegate & Data Source

    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        cell.textView.font = cell.textView.font!.fontWithSize(15)

//        cell.layer.cornerRadius = 10
//        cell.layer.shouldRasterize = false
//        cell.layer.shadowColor = UIColor.blackColor().CGColor
//        cell.layer.shadowRadius = 5.0
//        cell.layer.shadowOffset = CGSizeMake(2, 2)
//        cell.layer.shadowOpacity = 0.17
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.messageBubbleImageView.bounds, cornerRadius: cell.contentView.layer.cornerRadius).CGPath
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
            cell.messageBubbleTopLabel.text = ""

        } else {
            cell.textView!.textColor = UIColor.blackColor()
            cell.messageBubbleTopLabel.text = "Fidelity"
        }
        
        return cell
    }
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];

        //Sent by me, skip
        if message.senderId == senderId {
            return nil;
        }

        //Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }

        return NSAttributedString(string: "Fidelity")//message.sender())
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]

        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }

        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }

        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}