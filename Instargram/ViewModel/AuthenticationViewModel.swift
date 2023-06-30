//
//  AuthenticationViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/30.
//

import Foundation
import UIKit

struct LoginViewModel {
    var email: String?
    var password: String?
    
    // 이메일, 패스워드 모두 입력됐는지 유효성 검사 후 Bool 값을 리턴하는 Computed Property
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    // 위의 유효성 검사 결과에 따라 다른 버튼 색을 리턴하는 Computed Property
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}

struct RegistrationViewModel {
    
}
