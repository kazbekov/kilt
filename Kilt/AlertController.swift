//
//  AlertController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class AlertController {
    static func actionSheetControllerWith(title: String?, subtitle: String?, vc: UIViewController) -> UIAlertController {
        let alertController = UIAlertController(title: "Удалить Facebook",
            message: "Уверены в ответе?", preferredStyle: .ActionSheet).then {
                $0.modalPresentationStyle = .Popover
                $0.addAction(UIAlertAction(title: "Отмена", style: .Cancel, handler: nil))
        }
        
        if let presenter = alertController.popoverPresentationController {
            presenter.barButtonItem = vc.navigationItem.leftBarButtonItem
            presenter.sourceView = vc.view
        }
        
        return alertController
    }
}
