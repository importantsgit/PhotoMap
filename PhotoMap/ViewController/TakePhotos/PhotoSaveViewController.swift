//
//  PhotoSaveViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import UIKit
import MapKit
import SnapKit

final class PhotoSaveViewController: UIViewController {
    
    //MARK: - Variable

    
    var photoList: [UIImage] = []
    var userCenter = CLLocation()
    
    //MARK: - Components
    
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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0.0


        [
            uploadButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        uploadButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.bottom.equalToSuperview()
        }
        
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        // Do any additional setup after loading the view.
    }
}

extension PhotoSaveViewController {
    private func setupLayout(){
        scrollView.showsVerticalScrollIndicator = false
        
            view.addSubview(scrollView)
            scrollView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            }

            scrollView.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }

            contentView.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
    }
    
    @objc func uploadButtonTapped() {
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for stack in viewControllerStack {
            if let vc = stack as? MapViewController {
                vc.mapView.photolist = photoList
                navigationController?.popToViewController(vc, animated: true)
            }
        }

    }
}


