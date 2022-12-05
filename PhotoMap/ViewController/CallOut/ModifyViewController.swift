//
//  modifyViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit
import SnapKit

final class ModifyViewController: UIViewController {
    
    var photo: Photo?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let photosSectionView = PhotosSectionView(frame: .zero)
    let photoDetailView = DetailView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
        setupNavigationBar()

    }
}

private extension ModifyViewController {
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

        [photosSectionView, photoDetailView].forEach{
            contentView.addSubview($0)
        }
        
        photosSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        photoDetailView.snp.makeConstraints {
            $0.top.equalTo(photosSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        photosSectionView.photoList = photo?.imagefile ?? [UIImage()]
//        photoDetailView.setupText(title: photo?.title, description: photo?.description)

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
