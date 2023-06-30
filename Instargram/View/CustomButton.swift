//
//  CustomButton.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import UIKit

class CustomButton: UIButton {
    var spinner = UIActivityIndicatorView()
    var isLoading = false {
        didSet {
            updateView()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configureUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        layer.cornerRadius = 5
        setHeight(50)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        isEnabled = false
        
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.style = .large
        
        addSubview(spinner)
        spinner.center(inView: self)
    }
    
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0
            isEnabled = false // 중복 터치 방지
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            isEnabled = true
        }
    }
}
