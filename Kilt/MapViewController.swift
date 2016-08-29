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
    var mapView: GMSMapView?
    let locationManager = CLLocationManager()
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
        loadView()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .athensGrayColor()
        navigationItem.title = "Бонусы"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtonItem]
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: GoogleMap
    
    override func loadView() {
        let camera = GMSCameraPosition.cameraWithLatitude(43.255892, longitude: 76.943108, zoom: 13.0)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        if let mapView = mapView {
            mapView.myLocationEnabled = true
            view = mapView
            mapView.settings.myLocationButton = true
        }


        let markerView = UIImageView(image: Icon.markerIcon)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 43.255892, longitude: 76.943108)
        marker.title = "Almaty"
        marker.snippet = "KBTU"
        marker.iconView = markerView


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
// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            guard let mapView = mapView else {return}
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            guard let mapView = mapView else {return}
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
            let circleCenter = location.coordinate
            let circle = GMSCircle(position: circleCenter, radius: 50)
            circle.fillColor = UIColor.appColor()
            circle.strokeColor = UIColor.appColor()

            circle.map = mapView
            locationManager.stopUpdatingLocation()
        }
    }
}
