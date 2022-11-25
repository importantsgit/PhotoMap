//
//  MapView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

protocol sendAlert{
    func showAlert(withTitle title: String, message: String) -> Void
}

class MapView: UIView{
    var delegate: sendAlert?
    
    let map = MKMapView()
    
    var KoreaCenter = CLLocation(latitude: 37.51204043684012, longitude: 126.96601111097554)
    
    var locationManager = CLLocationManager()
    
    private lazy var button: UIButton = {
        // lazy를 입력해야지 addTarget이 적용됨
        let button = UIButton()

        button.clipsToBounds = true
        
        let image = UIImageView(image: UIImage(named: "precision"))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.contentMode = .scaleToFill
        button.addSubview(image)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 32
        
        button.applyShadow()
        image.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.bottom.equalToSuperview().inset(8)
        }
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        
        [map, button].forEach{
            self.addSubview($0)
        }
        
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(64)
        }
        


        map.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView {
    func setup() {
        map.showsUserLocation = true
        map.centerToLocation(KoreaCenter)
        ConstrainingTheCamera()
        checkPermissions()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 거리 정확도 설정


        
    }
    
    func checkPermissions() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .denied:
            // 거부 상태라면 알럿을 띄워 허용하도록 유도하는 코드를 넣을 수 있다.
            showPermissionsAlert()
        case .notDetermined, .restricted:
            // request
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }

        // 위치 범위가 대략적 범위로 되어있다면 정확한 위치를 공유하도록 요청하기
//        switch locationManager.accuracyAuthorization {
//        case .reducedAccuracy:
//            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "")
//        case .fullAccuracy:
//            // 이미 정확한 위치를 공유하고 있는데 또 요청하면 오류가 발생한다.
//            break
//        @unknown default:
//            break
//        }
//    }
    
    }
    
    func showPermissionsAlert() {
        delegate?.showAlert(
            withTitle: "위치 정보 접근",
            message: "유저의 위치 정보를 사용하기 위해 설정에서 접근권한을 설정하셔야 합니다.")
    }
    

    func ConstrainingTheCamera() {
        // 카메라 제한을 거는
        let oahuCenter = KoreaCenter
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000
        )
        map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        map.setCameraZoomRange(zoomRange, animated: true)
    }
    
    @objc func buttonTapped() {
        map.centerToLocation(KoreaCenter)
    }
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 정보를 계속 업데이트 합니다. -> 위도 경도 받아옴
        if let location = locations.first {
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
            let center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            KoreaCenter = center
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위도 경도 받아오기 에러
        delegate?.showAlert(withTitle: "위치 정보 받아오기 실패", message: "Error:\(error)")
    }
    

}
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        // 현재 보기 원하는 지역으로 애니메이션 자동 전환함
        
        
        setRegion(coordinateRegion, animated: true)
        // MKMapView로 표시되는 영역을 표시하도록 지시
    }
    
}
