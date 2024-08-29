//
//  LoginView.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import SnapKit
import UIKit

final class LoginView: UIView {
    
    // 아이디, 비밀번호, 로그인 버튼의 공통된 높이
    private let textFieldHeight = 48
    
    // 로고 이미지
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // 아이디(이메일) 입력
    var emailTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "아이디(이메일)"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = .always
        return textField
    }()
    
    // 비밀번호 입력
    var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        return textField
    }()
    
    // 로그인 버튼
    let loginButton = BaseButton().createButton(text: "로그인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    // 아이디, 비밀번호, 로그인 stackView
    private var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //회원가입 버튼
    let signupButton = BaseButton().createButton(text: "회원가입", color: #colorLiteral(red: 0.9121415615, green: 0.9536862969, blue: 1, alpha: 1), textColor: UIColor.systemBlue)
    
    
    //비회원 로그인
    let unLoginButton = BaseButton().createButton(text: "로그인 없이 둘러보기", color: .clear, textColor: UIColor.gray)
    
    
    // TODO: - 자동로그인, 아이디 저장 추가 예정
    
    // 빈 화면 터치 시 키보드 내려감ㅋ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - setupUI
    private func configureUI() {
        self.backgroundColor = .white
        
        //loginStackView에 추가
        [emailTextField, passwordTextField, loginButton].forEach {loginStackView.addArrangedSubview($0)}
        
        //view에 추가
        [logoImageView,loginStackView, signupButton, unLoginButton].forEach {self.addSubview($0)}
        
    }
    
    private func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(100)
            $0.width.height.equalTo(100)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(textFieldHeight * 3 + 36) //스택뷰 spacing 간격 18
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }
        
        unLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signupButton.snp.bottom).offset(24)
        }
        
    }
    
    
    //MARK: - @objc
    @objc
    func passwordSecureMode() {
        passwordTextField.isSecureTextEntry.toggle()
    }
}