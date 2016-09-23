//
//  RequestViewController.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/21/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import Fusuma

class RequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    private let viewModel = ProfileViewModel()
    private let requestCellIdentifier = "requestCellIdentifier"

    private let placeholders = ["Email", "Номер телефона"]
    private let sectionsTitle = ["EMAIL", "НОМЕР ТЕЛЕФОНА"]

    private let tableHeaderHeight: CGFloat = 100

    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Отправить", style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(sendButtonPressed))
    }()

    private lazy var headerView: RequestTableHeaderView = {
        return RequestTableHeaderView(frame: CGRect(x: 0, y: 0,
            width: UIScreen.mainScreen().bounds.width, height: self.tableHeaderHeight)).then {
                $0.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        }
    }()
    private lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .Grouped).then {
            $0.backgroundColor = .athensGrayColor()
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 44
            $0.tableHeaderView = self.headerView
            $0.tableFooterView = UIView()
            $0.registerClass(RequestTableViewCell.self, forCellReuseIdentifier: self.requestCellIdentifier)
        }
    }()

    //MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }

    //MARK: - Helpers

    private func setUpHeaderView() {
        guard let frame = tableView.tableHeaderView?.frame else { return }
        headerView.frame = frame
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
    }



    //MARK: - Actions
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func selectImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusumaTintColor = .appColor()
        self.presentViewController(fusuma, animated: true, completion: nil)
    }

    func sendButtonPressed() {
        hideKeyboard()
        let emailCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! RequestTableViewCell
        let numberCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! RequestTableViewCell
        self.viewModel.linkRequest(headerView.nameTextField.text, email: emailCell.emailTextField.text, number: numberCell.emailTextField.text, icon: headerView.avatarImageView.image) { errorMessage in
            dispatch {
                if let errorMessage = errorMessage {
                    Drop.down(errorMessage, state: .Error)
                    self.headerView.nameTextField.becomeFirstResponder()
                    return
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                    Drop.down("Запрос успешно отправлен", state: .Success)
                }
            }
        }
    }
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight,
                                width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        view.layoutIfNeeded()
    }

    func setUpViews() {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        title = "Запрос"
        edgesForExtendedLayout = .None
        view.addSubview(tableView)
    }

    func setUpConstraints() {
        constrain(tableView, view) {tableView, view in
            tableView.edges == view.edges
        }
    }

    //MARK: - TableView Delegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel().then {
            $0.text = sectionsTitle[section]
            $0.font = $0.font.fontWithSize(12)
            $0.textAlignment = .Left
            $0.frame = CGRectMake(8, 6, 200, 30)
            $0.textColor = .riverBedColor()
        }
        view.addSubview(titleLabel)
        return view
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if section == sectionsTitle.count - 1 {
            let titleLabel = UILabel().then {
                $0.text = "Напишите свой email и телефон. Мы с вами свяжемся в течение 24 часов."
                $0.font = $0.font.fontWithSize(12)
                $0.textAlignment = .Left
                $0.numberOfLines = 0
                $0.frame = CGRectMake(8, 6, self.view.frame.size.width, 30)
                $0.textColor = .riverBedColor()
            }
            view.addSubview(titleLabel)
        }
        return view
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 37
    }

    //MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsTitle.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return (tableView.dequeueReusableCellWithIdentifier(requestCellIdentifier, forIndexPath: indexPath) as! RequestTableViewCell).then {
                    $0.setUpWithTitle(placeholders[indexPath.section])
                    $0.selectionStyle = .None
                    switch indexPath.section {
                    case 1:
                        $0.emailTextField.keyboardType = .NumbersAndPunctuation
                    default:
                        $0.emailTextField.keyboardType = .EmailAddress
                    }
        }
    }
}

// MARK: FusumaDelegate

extension RequestViewController: FusumaDelegate {

    func fusumaImageSelected(image: UIImage) {
        headerView.avatarImageView.image = image
        headerView.nameTextField.becomeFirstResponder()
        return
    }

    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }

    func fusumaCameraRollUnauthorized() {
        Drop.down("Разрешите доступ к вашим фотографиям в настройках", state: .Error)
    }
    
}
