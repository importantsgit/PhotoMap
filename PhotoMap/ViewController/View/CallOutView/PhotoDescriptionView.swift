//
//  PhotoDescriptionView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/02.
//

import UIKit
import SnapKit

class PhotoDescriptionView: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoDescriptionView {
    func setupLayout() {
        [containerView].forEach{
            addSubview($0)
        }
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(700)
        }
    }
}
