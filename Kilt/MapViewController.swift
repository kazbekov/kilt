//
//  MapViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/30/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import GoogleMaps

final class MapViewController: UIViewController {
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.listIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .athensGrayColor()
        navigationItem.title = "Бонусы"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtonItem]
    }
    
    // MARK: GoogleMap
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension MapViewController {
    
    func setUpWithCities(cities: [String]?) {
    }
    
}
