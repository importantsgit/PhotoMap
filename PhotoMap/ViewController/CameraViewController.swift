//
//  CameraViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/28.
//

import UIKit
import SnapKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    var photoList: [UIImage] = []
    
    var photoView = PhotoView()
    
    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]
    
    var width: CGFloat?
    var height: CGFloat?

    var selectMode = false
    var lastSelectedCell = IndexPath()
    
    var isSelectedArray: [Bool] = []
    
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
    
    lazy var deleteButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        checkPermissions()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraLiveView()
        width = view.frame.width
        height = view.frame.height
        navigationItem.rightBarButtonItems = [deleteButtonItem,editButtonItem]
        navigationItem.rightBarButtonItem?.isHidden = true
    }
}

extension CameraViewController {
    
    
    private func setupLayout() {
        title = ""
        view.backgroundColor = .black
        
        [takePhotoButton,button, collectionView, photoView].forEach{
            view.addSubview($0)
        }

        takePhotoButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(32)
        }
        
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
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
    
    @objc func buttonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        
    }
}

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
            cell.isEditing = false
        }
        

        return cell
    }
}

extension CameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("Tapped")
        if !isEditing {
            photoView.setImageView(image: photoList[indexPath.row], indexPathRow: indexPath.row)
            print("width: \(view.frame.width)")
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
        } else {
            
            
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
                cell.isEditing.toggle()

            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
  
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        // Returning `true` automatically sets `collectionView.isEditing`
        // to `true`. The app sets it to `false` after the user taps the Done button.
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
//        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
//            cell.isEditing.toggle()
//        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.collectionView.allowsMultipleSelection = editing
        self.collectionView.indexPathsForVisibleItems.forEach{ (indexPath) in
//            if let cell = collectionView.cellForItem(at: indexPath) as?         PhotoCollectionViewCell {
//                cell.isEditing = editing
//            }
        }
    }

    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        
        self.collectionView.indexPathsForVisibleItems.forEach{ (indexPath) in
            if let cell = collectionView.cellForItem(at: indexPath) as?         PhotoCollectionViewCell {
                cell.isEditing.toggle()
            }
        }
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
        
        UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseInOut ,animations: { [weak self] in
            guard let self = self else { return }

            self.view.layoutIfNeeded()

        },completion: nil)
    }
}
