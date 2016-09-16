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

struct BonusLocation {
    var latitude: Double?
    var longitude: Double?
    var title: String?
    var percent: String?
}
final class MapViewController: UIViewController {
    var mapView: GMSMapView?
    var lat: Double?
    var lon: Double?
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    private let viewModel = DiscountsViewModel()
    private var discounts = [Discount]()
    var locations = [BonusLocation]()
    
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
        loadBonuses()
        mapView?.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .athensGrayColor()
        navigationItem.title = "Go!Бонусы"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = [negativeSpace, rightBarButtonItem]
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: GoogleMap
    func loadBonuses(){
        viewModel.fetchDiscounts(){
            self.loadLocations()
        }
    }
    func loadLocations(){
        locations.removeAll()
        for obj in viewModel.discounts {
            var bonusL = BonusLocation()
            bonusL.latitude = obj.location?.latitude
            bonusL.longitude = obj.location?.longitude
            bonusL.title = obj.title
            bonusL.percent = obj.percent
            locations.append(bonusL)
        }
        loadLocationsIcon()
    }
    
    func loadLocationsIcon() {
        mapView?.clear()
        for obj in locations {
            let markerView = UIImageView(image: Icon.markerIcon)
            let marker = GMSMarker()
            guard obj.latitude != nil && obj.longitude != nil else {
                print("found nil: \(obj)")
                return
            }
            marker.position = CLLocationCoordinate2D(latitude: obj.latitude!, longitude: obj.longitude!)
            let bonusTitle = obj.percent
            marker.title = bonusTitle
            marker.snippet = obj.title
            marker.iconView = markerView
            marker.map = mapView
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            mapView!.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mapView!.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    override func loadView() {
        if lat == nil && lon == nil {
            lat = 43.218763
            lon = 76.850950
        }
        let camera = GMSCameraPosition.cameraWithLatitude(lat!, longitude: lon!, zoom: 13.0)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        if let mapView = mapView {
            mapView.myLocationEnabled = true
            view = mapView
            mapView.settings.myLocationButton = true
        }
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
            guard let locValue = manager.location?.coordinate else { return }
            self.lat = locValue.latitude
            self.lon = locValue.longitude
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }
    }
}
