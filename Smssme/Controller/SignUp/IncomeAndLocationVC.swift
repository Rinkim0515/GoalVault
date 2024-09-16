//
//  IncomeAndLocationVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

// 성별
class IncomeAndLocationVC: UIViewController {
    private let emailView = EmailView()
    private let passwordView = PasswordView()
    private let nicknameView = NickNameView()
    private let incomeAndLocationView = IncomeAndLocationView()
    
    private var selectedCheckBox: UIButton?
    private let incomePickerView = UIPickerView()
    private let locationPickerView = UIPickerView()
    
    var userData = UserData()
    
    // 소득 구간 선택지
    let pickerIncomeData = [
        "1,200만 원 이하",
        "1,200만 원 초과 ~ 4,600만 원 이하",
        "4,600만 원 초과 ~ 8,800만 원 이하",
        "8,800만 원 초과 ~ 1억 5천만 원 이하",
        "1억 5천만 원 초과 ~ 3억 원 이하",
        "3억 원 초과 ~ 5억 원 이하",
        "5억 원 초과 ~ 10억 원 이하",
        "10억 원 초과"]
    
    // 지역 선택지
    let pickerLocationData = ["서울" , "경기도", "인천" , "부산" , "강원도" ,"대구", "전라도", "충청도", "경상도", "광주", "울산", "대전" , "제주도"]
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = incomeAndLocationView
        self.navigationItem.title = "(4/4)"
        
        incomeAndLocationView.nextButton.backgroundColor = .systemBlue
        incomeAndLocationView.nextButton.isEnabled = true
        
        incomePickerView.tag = 1
        locationPickerView.tag = 2
        
        setupAddtarget()
        configPickerView()
        configToolbar()
        
        //        incomeAndLocationView..addTarget(self, action: #selector(textFieldEditingChanged(_:, _:)), for: .editingChanged)
        incomeAndLocationView.incomeTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        incomeAndLocationView.locationTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        incomeAndLocationView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - func
    private func setupAddtarget() {
        
        //        if let user = Auth.auth().currentUser {
        //            signupView.signupButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        //        } else {
        //            // 회원가입 버튼 클릭
        //            signupView.signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        //        }
        //체크박스 버튼 클릭 시
        incomeAndLocationView.maleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        incomeAndLocationView.femaleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        incomeAndLocationView.noneCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
//        userData.gender = incomePickerView.text
        userData.income = incomeAndLocationView.incomeTextField.text
        userData.location = incomeAndLocationView.locationTextField.text
        
        
        // 모든 정보가 입력되었으므로 Firebase에 저장
        FirebaseManager.shared.registerUser(email: userData.email ?? "", password: userData.password ?? "") { result in
               switch result {
               case .success(let uid):
                   FirebaseManager.shared.saveUserData(uid: uid, userData: self.userData) { saveResult in
                       switch saveResult {
                       case .success:
                           print("사용자 정보 저장 성공")
                           // 로그인 화면으로 전환
//                           DispatchQueue.main.async {
//                               let loginVC = LoginVC()
//                               loginVC.toastMessage = "회원가입 완료!"
//                               self.navigationController?.setViewControllers([loginVC], animated: true)
//                           }
                       case .failure(let error):
                           print("사용자 정보 저장 실패: \(error.localizedDescription)")
                       }
                   }
               case .failure(let error):
                   print("회원가입 실패: \(error.localizedDescription)")
               }
           }
        
        showSnycAlert(message: "회원가입이 완료되었습니다. \n감사합니다.", AlertTitle: "회원가입 성공", buttonClickTitle: "확인") {
            SplashViewController().showLoginVC()
        }
        
        
    }
    
