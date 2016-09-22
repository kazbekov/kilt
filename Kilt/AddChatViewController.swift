//
//  AddChatViewController.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Cartography
import Sugar

class AddChatViewController: UIViewController {

    private let viewModel = CompaniesViewModel()
    private let viewModelRequest = RequestsViewModel()
    private let viewModelChat = AddChatViewModel()
    private let companiesCellIdentifier = "companiesCellIdentifier"

    private lazy var tableView: UITableView = {
        return UITableView().then {
            $0.separatorColor = .athensGrayColor()
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = 75
            $0.tableFooterView = UIView()
            $0.registerClass(CompanyTableViewCell.self, forCellReuseIdentifier: self.companiesCellIdentifier)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpContraints()
        viewModel.fetchCompanies {
            dispatch {
                self.tableView.reloadData()
            }
        }
        viewModelRequest.fetchRequests {
            dispatch {
                self.tableView.reloadData()
            }
        }
    }

    private func setupViews(){
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Компании"
        view.addSubview(tableView)
    }
    
    private func setUpContraints() {
        constrain(tableView, view) {
            $0.edges == $1.edges
        }
    }
}

extension AddChatViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModelChat.createChat(viewModel.companies[indexPath.row]) { errorMessage in
                                    dispatch {
                                        if let errorMessage = errorMessage {
                                            Drop.down(errorMessage, state: .Error)
                                        }
                                    }
        }

       navigationController?.popViewControllerAnimated(true)
    }
}

extension AddChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelRequest.requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCellWithIdentifier(companiesCellIdentifier, forIndexPath: indexPath) as! CompanyTableViewCell).then {
             let com = viewModelRequest.requests[indexPath.row]
            if let urlString = com.icon, url = NSURL(string: urlString) {
                $0.logoImageView.kf_setImageWithURL(url, placeholderImage: Icon.placeholderIcon,
                    optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            }
            $0.setUpWithTitle(com.companyName)
            print("name: \(com.companyName) all: \(viewModelRequest.requests.count)")
        }
    }
    
}