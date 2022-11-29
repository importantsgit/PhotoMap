//
//  CameraViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/28.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
//    lazy var backButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonTapped))
//
//        return button
//    }()
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        checkPermissions()
        setupCameraLiveView()
    }
}


extension CameraViewController {
    
    private func setupLayout() {
        title = ""
        
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
            
            // TODO: setupUI 작성
            //self.setupUI()
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
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}


