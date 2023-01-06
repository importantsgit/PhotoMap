//
//  PhotoSaveViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

final class PhotoSaveViewController: UIViewController {
    
    //MARK: - Variable

    var photoList: [UIImage] = []
    var userCenter = CLLocation()
    var geocoder = CLGeocoder()
    var scrollHeight: CGFloat = 0.0
    var locationName: String = ""

    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let photosSectionView = PhotoModifySectionView(frame: .zero)
    let photoDetailView = PhotoModifyDetailView(frame: .zero)

    
    lazy private var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 업로드", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
        setupLocation()
        setupKeyBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
}

extension PhotoSaveViewController {
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        title = "사진 업로드"
        setupNavigationBar()
    }
    
    private func setupLayout(){
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [photosSectionView, photoDetailView, uploadButton].forEach{
            contentView.addSubview($0)
        }
        
        photosSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        photoDetailView.snp.makeConstraints {
            $0.top.equalTo(photosSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.equalTo(photoDetailView.snp.bottom).offset(32)
            $0.bottom.equalToSuperview().inset(64)
        }
        
        photosSectionView.photoList = photoList
    }
    
    func setupLocation() {
        geocoder.reverseGeocodeLocation(userCenter,preferredLocale: Locale(identifier: "Ko-kr")) { [weak self] placeMarks, _ in
            guard let self = self,
                  let placeMark = placeMarks?.first
            else { return }
            DispatchQueue.main.async {
                let address = placeMark
                self.locationName = "\(address.country ?? "나라") \(address.administrativeArea ?? "도") \(address.locality ?? "시") \(address.name ?? "상세주소")"
                /*
                print(address.country!)  // 대한민국
                print(address.administrativeArea!) // 경기도
                print(address.locality!) // 시흥시
                print(address.name!) // 정왕동 1619-8
                print(address.isoCountryCode!) // KR
                print(address.subLocality!) // 정왕동
                print(address.subThoroughfare!) // 1619-8
                 */
            }
        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        // background와 shadow를 테마에 적절한 Color로 reset해줌
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.clear
        appearance.backgroundColor = .systemBackground
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemPurple]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemPurple]
        UINavigationBar.appearance().tintColor = .systemPurple
        
        // 적용
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    func setupKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        let titleTextView = photoDetailView.titleTextView
        let descriptionTextView = photoDetailView.descriptionTextView

        if titleTextView.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textView: titleTextView)
        }
        else if descriptionTextView.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textView: descriptionTextView)
        }

    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let descriptionTextView = photoDetailView.descriptionTextView
        let scrollViewHeight = scrollView.frame.height
        let contentViewHeight = contentView.frame.height
        if descriptionTextView.isFirstResponder {
            scrollView.setContentOffset(CGPoint(x: 0, y:  contentViewHeight - scrollViewHeight), animated: true)
        }
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textView: UITextView){
        guard let navibarHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = UIScreen.main.bounds.height + navibarHeight
        let buttonHeight = textView.frame.maxY + photoDetailView.frame.height
        let scrollHeight = scrollHeight
        if keyboardRectangle.height > viewHeight + scrollHeight - buttonHeight {
            scrollView.setContentOffset(CGPoint(x: 0, y: (keyboardRectangle.height+buttonHeight) - (viewHeight + scrollHeight)), animated: true)
        }
    }
    
    @objc func uploadButtonTapped() {
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        let photo = Photo(title: photoDetailView.titleTextView.text,
                          locationName: locationName,
                          discipline: photoDetailView.descriptionTextView.text,
                          coordinate: userCenter.coordinate,
                          imagefile: photosSectionView.photoList)
        for stack in viewControllerStack {
            if let vc = stack as? MapViewController {
                vc.mapView.updateAnnotations(photo: photo)
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}

extension PhotoSaveViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollHeight = targetContentOffset.pointee.y
    }
}

