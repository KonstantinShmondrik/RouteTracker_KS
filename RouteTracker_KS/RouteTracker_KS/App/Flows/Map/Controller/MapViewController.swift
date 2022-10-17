//
//  ViewController.swift
//  RouteTracker_KS
//
//  Created by Константин Шмондрик on 17.10.2022.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    private var mapView: MapView {
        return self.view as! MapView
    }
    
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        let view = MapView()
//        view.delegate = self
        self.view = view
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

