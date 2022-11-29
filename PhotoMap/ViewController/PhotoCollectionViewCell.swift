//
//  PhotoCollectionViewCell.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/29.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var overrideView = UIView()
    
    var isEditing: Bool = false {
        didSet {
           
            overrideView.layer.opacity = isEditing ?  0.5 : 0
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
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
    
    func update(status:Bool?){
        
        if let status = status,
            status {
            overrideView.layer.opacity = 0.5
        } else {
            overrideView.layer.opacity = 0
        }
    }
}

private extension PhotoCollectionViewCell {
    func setupLayout() {
        [imageView, label, overrideView].forEach{
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(4)
        }
        
        overrideView.backgroundColor = .systemPurple
        overrideView.layer.opacity = 0
        overrideView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        self.applyShadow()
    }
    

}
