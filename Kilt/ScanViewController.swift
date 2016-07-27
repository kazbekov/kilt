//
//  ScanViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

final class ScanViewController: RSCodeReaderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        self.focusMarkLayer.strokeColor = UIColor.whiteColor().CGColor
        self.cornersLayer.strokeColor = UIColor.clearColor().CGColor
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
            }
        }
    }
}
