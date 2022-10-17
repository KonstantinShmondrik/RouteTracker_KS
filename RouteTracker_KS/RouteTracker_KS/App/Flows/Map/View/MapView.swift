//
//  MapView.swift
//  RouteTracker_KS
//
//  Created by Константин Шмондрик on 17.10.2022.
//

import UIKit
import GoogleMaps

class MapView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
      
        self.addSubview(self.mapView)
        
        
        NSLayoutConstraint.activate([
            
            self.mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            self.mapView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 0.0),
            self.mapView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,constant: 0.0),
            self.mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: 0.0),
            
           
        ])
    }
    
}
