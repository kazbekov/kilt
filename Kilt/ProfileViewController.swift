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
    
    private let viewModel = ProfileViewModel()

    private let profileCellIdentifier = "profileCellIdentifier"
    
    private var heightForHeaders: [CGFloat] = [20, 84]
    
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
        navigationItem.title = "Профиль"
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
    
    // MARK: Helpers
    
    private func unlinkFacebook() {
        dispatch { self.presentViewController(
            AlertController.actionSheetControllerWith("Удалить Facebook", subtitle: "Уверены в ответе?", vc: self).then {
                $0.addAction(UIAlertAction(title: "Удалить", style: .Destructive) { _ in
                    self.viewModel.unlinkFacebook() { errorMessage in
                        dispatch {
                            if let errorMessage = errorMessage {
                                Drop.down(errorMessage, state: .Error)
                                return
                            }
                            self.tableView.reloadSection(0, animation: .Fade)
                        }
                    }
                })
            }, animated: true, completion: nil)
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
    
    private func linkEmail() {
        dispatch { self.presentViewController(self.linkEmailAlertController, animated: true, completion: nil) }
    }
    
    private func signOut() {
        dispatch {
            self.presentViewController(UIAlertController(title: "Выйти",
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
            }, animated: true, completion: nil)
        }
    }
    
}

// MARK: UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0): linkFacebook()
        case (0, 1): linkEmail()
        case (1, _): signOut()
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
