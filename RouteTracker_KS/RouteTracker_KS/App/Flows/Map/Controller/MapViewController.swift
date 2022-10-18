//
//  ViewController.swift
//  RouteTracker_KS
//
//  Created by Константин Шмондрик on 17.10.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

enum UpdateLocationEnum: String {
    case on = "Отслеживать"
    case off = "Остановить"
}

final class MapViewController: UIViewController {
    
    private var mapView: MapView {
        return self.view as! MapView
    }
    
    private var marker: GMSMarker?
    private var manualMarker: GMSMarker?
    private var locationManager: CLLocationManager?
    private var geocoder: CLGeocoder?
    private var path: GMSMutablePath?
    private var route: GMSPolyline?
    private var zoomValue: Float = 15
    private var coordinates: [CLLocationCoordinate2D] = []
    private let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    private var updateLocationtTitle: String = UpdateLocationEnum.on.rawValue
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        let view = MapView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setNavigationBar()
        configureLocationManager()
        
    }
    
    // MARK: - Privat func
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoomValue)
        mapView.mapView.camera = camera
        mapView.mapView.isMyLocationEnabled = true
        mapView.mapView.delegate = self
    }
    
    private func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView.mapView
        self.marker = marker
    }
    
    private func addPath(coordinates: [CLLocationCoordinate2D]) {
       
        path = GMSMutablePath()
        coordinates.forEach { coordinate in
            path?.add(coordinate)
        }
        
        route?.map = nil
        route = GMSPolyline(path: path)
        route?.map = mapView.mapView
    }
    
    //    private func addMarker() {
    //        let marker = GMSMarker(position: coordinate)
    //        marker.icon = GMSMarker.markerImage(with: .magenta)
    //        marker.title = "Привет"
    //        marker.snippet = "Красная площадь"
    //        marker.map = mapView.mapView
    //        self.marker = marker
    //    }
    //
    //        private func removeMarker() {
    //            marker?.map = nil
    //            marker = nil
    //        }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        //        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Текущее", style: .done, target: self, action: #selector(currentLocation))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: updateLocationtTitle, style: .done, target: self, action: #selector(updateLocation))
    }
    
    // MARK: - Actions
    @objc func currentLocation (sender: UIBarButtonItem) {
        locationManager?.requestLocation()
        
    }
    
    @objc func updateLocation(sender: UIBarButtonItem) {
        
        if updateLocationtTitle == UpdateLocationEnum.on.rawValue {
            
            locationManager?.startUpdatingLocation()
            updateLocationtTitle = UpdateLocationEnum.off.rawValue
            
        } else {
            locationManager?.stopUpdatingLocation()
            updateLocationtTitle = UpdateLocationEnum.on.rawValue
            
        }
        setNavigationBar()
    }
    
    //    @objc func goTo (sender: UIBarButtonItem) {
    //        mapView.mapView.animate(toLocation: coordinate)
    //        mapView.mapView.animate(toZoom: 15)
    //
    //    }
    //
    //    @objc func toggleMarker(sender: UIBarButtonItem) {
    //        if marker == nil {
    //            addMarker()
    //        } else {
    //            removeMarker()
    //        }
    //    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            self.manualMarker = marker
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        geocoder?.reverseGeocodeLocation(location, completionHandler: { places, error in
            print(places?.last ?? coordinate)
        })
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinate = location.coordinate
        coordinates.append(coordinate)
        
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoomValue)
        mapView.mapView.camera = camera
        addMarker(position: coordinate)
        addPath(coordinates: coordinates)
        
        print(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

