//
//  ViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit

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
        

        collectionView.register(
            OnBoardingCollectionViewCell.self,
            forCellWithReuseIdentifier: "OnBoardingCollectionViewCell"
        )

        return collectionView
    }()

    lazy private var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("지금 사용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }


}

extension ViewController {
    
    func setupLayout() {
        [collectionView,pageControl, deleteButton].forEach{
            view.addSubview($0)
        }

        collectionView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(600)
        }
        
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(48)
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
        
        deleteButton.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            
        }
        
        print(collectionView.visibleCells.count)
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
         //인덱스 패스 위치로 컬렉션 뷰를 스크롤
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func moveVC() {
        for i in 0...2  {
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCollectionViewCell {
                cell.animationView.stop()
            }
        }
        
        let vc = UINavigationController(rootViewController: MapViewController())
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = vc
    }
    

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        // 좌표보정을 위해 절반의 너비를 더해줌
        let x = scrollView.contentOffset.x + (width/2)

        let newPage = Int(x / width)
        let indexPath = IndexPath(item: newPage, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? OnBoardingCollectionViewCell {
            if !cell.animationView.isAnimationPlaying {
                cell.animationView.play()
            }
        }
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath) as? OnBoardingCollectionViewCell
        cell?.setup(lotties: indexPath.row)

        return cell ?? UICollectionViewCell()
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
