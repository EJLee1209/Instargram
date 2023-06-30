//
//  AuthenticationViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/30.
//

import Foundation
import UIKit

protocol FormViewModel {
    func updateForm()
}

// LoginViewModel, RegistrationViewModel 다음 3가지 계산 속성을 구현해야 하므로 프로토콜을 만들어서 관리함.
protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
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
    
    func handleLogin(currentVC: UIViewController){
        guard let email = self.email else { return }
        guard let password = self.password else { return }
        AuthService.logUserIn(withEmail: email, password: password) { [weak currentVC] result, error in
            if let error = error {
                print("DEBUG: Failed to log user in \(error.localizedDescription)")
                return
            }
            currentVC?.dismiss(animated: true)
        }
    }
    
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var profileImage: UIImage?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    func handleSignUp(currentVC: UIViewController) {
        guard let email = self.email else { return }
        guard let password = self.password else { return }
        guard let fullname = self.fullname else { return }
        guard let username = self.username?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credentials) { [weak currentVC] error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            currentVC?.dismiss(animated: true)
        }
    }
}
