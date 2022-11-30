//
//  CameraViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/28.
//

import UIKit
import SnapKit
import AVFoundation


enum Mode {
    case view
    case select
}

class CameraViewController: UIViewController {
    

    
    // MARK: - Variable
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let self = self else {return}
                    self.captureSession.startRunning()
                }

                takePhotoButton.isEnabled = true
                takePhotoButton.isHidden = false
                selectButtonItem.title = "Select"
                self.navigationItem.rightBarButtonItems = [selectButtonItem]
                collectionView.allowsMultipleSelection = false
                collectionView.snp.remakeConstraints{
                    $0.height.equalTo(120)
                    $0.leading.trailing.equalToSuperview()
                }


                collectionView.reloadData()
                UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self] in
                    guard let self = self else { return }
                    self.view.layoutIfNeeded()
                },completion: nil)
                
            case .select:
                captureSession.stopRunning()
                takePhotoButton.isEnabled = false
                takePhotoButton.isHidden = true
                selectButtonItem.title = "Cancel"
                self.navigationItem.rightBarButtonItems = [selectButtonItem, deleteButtonItem]
                collectionView.allowsMultipleSelection = true
                collectionView.snp.remakeConstraints{
                    $0.top.equalToSuperview().inset(150)
                    $0.leading.trailing.equalToSuperview()
                }

                collectionView.reloadData()
                UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self] in
                    guard let self = self else { return }
                    self.view.layoutIfNeeded()
                },completion: nil)
            }
        }
    }
    
    private var captureSession = AVCaptureSession()
    
    private let photoOutput = AVCapturePhotoOutput()
    
    var photoList: [UIImage] = [] {
        didSet {
            if photoList.count == 0 {
                numberLabel.layer.opacity = 0
                maxLabel.layer.opacity = 0
            } else {
                numberLabel.layer.opacity = 1
                maxLabel.layer.opacity = 1
                numberLabel.text = "\(photoList.count)"
            }
            UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self] in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
            },completion: nil)
        }
    }
    
    // PhotoView 띄우기 위해 변수 설정
    var photoView = PhotoView()
    
    // snapKit에 상수값만 받기 때문에 변수로 설정
    var width: CGFloat?
    var height: CGFloat?
    
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    
    //MARK: - Components
    
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
    
    lazy private var takePhotoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        let image = UIImageView(image: UIImage(named: "photo"))
        button.addSubview(image)
        image.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 4
        
        return stackView
    }()
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.applyShadow()
        label.layer.opacity = 0
        
        return label
        
    }()
    
    private var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 8"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.applyShadow()
        label.layer.opacity = 0
        
        return label
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        return collectionView
    }()
    
    //MARK: - NavigationBarItem
    lazy var deleteButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonItemTapped))
        
        return button
    }()
    
    lazy var selectButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "선택",style: .plain, target: self, action: #selector(selectButtonItemTapped))
        
        return button
    }()
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        checkPermissions()

    }
    //MARK: - viewWillDisappear (stopRunning)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraLiveView()
        width = view.frame.width
        height = view.frame.height
        setupBarButtonItems()
    }
}

