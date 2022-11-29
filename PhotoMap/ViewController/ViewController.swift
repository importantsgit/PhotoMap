//
//  ViewController.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/11/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let label: UILabel = {
       
        let label = UILabel()
        label.text = """
        내용
        """
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var button: UIButton = {
        // lazy를 입력해야지 addTarget이 적용됨
        let button = UIButton()
        button.setTitle("SKIP", for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .blue
        
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }


}

extension ViewController {
    
    func setupLayout() {
        [label, button].forEach{
            view.addSubview($0)
        }

        label.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    @objc func moveVC() {
        let tabbarVC = UINavigationController(rootViewController: MapViewController())
        tabbarVC.modalTransitionStyle = .crossDissolve
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: true)
    }
    

}
