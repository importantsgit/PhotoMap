//
//  modifyViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/05.
//

import UIKit
import SnapKit

final class ModifyViewController: UIViewController {
    
    var photo: Photo?
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    let photosSectionView = PhotoModifySectionView(frame: .zero)
    let photoDetailView = DetailView(frame: .zero)
    var scrollHeight: CGFloat = 0.0
    
    lazy private var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 업로드", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemPurple
        button.applyShadow()
        button.layer.cornerRadius = 24
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLayout()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyBoard()
    }
}

private extension ModifyViewController {
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        title = "수정하기"
        
    }

    func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [photosSectionView, photoDetailView, uploadButton].forEach{
            contentView.addSubview($0)
        }
        
        photosSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        photoDetailView.snp.makeConstraints {
            $0.top.equalTo(photosSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.top.equalTo(photoDetailView.snp.bottom).offset(32)
            $0.bottom.equalToSuperview().inset(64)
        }
        
        photosSectionView.photoList = photo?.imagefile ?? [UIImage()]
        photoDetailView.setupLabel(title: photo?.title, description: photo?.discipline)
    }
    
    func setupKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        let titleTextView = photoDetailView.titleTextView
        let descriptionTextView = photoDetailView.descriptionTextView

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
        let descriptionTextView = photoDetailView.descriptionTextView
        let scrollViewHeight = scrollView.frame.height
        let contentViewHeight = contentView.frame.height
        if descriptionTextView.isFirstResponder {
            scrollView.setContentOffset(CGPoint(x: 0, y:  contentViewHeight - scrollViewHeight), animated: true)
        }
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textView: UITextView){
        guard let navibarHeight = navigationController?.navigationBar.frame.height else { return }
        let viewHeight = UIScreen.main.bounds.height + navibarHeight
        let buttonHeight = textView.frame.maxY + photoDetailView.frame.height
        let scrollHeight = scrollHeight
        print(viewHeight)
        print(self.photoDetailView.titleTextView.frame.maxY)
        print(self.photoDetailView.frame.minY)
        if keyboardRectangle.height > viewHeight + scrollHeight - buttonHeight {
            scrollView.setContentOffset(CGPoint(x: 0, y: (keyboardRectangle.height+buttonHeight) - (viewHeight + scrollHeight)), animated: true)
        }
    }
    
    @objc func uploadButtonTapped() {
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for stack in viewControllerStack {
            if let vc = stack as? ClickCallOutViewController {
                vc.photo = photo
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        // background와 shadow를 테마에 적절한 Color로 reset해줌
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.clear
        appearance.backgroundColor = .systemBackground
        
        // 적용
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}

extension ModifyViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollHeight = targetContentOffset.pointee.y
        print(scrollHeight)
    }
}
