//
//  File.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/01.
//

import UIKit

// MARK: view에서 다른 뷰컨트롤러로 이동하는 방법
/*
 1. UIView에 이 메소드 추가
 2. UIView내에서 다른 ViewController에 접근하고 싶은 부분에
   self.findViewController().present(..) 입력하기
*/
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    // 응답자 체인을 이용하여 뷰컨트롤러 도달할 때까지 상위 뷰로 이동하는 메소드
    // AppDelegate로 계속 진행하게 코드를 바꿀 수 있음
    
    func opacityUpAnimation() {
        self.layer.opacity = 0
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 1
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.isHidden = true
        }
    }
    
    func opacityDownAnimationPushing(vc: UIViewController) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 0
            self.backgroundColor = vc.view.backgroundColor
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.findViewController()?.navigationController?.pushViewController(vc, animated: true)
            

        }
    }
    
    func opacityDownAnimationPopTo(vc: UIViewController) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 0
            self.backgroundColor = vc.view.backgroundColor
        } completion: { [weak self] finished in
            guard let self = self else { return }
            vc.view.layer.opacity = 1
            self.findViewController()?.navigationController?.popToViewController(vc, animated: true)
    
        }
    }
    
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 2,
        y: CGFloat = 2,
        blur: CGFloat = 10
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2.0
    }
}
