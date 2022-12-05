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
    
    var actionButtonTap: (()-> Void)?
    
    var animationView: LottieAnimationView = {
        var uiView = LottieAnimationView(frame: .zero)
        uiView.contentMode = .scaleAspectFit
        uiView.loopMode = .loop
        return uiView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "안녕하세여"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.lineHeight(fontSize: 24)
        label.textColor = .label
        
        return label
    }()
    
    lazy private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("지금 사용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    func setup(with slide: OnBoardSlide){
        label.text = slide.title
        nextButton.setTitle(slide.buttonTitle, for: .normal)
        nextButton.backgroundColor = slide.buttonColor
        let animation = LottieAnimation.named(slide.animationName)
        animationView.animation = animation
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
        setupLayout()

    }
    
}

extension OnBoardingCollectionViewCell {
    private func setupLayout() {
        [animationView, label, nextButton].forEach{
            addSubview($0)
        }
        
        animationView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(340)
            $0.height.equalTo(animationView.snp.width)
        }
        
        label.snp.makeConstraints{
            $0.top.equalTo(animationView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(140)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    
    @objc func moveVC() {
        actionButtonTap?()
    }
    

}

extension UILabel{
    func lineHeight(fontSize: CGFloat) {
        let style = NSMutableParagraphStyle()
        let lineHeight = fontSize
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = .center
        self.baselineAdjustment = .none
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2,
            ])

        
    }
}
