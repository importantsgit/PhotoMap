//
//  PhotoCollectionViewCell.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/29.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var isEditing: Bool = false {
        didSet {
            //overrideView.layer.opacity = isEditing ?  0.5 : 0
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            overrideView.isHidden = !isHighlighted
        }
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            overrideView.isHidden = !isSelected
            checkView.isHidden = !isSelected
        }
    }
    
    var overrideView = UIView()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var checkView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white

        return label
    }()
    
    func setup(image: UIImage, text: String) {
        setupLayout()
        imageView.image = image
        label.text = text
    }
}

private extension PhotoCollectionViewCell {
    func setupLayout() {
        [imageView, label, overrideView, checkView].forEach{
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(4)
        }
        
        checkView.snp.makeConstraints{
            $0.bottom.trailing.equalToSuperview().inset(4)
            $0.width.height.equalTo(16)
        }
        
        overrideView.backgroundColor = .systemPurple
        overrideView.layer.opacity = 0.5
        overrideView.layer.cornerRadius = 8
        overrideView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        self.applyShadow()
    }
    

}

