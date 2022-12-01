//
//  OnBoardingCollectionViewCell.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/02.
//

import UIKit
import Lottie
import SnapKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    var animationView: LottieAnimationView = {
        var uiView = LottieAnimationView(frame: .zero)
        return uiView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "안녕하세여"
        label.textAlignment = .center
        
        return label
        
    }()
    
    func setup(lotties: Int){
        switch lotties {
        case 0:
            print("1")
        case 1:
            animationView = .init(name: "location")
        case 2:
            animationView = .init(name: "photo")
        default:
            animationView = .init(name: "photo")
            
        }
        setupLayout()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
    }
    
}

extension OnBoardingCollectionViewCell {
    func setupLayout() {
        [animationView, label].forEach{
            addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(340)
            $0.height.equalTo(animationView.snp.width)
        }
        
        label.snp.makeConstraints{
            $0.top.equalTo(animationView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    

}
