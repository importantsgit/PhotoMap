//
//  photoView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import Photos
import SnapKit

protocol ChildViewControllerDelegate {
    func childViewControllerResponse(image: UIImage)
}

class PhotoPreviewViewController: UIViewController {
    var delegate: ChildViewControllerDelegate?
    

    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy private var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancel))
        return button
    }()

    lazy private var savePhotoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(handleSavePhoto))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension PhotoPreviewViewController {
    
    private func setupLayout() {
        self.navigationItem.rightBarButtonItems = [cancelButton, savePhotoButton]
        
        [photoImageView].forEach{
            view.addSubview($0)
        }
    
        photoImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    @objc private func handleCancel() {
            self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSavePhoto() {
        guard let previewImage = self.photoImageView.image else { return }
        delegate?.childViewControllerResponse(image: photoImageView.image ?? UIImage())
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)


                        DispatchQueue.main.async {
                            self.showAlert(withTitle: "사진 저장", message: "사진을 저장합니다", "저장")
                            self.handleCancel()
                        }
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}
