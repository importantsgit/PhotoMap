//
//  PhotoDescriptionView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/02.
//

import UIKit
import SnapKit

class PhotoDescriptionView: UIView {
    
    var photo: Photo?
    
    let separatorView = SeparatorView(frame: .zero)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "제목"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "용인시 용인구 용인동 22020"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "사진에 대한 설명을 입력하세요\n dssksdksdksdkskd"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.lineHeight(fontSize: 24)
        label.textColor = .darkText
        label.textAlignment = .left
        
        return label
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
        [titleLabel, locationLabel, separatorView, descriptionLabel ].forEach{
            addSubview($0)
        }
        titleLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        
        locationLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        separatorView.snp.makeConstraints{
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(64)
        }
        
    }
    
    func getPhoto(photo: Photo) {
        titleLabel.text = photo.title
        locationLabel.text = photo.locationName
        descriptionLabel.text = photo.discipline
    }
}
