//
//  MapViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit
import CoreLocation



final class MapViewController: UIViewController {

    var mapView = MapView()
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        view.layer.opacity = 1

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        mapView.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

extension MapViewController {
    private func setupLayout() {
        title = "Map"
        [mapView].forEach{
            view.addSubview($0)
        }

        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String,_ buttonText: String = "OK") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: buttonText, style: .default))
            self.present(alertController, animated: true)
        }
    }
}


