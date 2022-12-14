//
//  ClickCallOutViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import UIKit
import SnapKit

class ClickCallOutViewController: UIViewController {
    
    var photo: Photo?
    var prevPhoto: Photo?
    
    var DeleteActionButtonTap: ((_ prevPhoto: Photo)-> Void)?
    var addActionButtonTap: ((_ updatePhoto: Photo)-> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let photosSectionView = PhotosSectionView(frame: .zero)
    let photoDescriptionView = PhotoDescriptionView(frame: .zero)
    
    lazy var settingButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(settingButtonItemTapped))
        
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
    }
    
    func updatePhoto(title: String, discipline: String, imageFile: [UIImage]) {
        guard let photo = photo else { return }
        photo.title = title
        photo.discipline = discipline
        photo.imagefile = imageFile.map({$0.pngData()!})
        photosSectionView.photoList = imageFile
        photoDescriptionView.getPhoto(photo: photo)
        photosSectionView.collectionView.reloadData()
        
        pushPhoto()
    }
}

private extension ClickCallOutViewController {
    func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = settingButtonItem
        setupNavigationBar()
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
        
        if let photo = photo {
            photosSectionView.photoList = photo.getImage() ?? [UIImage()]
            photoDescriptionView.getPhoto(photo: photo)
        }
        
        prevPhoto = photo
    }
    
    func pushPhoto() {
        guard let photo = photo,
              let prevPhoto = prevPhoto
        else { return }
        
        self.DeleteActionButtonTap?(prevPhoto)
        self.addActionButtonTap?(photo)
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
    

    
    @objc func settingButtonItemTapped() {
        let alertController = UIAlertController(title: "설정", message: nil, preferredStyle: .actionSheet)
        let modiftyAlertAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let vc = ModifyViewController()
            vc.photo = self.photo
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let deleteAlertAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self = self,
                  let viewControllerStack = self.navigationController?.viewControllers,
                  let prevPhoto = self.prevPhoto
            else { return }
            for stack in viewControllerStack {
                if let vc = stack as? MapViewController {
                    self.DeleteActionButtonTap?(prevPhoto)
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        alertController.addAction(modiftyAlertAction)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alertController, animated: true)
    }
}
