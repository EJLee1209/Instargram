//
//  InputTextView.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import UIKit

class InputTextView: UITextView {
    //MARK: - Properties
    
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            } else {
                placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8
                )
            }
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 6,
            paddingLeft: 8
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
