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
import Fusuma
import Kingfisher
import FirebaseDatabase

final class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()

    private let profileCellIdentifier = "profileCellIdentifier"
    
    private var heightForHeaders: [CGFloat] = [20, 20, 84]

    var requestIcon: UIImage?
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Изменить", style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(toggleEditMode(_:)))
    }()
    
    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.backgroundColor = .athensGrayColor()
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 44
            $0.tableHeaderView = ProfileTableHeaderView(frame:
                CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 156)).then {
                    $0.avatarImageView
                        .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
            }
            $0.tableFooterView = UIView()
            $0.registerClass(ProfileTableViewCell.self, forCellReuseIdentifier: self.profileCellIdentifier)
        }
    }()
    
    private lazy var unlinkFacebookAlertController: UIAlertController = {
        return AlertController.unlinkAlertControllerWithTitle("Удалить Facebook", vc: self) {
            self.viewModel.unlinkFacebook() { errorMessage in
                dispatch {
                    if let errorMessage = errorMessage {
                        Drop.down(errorMessage, state: .Error)
                        return
                    }
                    self.tableView.reloadSection(0, animation: .Fade)
                }
            }
        }
    }()

    private lazy var changeModeAlertController: UIAlertController = {
        return AlertController.changeModeAlertController("Выберите режим", vc: self) {

        }
    }()

    private lazy var unlinkEmailAlertController: UIAlertController = {
        return AlertController.unlinkAlertControllerWithTitle("Удалить Email", vc: self) {
            self.viewModel.unlinkEmail() { errorMessage in
                dispatch {
                    if let errorMessage = errorMessage {
                        Drop.down(errorMessage, state: .Error)
                        return
                    }
                    self.tableView.reloadSection(0, animation: .Fade)
                }
            }
        }
    }()

    var shouldSelectAvatar = true
    private lazy var linkRequestAlertController: UIAlertController = {
        return UIAlertController(title: "Запрос режима компании", message: "Напишите свой email и телефон. Мы с вами свяжемся в течение 24 часов.", preferredStyle: .Alert).then  { alertController in
            alertController.addTextFieldWithConfigurationHandler {
                $0.autocapitalizationType = .Words
                $0.placeholder = "Название компаний"
            }

            alertController.addTextFieldWithConfigurationHandler {
                $0.keyboardType = .EmailAddress
                $0.autocapitalizationType = .None
                $0.placeholder = "Email"
            }

            alertController.addTextFieldWithConfigurationHandler {
                $0.placeholder = "Телефон"
            }
            alertController.addAction(UIAlertAction(title: "Добавить иконку", style: .Default) { _ in
                self.shouldSelectAvatar = false
                self.selectImage()
                })

            alertController.addAction(UIAlertAction(title: "Отправить", style: .Default) { _ in
                self.viewModel.linkRequest(alertController.textFields?[0].text, email: alertController.textFields?[1].text,
                number: alertController.textFields?[2].text, icon: self.requestIcon) { errorMessage in
                    dispatch {
                        if let errorMessage = errorMessage {
                            Drop.down(errorMessage, state: .Error)
                            self.linkRequest()
                            return
                        } else {
                            Drop.down("Запрос успешно отправлен", state: .Success)
                        }
                        alertController.textFields?[0].text = nil
                        alertController.textFields?[1].text = nil
                        alertController.textFields?[2].text = nil
                        self.tableView.reloadSection(1, animation: .Fade)
                    }
                }
                })


            alertController.addAction(UIAlertAction(title: "Отмена", style: .Destructive, handler: nil))
        }
    }()

    private lazy var linkEmailAlertController: UIAlertController = {
        return UIAlertController(title: "Привязка email", message: "Напишите свой email и придумайте пароль",
            preferredStyle: .Alert).then { alertController in
            alertController.addAction(UIAlertAction(title: "Привязать", style: .Default) { _ in
                self.viewModel.linkEmail(alertController.textFields?[0].text,
                password: alertController.textFields?[1].text) { errorMessage in
                    dispatch {
                        if let errorMessage = errorMessage {
                            Drop.down(errorMessage, state: .Error)
                            self.linkEmail()
                            return
                        }
                        alertController.textFields?[0].text = nil
                        alertController.textFields?[1].text = nil
                        self.tableView.reloadSection(0, animation: .Fade)
                    }
                }
                })
            alertController.addAction(UIAlertAction(title: "Отмена", style: .Default, handler: nil))
            alertController.addTextFieldWithConfigurationHandler {
                $0.keyboardType = .EmailAddress
                $0.autocapitalizationType = .None
                $0.placeholder = "Email"
            }
            alertController.addTextFieldWithConfigurationHandler {
                $0.placeholder = "Пароль"
                $0.secureTextEntry = true
            }
        }
    }()

    private lazy var signOutAlertController: UIAlertController = {
        return UIAlertController(title: "Выйти",
            message: "Уверены в ответе? Мы будем скучать :(", preferredStyle: .Alert).then {
            $0.addAction(UIAlertAction(title: "Да", style: .Default) { _ in
                self.viewModel.signOut() { errorMessage in
                    dispatch {
                        if let errorMessage = errorMessage {
                            Drop.down(errorMessage, state: .Error)
                            return
                        }
                        (UIApplication.sharedApplication().delegate as? AppDelegate)?.loadLoginPages()
                    }
                }
            })
            $0.addAction(UIAlertAction(title: "Нет", style: .Default, handler: nil))
        }
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        User.fetchIsVerified { (isVerified) in
            self.viewModel.isVerified = isVerified ?? false
        }
        if let headerView = tableView.tableHeaderView as? ProfileTableHeaderView {
            viewModel.fetchIcon {
                if let url = $0 {
                    headerView.avatarImageView.kf_setImageWithURL(url, placeholderImage: Icon.profilePlaceholderIcon,
                        optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            viewModel.fetchName { headerView.name = $0 }
            viewModel.fetchAddress { headerView.address = $0 }
        }
        viewModel.reloadUser { errorMessage in
            dispatch {
                if errorMessage == nil {
                    self.tableView.reloadData()
                }
            }
        }
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Профиль"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
    
    // MARK: User Interaction
    
    @objc private func selectImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusumaTintColor = .appColor()
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    @objc private func toggleEditMode(sender: UIBarButtonItem) {
        guard let headerView = tableView.tableHeaderView as? ProfileTableHeaderView else { return }
        headerView.toggleInteraction()
        if !headerView.userInteractionEnabled {
            viewModel.saveUserWithName(headerView.name, address: headerView.address, icon: headerView.icon) { errorMessage in
                dispatch {
                    if let errorMessage = errorMessage {
                        Drop.down(errorMessage, state: .Error)
                    }
                }
            }
        }
        sender.title = headerView.userInteractionEnabled ? "Сохранить" : "Изменить"
    }
    
    private func unlinkFacebook() {
        dispatch { self.presentViewController( self.unlinkFacebookAlertController, animated: true, completion: nil) }
    }

    private func changeMode() {
        dispatch { self.presentViewController( self.changeModeAlertController, animated: true, completion: nil) }
    }
    
    private func linkRequest() {
        if viewModel.isVerified {
            changeMode()
            return
        }
        dispatch {
            self.navigationController?.pushViewController(RequestViewController(), animated: true)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
    private func linkFacebook() {
        if viewModel.isLinkedWithFacebook {
            unlinkFacebook()
            return
        }
        viewModel.linkFacebook(self) { errorMessage in
            dispatch {
                if let errorMessage = errorMessage {
                    Drop.down(errorMessage, state: .Error)
                    return
                }
                self.tableView.reloadSection(0, animation: .Fade)
            }
        }
    }
    
    private func unlinkEmail() {
        dispatch { self.presentViewController( self.unlinkEmailAlertController, animated: true, completion: nil) }
    }
    
    private func linkEmail() {
        if viewModel.isLinkedWithEmail {
            unlinkEmail()
            return
        }
        dispatch { self.presentViewController(self.linkEmailAlertController, animated: true, completion: nil) }
    }
    
    private func signOut() {
        dispatch { self.presentViewController(self.signOutAlertController, animated: true, completion: nil) }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0): linkFacebook()
        case (0, 1): linkEmail()
        case (1, 0): linkRequest()
        case (2, 0): signOut()
        default: break
        }
    }
    
}

// MARK: UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.cellItems.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellItems[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier, forIndexPath: indexPath) as! ProfileTableViewCell).then {
            let item = viewModel.cellItems[indexPath.section][indexPath.row]
            $0.setUpWithTitle(item.title, subtitle: item.subtitle, icon: item.icon, titleColor: item.titleColor)
            if indexPath.section == 1{
                $0.accessoryType = .DisclosureIndicator
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView().then {
            $0.backgroundColor = .athensGrayColor()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaders[section]
    }
    
}

// MARK: FusumaDelegate

extension ProfileViewController: FusumaDelegate {
    
    func fusumaImageSelected(image: UIImage) {
        guard let headerView = tableView.tableHeaderView as? ProfileTableHeaderView where shouldSelectAvatar == true else {
            requestIcon = image
            linkRequest()
            shouldSelectAvatar = true
            return
        }
        headerView.avatarImageView.image = image
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }

    func fusumaClosed() {
        shouldSelectAvatar = true
    }
    
    func fusumaCameraRollUnauthorized() {
        shouldSelectAvatar = true
        Drop.down("Разрешите доступ к вашим фотографиям в настройках", state: .Error)
    }
    
}
