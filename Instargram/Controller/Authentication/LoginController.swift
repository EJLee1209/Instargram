//
//  LoginController.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/30.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    /*
     로그아웃 후 다른 계정으로 로그인을 하면,
     현재 로그인한 계정의 데이터를 가져와야해서
     로그인한 시점에 호출할 메서드를 Delegate 패턴으로 작성
     
     LoginController는 해당 프로토콜을 준수하는 ViewController를 delegate로서 가지고,
     로그인이 완료되는 시점에 authenticationComplete() 메서드를 호출하도록 delegate에게 지시함으로써
     delegate 즉, 대리자 역할을 하는 ViewController에서는 로그인 완료 시점을 알 수 있고,
     그 시점에서 필요한 로직을 처리한다.
     */
    func authenticationComplete()
}

class LoginController: UIViewController {
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeHolder: "Email")
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "Log In")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot you password?", secondPart:  "Get help signing in.")
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart:  "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        
    }
    
    //MARK: - Actions
    @objc func handleLogin() {
        viewModel.handleLogin { [weak self] in
            self?.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        if sender == passwordTextField {
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.barStyle = .black // status bar의 글자 색깔을 white로 변경해줌
        navigationController?.isNavigationBarHidden = true
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        // 로딩 상태 관찰자
        viewModel.handleLoadingState = { [weak self] in
            self?.loginButton.isLoading = self?.viewModel.isLoading ?? false
        }
    }
}

//MARK: - FormViewModel
/*
 RegistrationViewController에서도 동일한 작업을 수행해야하므로
 FormViewModel이라는 프로토콜을 채택하고, updateForm() 메서드를 구현하도록 함.
 코드를 훨씬 더 깔끔하게 만드는 방법임.
 */
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
