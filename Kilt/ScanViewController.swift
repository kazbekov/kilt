//
//  ScanViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import Sugar
import Cartography
import AVFoundation

final class ScanViewController: RSCodeReaderViewController {
    
    private var barcodeDetected = false
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var overlayView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private lazy var holeView: UIView = {
        return UIView().then {
            let borderColor = UIColor.whiteColor()
            $0.backgroundColor = borderColor
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = 1
            $0.layer.borderColor = borderColor.CGColor
        }
    }()
    
    private lazy var barcodeImageView = UIImageView().then {
        $0.contentMode = .Center
        $0.image = Icon.barcodeIcon
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "Сфотографируйте бар-код на карте"
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
    }
    
    private lazy var noBarcodeLabel = UILabel().then {
        $0.text = "На карте не имеется бар-кода?"
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
    }
    
    private lazy var noBarcodeButton: UIButton = {
        return UIButton().then {
            $0.addTarget(self, action: #selector(didPressNoBarcodeButton), forControlEvents: .TouchUpInside)
            $0.setTitle("ВВЕСТИ ВРУЧНУЮ", forState: .Normal)
            $0.titleLabel?.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }()
    
    private lazy var settingsButton: UIButton = {
        return UIButton().then {
            $0.addTarget(self, action: #selector(didPressNoBarcodeButton), forControlEvents: .TouchUpInside)
            $0.setTitle("РАЗРЕШИТЬ ДОСТУП К КАМЕРЕ", forState: .Normal)
            $0.titleLabel?.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }()

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        barcodesHandler = { barcodes in
            guard let barcode = barcodes.first where !self.barcodeDetected else { return }
            self.barcodeDetected = true
            dispatch { self.pushAddCardViewController(barcode.stringValue) }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.hidden = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        barcodeDetected = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutOverlayView()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .blackColor()
        navigationItem.title = "Добавить бар-код"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
        focusMarkLayer.strokeColor = UIColor.clearColor().CGColor
        cornersLayer.strokeColor = UIColor.clearColor().CGColor
        [titleLabel, settingsButton, noBarcodeLabel, noBarcodeButton, holeView].forEach { overlayView.addSubview($0) }
        [overlayView, barcodeImageView].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, settingsButton, noBarcodeLabel, noBarcodeButton, holeView) {
            titleLabel, settingsButton, noBarcodeLabel, noBarcodeButton, holeView in
            titleLabel.bottom == holeView.top - 20
            titleLabel.centerX == holeView.centerX
            
            settingsButton.bottom == titleLabel.top - 20
            settingsButton.centerX == holeView.centerX
            settingsButton.width == holeView.width
            settingsButton.height == 50
            
            noBarcodeLabel.top == holeView.bottom + 20
            noBarcodeLabel.centerX == holeView.centerX
            
            noBarcodeButton.top == noBarcodeLabel.bottom + 20
            noBarcodeButton.centerX == holeView.centerX
            noBarcodeButton.width == holeView.width
            noBarcodeButton.height == 50
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func didPressNoBarcodeButton() {
        pushAddCardViewController(nil)
    }
    
    @objc private func pushAddCardViewController(barcode: String?) {
        dispatch {
            self.navigationController?.pushViewController(AddCardViewController().then({
                $0.setUpWithBarcode(barcode)
            }), animated: true)
        }
    }
    
    @objc private func showAppSettings() {
        if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
    
    // MARK: Layout
    
    private func layoutOverlayView() {
        overlayView.frame = view.bounds
        overlayView.layer.mask = nil
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlayView.bounds
        
        let width: CGFloat = 250, height: CGFloat = 135
        let centerX: CGFloat = overlayView.frame.midX - width / 2
        let centerY: CGFloat = overlayView.frame.midY - height / 2
        let rect = CGRect(x: centerX, y: centerY,
                          width: width, height: height)
        
        let path = UIBezierPath(rect: overlayView.bounds)
        maskLayer.fillRule = kCAFillRuleEvenOdd
        path.appendPath(UIBezierPath(roundedRect: rect, cornerRadius: 6))
        maskLayer.path = path.CGPath
        overlayView.layer.mask = maskLayer
        
        let borderRect = CGRect(x: centerX - holeView.layer.borderWidth,
                                y: centerY - holeView.layer.borderWidth,
                                width: width + holeView.layer.borderWidth * 2,
                                height: height + holeView.layer.borderWidth * 2)
        holeView.frame = borderRect
        
        barcodeImageView.frame = holeView.frame
    }
    
}