    // 피커뷰 "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        if incomeAndLocationView.locationTextField.isFirstResponder {
            let locationRow = locationPickerView.selectedRow(inComponent: 0)
            incomeAndLocationView.locationTextField.text = pickerLocationData[locationRow]
            print("선택한 위치: \(incomeAndLocationView.locationTextField.text ?? "")")
        } else if incomeAndLocationView.incomeTextField.isFirstResponder {
            let incomeRow = incomePickerView.selectedRow(inComponent: 0)
            incomeAndLocationView.incomeTextField.text = pickerIncomeData[incomeRow]
            print("선택한 소득구간: \(incomeAndLocationView.incomeTextField.text ?? "")")
        }
        
        // 텍스트필드 입력 마치고 키보드 숨기기
        incomeAndLocationView.incomeTextField.resignFirstResponder()
        incomeAndLocationView.locationTextField.resignFirstResponder()
    }
    
    // 피커뷰 "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        incomeAndLocationView.incomeTextField.text = nil
        incomeAndLocationView.locationTextField.text = nil
        incomeAndLocationView.incomeTextField.resignFirstResponder()
        incomeAndLocationView.locationTextField.resignFirstResponder()
    }
    
    
    // 모든 내용 입력돼야 버튼 활성화
    @objc private func textFieldEditingChanged(_ textField: UITextField,_ checkBox: UIButton) {
        
//        guard
//            //            let gender = incomeAndLocationView.maleCheckBox.isSelected ? "male" : incomeAndLocationView.femaleCheckBox.isSelected ? "female" : incomeAndLocationView.noneCheckBox.isSelected ? "none" : nil ,
//            let income = incomeAndLocationView.incomeTextField.text,
//            let location = incomeAndLocationView.locationTextField.text
//        else { return }
//        
//        if !income.isEmpty && !income.isEmpty {
//            incomeAndLocationView.nextButton.backgroundColor = .systemBlue
//            incomeAndLocationView.nextButton.isEnabled = true
//        } else {
            incomeAndLocationView.nextButton.backgroundColor = .systemGray5
            incomeAndLocationView.nextButton.isEnabled = false
        
        
//        }
        
//        }
        
    }
    
    //MARK: - 성별 체크박스
    @objc func checkBoxTapped(_ checkBox: UIButton) {
        // 이미 다른 체크박스가 선택된 상태에서 새로운 체크박스를 선택하려는 경우
        if let selected = selectedCheckBox, selected != checkBox {
            showAlert(message: "중복선택이 불가합니다.", AlertTitle: "경고", buttonClickTitle: "확인")
            return
        }
        
        // 현재 선택된 체크박스가 동일한 경우 선택 해제
        if selectedCheckBox == checkBox {
            checkBox.isSelected = false
            selectedCheckBox = nil
            print("체크박스 선택 해제됨")
        } else {
            // 새로운 체크박스를 선택
            checkBox.isSelected = true
            selectedCheckBox = checkBox
            
            if let tagType = GenderTags(rawValue: checkBox.tag) {
                switch tagType {
                case .male:
                    print("tag: \(GenderTags(rawValue: 1)) - 남성 체크박스 선택됨")
                case .female:
                    print("tag: \(checkBox.tag) - 여성 체크박스 선택됨")
                case .none:
                    print("tag: \(checkBox.tag) - 선택안함 체크박스 선택됨")
                }
            }
            
        }
    }
}


//MARK: - extension - PickerView
extension IncomeAndLocationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    private func configPickerView() {
        
        // 소득구간
        incomePickerView.delegate = self
        incomePickerView.dataSource = self
        incomeAndLocationView.incomeTextField.inputView = incomePickerView //텍스트필드 눌렀을 때 뜨는 뷰(inputView)
        
        // 지역
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        incomeAndLocationView.locationTextField.inputView = locationPickerView
        
    }
    
    // 피커뷰의 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커뷰에 표시될 항목 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.incomePickerView {
            return pickerIncomeData.count
        } else if pickerView == self.locationPickerView {
            return pickerLocationData.count
        } else {
            return 0
        }
    }
    
    // 특정 위치(row)번째 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.incomePickerView {
            return pickerIncomeData[row]
        } else if pickerView == self.locationPickerView {
            return pickerLocationData[row]
        } else {
            return ""
        }
    }
    
    // 텍스트필드의 텍스트를 선택된 문자열로 변환
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView)
        if pickerView == self.incomePickerView {
            incomeAndLocationView.incomeTextField.text = pickerIncomeData[row]
        } else {
            incomeAndLocationView.locationTextField.text = pickerLocationData[row]
        }
    }
    
    // 툴바 구성
    private func configToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)  //취소~완료 간의 거리
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        incomeAndLocationView.incomeTextField.inputAccessoryView = toolBar
        incomeAndLocationView.locationTextField.inputAccessoryView = toolBar
    }
}

//MARK: - extension - TextField
extension IncomeAndLocationVC: UITextFieldDelegate {
    
}