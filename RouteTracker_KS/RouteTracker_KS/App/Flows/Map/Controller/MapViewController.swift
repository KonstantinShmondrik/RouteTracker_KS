//
//  ViewController.swift
//  RouteTracker_KS
//
//  Created by Константин Шмондрик on 17.10.2022.
//

import UIKit
import GoogleMaps


final class MapViewController: UIViewController {
    
    private var mapView: MapView {
        return self.view as! MapView
    }
    
    private var marker: GMSMarker?
    private var manualMarker: GMSMarker?
    
    private let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
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
        
    }
    
    // MARK: - Privat func
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.mapView.camera = camera
        mapView.mapView.delegate = self
    }
    
    private func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .magenta)
        marker.title = "Привет"
        marker.snippet = "Красная площадь"
        marker.map = mapView.mapView
        self.marker = marker
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "на красную площадь", style: .done, target: self, action: #selector(goTo))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "маркер", style: .done, target: self, action: #selector(toggleMarker))
    }

    // MARK: - Actions
    @objc func goTo (sender: UIBarButtonItem) {
        mapView.mapView.animate(toLocation: coordinate)
        mapView.mapView.animate(toZoom: 15)
        
    }
    
    @objc func toggleMarker(sender: UIBarButtonItem) {
        if marker == nil {
            addMarker()
        } else {
            removeMarker()
        }
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            self.manualMarker = marker
        }
    }
    
}

