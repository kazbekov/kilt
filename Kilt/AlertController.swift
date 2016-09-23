//
//  AlertController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class AlertController {
    
    static func unlinkAlertControllerWithTitle(title: String?, vc: UIViewController,
                                     removeActionClosure: () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title,
            message: "Уверены в ответе?", preferredStyle: .ActionSheet).then {
                $0.modalPresentationStyle = .Popover
                $0.addAction(UIAlertAction(title: "Удалить", style: .Destructive) { _ in
                    removeActionClosure()
                })
                $0.addAction(UIAlertAction(title: "Отмена", style: .Cancel, handler: nil))
        }
        
        if let presenter = alertController.popoverPresentationController {
            presenter.barButtonItem = vc.navigationItem.leftBarButtonItem
            presenter.sourceView = vc.view
        }
        
        return alertController
    }

    static func changeModeAlertController(title: String?, vc: UIViewController,
                                               removeActionClosure: () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title,
            message: nil, preferredStyle: .ActionSheet).then {
                $0.modalPresentationStyle = .Popover
                $0.addAction(UIAlertAction(title: "Клиент", style: .Default) { _ in
                    removeActionClosure()

                    })
                $0.addAction(UIAlertAction(title: "Компания", style: .Default) { _ in
                    removeActionClosure()
                    
                    })
                $0.addAction(UIAlertAction(title: "Отмена", style: .Cancel, handler: nil))
        }

        if let presenter = alertController.popoverPresentationController {
            presenter.barButtonItem = vc.navigationItem.leftBarButtonItem
            presenter.sourceView = vc.view
        }

        return alertController
    }
    
}
