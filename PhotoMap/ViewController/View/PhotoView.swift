//
//  PhotoView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/29.
//

import UIKit
import SnapKit

protocol ChildViewDelegate {
    func deleteViewControllerImageItem(imageIndex: Int)
    
    func backViewController()
}

class PhotoView: UIView {
    
    var delegate: ChildViewDelegate?
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImageView(image: UIImage(systemName: "xmark"))
        button.addSubview(image)
        button.tintColor = .systemPurple
        image.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let containerView = UIImageView()

        containerView.contentMode = .center
        containerView.clipsToBounds = true
        containerView.backgroundColor = .black
        return containerView
    }()
    
    var imageIndex: Int?
    
    lazy private var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("DELETE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView].forEach{
            addSubview($0)
        }
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoView {
    func setupLayout() {
        [cancelButton, deleteButton].forEach{
            addSubview($0)
        }
        
        cancelButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(25)
        }
        
        deleteButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    
    func removeLayout() {
        [cancelButton, deleteButton].forEach{
            $0.removeFromSuperview()
        }
    }
    
    func setImageView(image: UIImage, indexPathRow: Int) {
        imageView.image = image
        imageIndex = indexPathRow
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteViewControllerImageItem(imageIndex: imageIndex ?? 0)
        imageView.image = UIImage()
        
        findViewController()?.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func backButtonTapped() {
        delegate?.backViewController()
        imageView.image = UIImage()
        findViewController()?.navigationController?.navigationBar.isHidden = false
    }
}
