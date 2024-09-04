//
//  MypageVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import SafariServices
import SnapKit
import UIKit


class MypageVC: UIViewController {
    
    private let mypageView = MypageView()
    
    let db = Firestore.firestore()
    
    
    // section headers
    private let headers: [String] = ["회원정보", "설정", "서비스 안내", "계정"]
    
    // 각 cell에 들어갈 정보
    private let data = [
        ["내 정보 관리"],
        ["알림 설정"],
        ["개인정보처리 방침"],
        ["로그아웃", "회원탈퇴"]
    ]
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view = mypageView
        
        mypageView.tableView.dataSource = self
        mypageView.tableView.delegate = self
        
        // 테이블뷰 등록 및 설정
        mypageView.tableView.register(MypageViewCell.self, forCellReuseIdentifier: "MypageViewCell")
        
        
        tableviewSetup()
        tableViewHeaderSetUp()
        
        setupAddtarget()
        checkLoginStatus()
        
    }
    
    
    //MARK: - 테이블뷰 관련 메서드
    func tableviewSetup() {
        view.addSubview(mypageView.tableView)
        
        mypageView.tableView.backgroundColor = .white
        
        // 테이블뷰를 부모 뷰의 크기에 맞게 조정해주어, 화면 전체에 테이블뷰가 잘 보이도록 설정
        mypageView.tableView.frame = view.bounds
        
        // 테이블뷰를 부모 뷰의 크기에 맞게 조정해주어, 화면 전체에 테이블뷰가 잘 보이도록 설정
        mypageView.tableView.frame = view.bounds
        
        // 테이블뷰 구분선 없애기
        mypageView.tableView.separatorStyle = .none
    }
    
    
    // 헤더 관련 설정
    private func tableViewHeaderSetUp() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
        header.backgroundColor = .systemPink
        
        // 닉네임
        var nicknameLabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.text = "춤추는 닭강정님"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        }()
        
        // 이메일
        let emailabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.font = .systemFont(ofSize: 18)
            label.textColor = .lightGray
            label.text = "dkswlgus0314@naver.com"
            return label
        }()
        
        [nicknameLabel, emailabel].forEach { header.addSubview($0)}
        [header].forEach {view.addSubview($0)}
        
        // 닉네임 오토레이아웃
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(28)
        }
        
        // 이메일 오토레이아웃
        emailabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
        }
        
        mypageView.tableView.tableHeaderView = header
    }
    
    
    //MARK: - func
    private func setupAddtarget() {
        // 로그아웃 버튼 이벤트
        mypageView.logoutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        // 회원탈퇴 버튼 이벤트
        mypageView.deleteUserButton.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
    }
    
    // 로그인VC으로 화면전환
    private func switchToLoginVC() {
        let loginVC = LoginVC()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
    
    // 개인정보 처리방침 url 연결
    private func privacyPolicyUrl () {
        let privacyPolicyUrl = NSURL(string: "https://valley-porch-b6d.notion.site/ce887a60fc15484f82f92194a3a44d2d")
        let safariView: SFSafariViewController = SFSafariViewController(url: privacyPolicyUrl as! URL)
        self.present(safariView, animated: true, completion: nil)
    }
    
    // TODO: 파베에서 현재 사용자를 가져올 때 권장하는 방법은 다음과 같이 Auth 객체에 리스너를 설정 해볼 것.
    
    // 현재 로그인한 사용자 아이디(이메일 정보)
    private func checkLoginStatus() {
        if let user  = Auth.auth().currentUser {
            // 로그인 상태라면
            print("사용자 uid: \(user.uid)")
            
            loadUserData(uid: user.uid)
            
            mypageView.userEmailLabel.text = "로그인 정보: \(user.email ?? "알 수 없는 이메일입니다.)")"
            
        } else {
            // 비로그인 상태라면
            mypageView.userEmailLabel.text = "로그인해주세요."
        }
    }
    
    
    //MARK: - loadUserData: 파이어베이스 사용자 회원가입 정보 읽기
    func loadUserData(uid: String) {
        //        db.collection("users").getDocuments { (snapshot, error) in
        //            if error == nil && snapshot != nil {
        //                for document in snapshot!.documents {
        //                    print(document.documentID)
        //                }
        //            } else {
        //                print("loadUserData 실패. \(error)")
        //            }
        //        }
        
        
        if let user  = Auth.auth().currentUser {
            db.collection("users").document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("No data found")
                    return
                }
                
                self.updateLabels(with: data)
            }
        }
    }
    
    func updateLabels(with data: [String: Any]) {
        if let nickname = data["nickname"] as? String {
            mypageView.nicknameLabel.text = "닉네임: \(nickname)"
        }
        
        if let birthday = data["birthday"] as? String {
            mypageView.birthdayLabel.text = "생년월일: \(birthday)"
        }
        
        if let gender = data["gender"] as? String {
            mypageView.genderLabel.text = "성별: \(gender)"
        }
        
        if let income = data["income"] as? String {
            mypageView.incomeLabel.text = "소득: \(income)"
        }
        
        if let location = data["location"] as? String {
            mypageView.locationLabel.text = "지역: \(location)"
        }
    }
    
    //MARK: - @objc 로그아웃
    @objc func logOutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("로그아웃하고 페이지 전환")
            
            //            showAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인")
            showSnycAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인", method: switchToLoginVC)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - @objc 회원탈퇴
    @objc func deleteUserButtonTapped() {
        if let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
                } else {
                    showSnycAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인", method: switchToLoginVC)
                }
            }
        } else {
            showAlert(message: "오류 발생", AlertTitle: "로그인 정보가 존재하지 않습니다", buttonClickTitle: "확인")
        }
        
    }
    
}
//


