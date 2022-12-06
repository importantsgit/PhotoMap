//
//  DetailView.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
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
    
    func setupKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue

        if titleTextView.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textView: titleTextView)
            //self.findViewController()?.view.frame.origin.y = 0 - keyboardRectangle.height
        }
        else if descriptionTextView.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textView: descriptionTextView)
            //self.findViewController()?.view.frame.origin.y = 0 - keyboardRectangle.height
        }

    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        //self.findViewController()?.view.transform.
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textView: UITextView){
        print(self.titleTextView.frame.maxY)
        guard let view = self.findViewController()?.view else { return }
        view.transform = CGAffineTransform(translationX: 0, y: 0 - keyboardRectangle.height /*(view.frame.height - keyboardRectangle.height - textView.frame.maxY)*/)
    }
    
    func addDoneButtonOnKeyBoard(_ textView: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        
        let next: UIBarButtonItem = UIBarButtonItem(title: "다음", style: .done, target: self, action: #selector(nextButtonTapped))
        
        done.tintColor = .black
        let items = [flexSpace,next,done]
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

