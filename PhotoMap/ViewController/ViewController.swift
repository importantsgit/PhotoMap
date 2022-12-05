//
//  ViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit
import Lottie

class ViewController: UIViewController {
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        pageControl.pageIndicatorTintColor = .systemGray6
        pageControl.currentPageIndicatorTintColor = .systemPurple
        pageControl.isSelected = false
        
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.accessibilityRespondsToUserInteraction = false
        

        collectionView.register(
            OnBoardingCollectionViewCell.self,
            forCellWithReuseIdentifier: "OnBoardingCollectionViewCell"
        )

        return collectionView
    }()

    private let slides: [OnBoardSlide] = OnBoardSlide.collection

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .systemBackground
    }
}

extension ViewController {
    
    func setupLayout() {
        [collectionView,pageControl].forEach{
            view.addSubview($0)
        }

        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
         //인덱스 패스 위치로 컬렉션 뷰를 스크롤
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func handleActionButtonTapped(at indexPath: IndexPath){
        if indexPath.row == slides.count - 1 {
            // 마지막 인덱스
            showMainApp()
        } else {
            let indexItem = indexPath.row + 1
            let nextIndexPath = IndexPath(item: indexItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
        }
    }
    
    private func showMainApp() {
        let vc = UINavigationController(rootViewController: MapViewController())
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = vc
            
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        // 좌표보정을 위해 절반의 너비를 더해줌
        let x = scrollView.contentOffset.x + (width/2)

        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath) as? OnBoardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        let slide = slides[indexPath.row]
        cell.setup(with: slide)
        // 이렇게 데이터 전달이 가능하다.
        cell.actionButtonTap = { [weak self] in
            guard let self = self else { return }
            self.handleActionButtonTapped(at: indexPath)
        }
        cell.animationView.play()
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
}


//https://swiftsenpai.com/development/lottie-animation-markers/
