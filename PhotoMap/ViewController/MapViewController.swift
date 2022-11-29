//
//  MapViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit

class MapViewController: UIViewController, sendAlert {

    private var mapView = MapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        mapView.setup()
    }
}

extension MapViewController {
    private func setupLayout() {
        title = "Map"
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func presentVC() {
        let vc = CameraViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
