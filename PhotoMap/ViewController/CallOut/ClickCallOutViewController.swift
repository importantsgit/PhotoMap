//
//  ClickCallOutViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import UIKit
import SnapKit

class ClickCallOutViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let photosSectionView = PhotosSectionView(frame: .zero)
    let photoDescriptionView = PhotoDescriptionView(frame: .zero)
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
        setupNavigationBar()

    }
}

private extension ClickCallOutViewController {
    func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

    func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [photosSectionView, photoDescriptionView].forEach{
            contentView.addSubview($0)
        }
        
        photosSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        photoDescriptionView.snp.makeConstraints {
            $0.top.equalTo(photosSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        photosSectionView.photoList = photo?.imagefile ?? [UIImage()]

    }
    
    func setupNavigationBar() {

        let appearance = UINavigationBarAppearance()
        // background와 shadow를 테마에 적절한 Color로 reset해줌
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = UIColor.clear
        
        // back버튼 색상
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        // 바 텍스트 색상
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        
        // 바 색상
        appearance.backgroundColor = .none
        
        // 적용
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}