//MARK: - 마이페이지 테이블뷰 델리게이트
// 행의 높이, 선택 시의 동작, 헤더와 푸터의 커스터마이징 등
extension MypageVC: UITableViewDelegate {
    
    // 테이블뷰의 특정 셀을 선택했을 때 호출됨. 이 메서드에서 선택된 셀에 따라 동작을 정의할 수 있음
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("섹션 \(indexPath.section), 행 \(indexPath.row) 선택됨")
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            print("회원정보 수정 페이지로 이동하세요")
        case (1, 0):
            print("알림 받을건지 말건지 설정하세요")
        case (2, 0):
            print("개인정보처리방침으로 이동하세요")
            privacyPolicyUrl()
        case (3, 0):
            print("로그아웃 셀 클릭했습니다.")
            logOutButtonTapped()
        case (3, 1):
            print("회원탈퇴 셀 클릭했습니다.")
            deleteUserButtonTapped()
        default:
            break
        }
    }
    
    // 특정 셀의 높이를 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 80.0 : 50.0
        //        return 50.0
    }
    
    // 섹션 헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        // 섹션 헤더 상단에 간격 추가 (첫 번째 섹션에만 적용)
        if section == 0 {
            let topSpacingView = UIView()
            topSpacingView.backgroundColor = .systemGray5
            headerView.addSubview(topSpacingView)
            
            topSpacingView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(20) // 원하는 간격 크기
            }
        }
        
        // 각 섹션 별 섹션 타이틀의 폰트 및 위치 설정
        let titleLabel = UILabel()
        titleLabel.text = headers[section]
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
        }
        return headerView
    }
    
    // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    // 섹션 푸터뷰 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white
        
        // 섹션 간 구분선 설정
        let separatorLine = UIView()
        separatorLine.backgroundColor = .systemGray4
        footerView.addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        return footerView
    }
    
    // 섹션의 폰트와 폰트 크기, 폰트 색상 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16) // 폰트 크기와 스타일 변경
            header.textLabel?.textColor = .darkGray
        }
    }
}

//MARK: - 마이페이지 테이블뷰 데이터소스
//테이블뷰에 표시될 데이터를 관리
extension MypageVC: UITableViewDataSource {
    
    // 테이블뷰가 몇 개의 섹션을 가질지를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    // 각 섹션에 몇 개의 행이 있을지를 반환
    // -> 첫 번째 섹션(회원정보)에는 한 개의 행이 있고, 네 번째 섹션(계정)에는 두 개의 행이 있으므로 섹션 인덱스에 따라 다른 값을 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }
    
    // 특정 섹션의 특정 행에 표시될 셀을 구성하고 반환
    // indexPath.section과 indexPath.row를 사용해 해당 위치의 데이터를 찾아 셀에 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageViewCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        
        // 꺽쇠 표시 추가
        cell.accessoryType = .disclosureIndicator
        
        // 셀의 선택 효과를 없애기
        cell.selectionStyle = .none
        
        // "알림 설정" 셀에만 UISwitch 추가
        if indexPath.section == 1 && indexPath.row == 0 {
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = true // 기본적으로 스위치가 켜진 상태로 설정
            //            toggleSwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
            
            cell.accessoryView = toggleSwitch
        }
        
        return cell
    }
    
    
}