//MARK: - extension
extension CameraViewController {
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItems = [selectButtonItem]
    }
    
    private func setupLayout() {
        title = ""
        view.backgroundColor = .black
        
        [takePhotoButton, button, stackView, collectionView, photoView].forEach{
            view.addSubview($0)
        }

        takePhotoButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(32)
        }
        
        stackView.snp.makeConstraints{
            $0.leading.equalTo(collectionView).offset(36)
            $0.bottom.equalToSuperview().inset(48)
            $0.width.equalTo(48)
            $0.height.equalTo(40)
        }
        
        [numberLabel, maxLabel].forEach{
            stackView.addArrangedSubview($0)
        }
        
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        photoView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(5)
            $0.height.equalTo(5)
        }
        photoView.layer.opacity = 0
        photoView.delegate = self
        photoView.backgroundColor = .black
        
        button.snp.makeConstraints{
            $0.centerY.equalTo(takePhotoButton)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(64)
        }
    }
    
    @objc func buttonTapped() {
        self.dismiss(animated: true)
    }
    
    // trashButtonItem클릭 시 반응
    @objc func deleteButtonItemTapped() {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath{
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item}) {
            photoList.remove(at: i.item)
        }
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
    }
    
    //selectButtonItem클릭 시 반응
    @objc func selectButtonItemTapped() {
        mMode = mMode == .view ? .select : .view
    }
    
    // MARK: setupCameraLiveView
    // 사진을 찍기 위한 카메라 작업
    private func setupCameraLiveView() {
        captureSession.sessionPreset = .hd1280x720
        
        // MARK: making input
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
            /*
             -[AVCaptureSession startRunning] should be called from background thread. Calling it on the main thread can lead to UI unresponsiveness
             */
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else {return}
                self.captureSession.startRunning()
            }
            setupLayout()

        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // 1
        case .notDetermined: // 아직 결정 안함
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in // Alert
                if !granted {
                    showPermissionsAlert()
                }
            }
            // 2
        case .denied, .restricted:
            showPermissionsAlert()
            // 3
        default:
            return
        }
    }
    
    private func showPermissionsAlert() {
        showAlert(
            withTitle: "카메라 접근",
            message: "유저의 카메라를 사용하기 위해 설정에서 접근권한을 설정하셔야 합니다.")
    }
    
    @objc private func handleTakePhoto() {
            let photoSetting = AVCapturePhotoSettings()
            if let photoPreviewType = photoSetting.availablePreviewPhotoPixelFormatTypes.first {
                photoSetting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
                photoOutput.capturePhoto(with: photoSetting, delegate: self)
            }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        if photoList.count < 8 {
            photoList.append(previewImage!)
            collectionView.reloadData()
        } else {
            showAlert(withTitle: "사진 갯수 제한", message: "사진은 최대 8장까지 연속으로 찍을 수 있습니다.")
        }
        self.navigationItem.rightBarButtonItem?.isHidden = false

        let vc = PhotoPreviewViewController()
        vc.photoImageView.image = previewImage
        //MARK: 이거 꼭 기억하자
        vc.delegate = self
       // self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - UICollectionViewDataSource

extension CameraViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        if photoList.count > 0 {
            cell.setup(image: photoList[indexPath.row], text: "\(indexPath.row + 1)")
            cell.isSelected = false
            cell.isHighlighted = false
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.height - 20
        if mMode == .select {
            size = (collectionView.frame.width / 2) - 32.0
        }
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            //TODO: 이 곳에 select 클릭 안할 시 구현할 메소드 작성
            collectionView.deselectItem(at: indexPath, animated: true)
            photoView.setImageView(image: photoList[indexPath.row], indexPathRow: indexPath.row)
            photoView.layer.opacity = 1
            self.navigationController?.navigationBar.isHidden = true
            self.photoView.layer.opacity = 1
            self.photoView.snp.updateConstraints{
                $0.center.equalToSuperview()
                $0.width.equalTo(width!)
                $0.height.equalTo(height!)
            }
            
            UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self]  in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
            },completion: { [weak self] _ in
                guard let self = self else { return }
                self.photoView.setupLayout()
            })
            
        case .select:
            //TODO: 이 곳에 select 클릭 시 구현할 메소드 작성
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {

        return true
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
    }
    
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        
    }
}

extension CameraViewController: ChildViewControllerDelegate {
    func childViewControllerResponse(image: UIImage) {
        photoList.append(image)
        print(photoList.count)
        collectionView.reloadData()
    }
}

extension CameraViewController: ChildViewDelegate {
    func deleteViewControllerImageItem(imageIndex: Int) {
        photoList.remove(at: imageIndex)
        if photoList.count < 1 {
            self.navigationItem.rightBarButtonItem?.isHidden = true
        }
        collectionView.reloadData()
        
        photoView.removeLayout()

        photoView.layer.opacity = 0
        self.photoView.snp.updateConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(5)
            $0.height.equalTo(5)
        }
        
        UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        },completion: nil)
    }
    
    func backViewController() {
        photoView.removeLayout()

        photoView.layer.opacity = 0
        self.photoView.snp.updateConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(5)
            $0.height.equalTo(5)
        }
        
        UIView.animate(withDuration: 0.2,delay: 0, options: .curveEaseInOut ,animations: { [weak self] in
            guard let self = self else { return }

            self.view.layoutIfNeeded()

        },completion: nil)
    }
}
