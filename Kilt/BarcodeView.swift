//
//  BarcodeView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/29/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import RSBarcodes_Swift
import AVFoundation

final class BarcodeView: UIView {
    
    private lazy var barcodeImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFit
    }
    
    private lazy var barcodeLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        [barcodeImageView, barcodeLabel].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(barcodeImageView, barcodeLabel, self) {
            barcodeImageView, barcodeLabel, view in
            barcodeImageView.top == view.top
            barcodeImageView.leading == view.leading
            barcodeImageView.trailing == view.trailing
            barcodeImageView.height == 90
            
            barcodeLabel.top == barcodeImageView.bottom + 10
            barcodeLabel.leading == view.leading
            barcodeLabel.trailing == view.trailing
        }
    }
    
}

extension BarcodeView {
    
    func setUpWithBarcode(barcode: String?) {
        guard let barcode = barcode, image = RSUnifiedCodeGenerator.shared
            .generateCode(barcode, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code)
            where !barcode.isEmpty else { return }
        barcodeImageView.image = image
        barcodeLabel.text = barcode
    }
    
}
