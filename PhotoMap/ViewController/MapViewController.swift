//
//  MapViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit

class MapViewController: UIViewController {

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
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
}
