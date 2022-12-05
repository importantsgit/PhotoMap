//
//  DetailView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    let placeHolder = "알람과 함께 띄울 문장을 입력하세요"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "제목을 입력하세요"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.lineHeight(fontSize: 24)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 13)
        view.text = placeHolder
        view.textColor = .lightGray
        view.delegate = self
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "사진에 대한 설명을 입력하세요"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.lineHeight(fontSize: 24)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 13)
        view.text = placeHolder
        view.textColor = .lightGray
        view.delegate = self
        view.layer.cornerRadius = 4
        
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

extension DetailView {
    func setupLayout() {
        [titleLabel,titleTextView,descriptionLabel,descriptionTextView ].forEach{
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        titleTextView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(48)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(titleTextView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        descriptionTextView.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(300)
            $0.bottom.equalToSuperview().inset(64)
        }
    }
    
    func setupText(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

extension DetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
    }
}
