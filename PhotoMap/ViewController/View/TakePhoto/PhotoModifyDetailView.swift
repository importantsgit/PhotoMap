//
//  DetailView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit
import SnapKit

class PhotoModifyDetailView: UIView {
    
    let placeHolder = "내용을 입력하세요"
    
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
        // setupKeyBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoModifyDetailView {
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
        
        addDoneButtonOnKeyBoard(titleTextView)
        addDoneButtonOnKeyBoard(descriptionTextView)
    }
    
    func setupLabel(title: String?, description: String?) {
        if let title = title,
           let description = description {
            titleTextView.text = title
            descriptionTextView.text = description
            titleTextView.textColor = .black
            descriptionTextView.textColor = .black
        }
    }
    
    func addDoneButtonOnKeyBoard(_ textView: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let next: UIBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextButtonTapped))
        
        let prev: UIBarButtonItem = UIBarButtonItem(title: "이전", style: .plain, target: self, action: #selector(prevButtonTapped))
        
        done.tintColor = .black
        let items = [flexSpace,prev,next,done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonTapped() {
        if titleTextView.isFirstResponder {
            titleTextView.resignFirstResponder()
        } else {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    @objc func nextButtonTapped() {
        if titleTextView.isFirstResponder {
            descriptionTextView.becomeFirstResponder()
        } else {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    @objc func prevButtonTapped() {
        if descriptionTextView.isFirstResponder {
            titleTextView.becomeFirstResponder()
        } else {
            titleTextView.resignFirstResponder()
        }
    }
}

extension PhotoModifyDetailView: UITextViewDelegate {
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

