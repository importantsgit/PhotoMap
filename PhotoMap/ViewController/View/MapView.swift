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



class MapView: UIView{
    
    let map = MKMapView()
    
    var userCenter = CLLocation()
    
    var locationManager = CLLocationManager()
    
    lazy var photos: [Photo] = [] {
        didSet {
            print("Photo: \(photos.count)")
            print("annotations: \(map.annotations.count)")
        }
    }

    private lazy var button: UIButton = {
        // lazy를 입력해야지 addTarget이 적용됨
        let button = UIButton()
        
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
    
    private lazy var cameraButton: UIButton = {
        // lazy를 입력해야지 addTarget이 적용됨
        let button = UIButton()
        
        let image = UIImageView(image: UIImage(named: "camera"))
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.contentMode = .scaleToFill
        button.addSubview(image)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 32
        button.applyShadow()
        image.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        map.register(PhotoAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //MARK: test!!
        //deleteing()
 
        [map, button, cameraButton].forEach{
            self.addSubview($0)
        }
        
        button.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(64)
            $0.top.equalTo(cameraButton.snp.bottom).offset(16)
        }
        
        cameraButton.snp.makeConstraints{

            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(64)
        }
    
        map.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView {
    func setup() {
        // map.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        // map.userTrackingMode = MKUserTrackingMode.followWithHeading
        map.showsUserLocation = true
        ConstrainingTheCamera()
        checkPermissions()
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 거리 정확도 설정
        // 베터리로 동작할 때 권장되는 가장 높은 수준의 정확도
        
        //로케이션 매니저의 distanceFilter 속성을 사용하면 어느 정도 거리의 위치 변화가 생겼을 때 앱이 알림을 받을지 말지를 설정할 수 있다.
        locationManager.distanceFilter = 10
        
        //MARK: map.userlocation을 가져오지 말고 locationManager에서 가져오자!
        userCenter = locationManager.location ?? CLLocation(latitude: 37.553326059065206, longitude: 126.97277126191183)
        map.centerToLocation(userCenter)
    }
    
    private func checkPermissions() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // print("GPS 권한 설정됨")
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
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Navigation")
        case .fullAccuracy:
            // 이미 정확한 위치를 공유하고 있는데 또 요청하면 오류가 발생한다.
            // print("정확한 값 가져오는 중")
            break
        @unknown default:
            break
        }
    }
    
    func showPermissionsAlert() {
        self.findViewController()?.showAlert(
            withTitle: "위치 정보 접근",
            message: "유저의 위치 정보를 사용하기 위해 설정에서 접근권한을 설정하셔야 합니다.")
    }
    

    func ConstrainingTheCamera() {
        // 자신의 위치로 맵을 이동시키는 메소드
        let center = userCenter
        let region = MKCoordinateRegion(
            center: center.coordinate,
            latitudinalMeters: 0.1,
            longitudinalMeters: 0.1
        )
        map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        map.setCameraZoomRange(zoomRange, animated: true)
    }
    
    @objc func buttonTapped() {
        map.centerToLocation(userCenter)
    }
    
    @objc func cameraButtonTapped() {
        let vc = CameraViewController()
        vc.userCenter = userCenter
        self.findViewController()?.view.opacityDownAnimationPushing(vc: vc)
    }
    
    func updateAnnotations(photo: Photo) {
        photos.append(photo)
        map.addAnnotations(photos)
    }
    
//    func photosList() -> [Photo] {
//        guard let data = UserDefaults.standard.value(forKey: "photos") as? Data,
//              let photos = try? PropertyListDecoder().decode([Photo].self, from: data) else {return []}
//        return photos
//    }
    
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 정보를 계속 업데이트 합니다. -> 위도 경도 받아옴
        if let location = locations.first {
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
            let center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            userCenter = center
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위도 경도 받아오기 에러
        self.findViewController()?.showAlert(withTitle: "위치 정보 받아오기 실패", message: "Error:\(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // 영역 안으로 들어오면
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // 영역 밖으로 나가면
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

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let photo = view.annotation as? Photo else {
            return
        }
        
        let vc = ClickCallOutViewController()
        vc.photo = photo
        vc.DeleteActionButtonTap = { [weak self] prev in
            guard let self = self else { return }
            self.map.removeAnnotation(prev)
            self.photos.removeAll(where: {$0.id == prev.id})
        }
        vc.addActionButtonTap = {[weak self] update in
            guard let self = self else { return }
            self.photos.append(update)
            self.map.addAnnotation(update)
        }
        
        self.findViewController()?.view.opacityDownAnimationPushing(vc: vc)
    }
}
