//
//  TabBarController.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureController()
    }
    
    func configureController() {
        //테스트에서만 쓰이는 이미지 입니다. 직접 이미지 넣어주면 됩니다.
        guard let unselectImage = UIImage(systemName: "multiply.circle.fill") else { return }
        guard let selectImage = UIImage(systemName: "multiply.circle.fill") else { return }
        

        let mainPage = tabBarNavigationController(unselectedImage: unselectImage, selectedImage: selectImage, isNavigationBarHidden: true, rootViewController: FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView()))
        let diary = tabBarNavigationController(unselectedImage: unselectImage, selectedImage: selectImage, isNavigationBarHidden: false, rootViewController: MoneyDiaryVC(moneyDiaryView: MoneyDiaryView()))

        let financialPlan = tabBarNavigationController(unselectedImage: unselectImage, selectedImage: selectImage, isNavigationBarHidden: false, rootViewController: FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView()))
        //        let myPage = tabBarNavigationController(unselectedImage: unselectImage, selectedImage: selectImage, isNavigationBarHidden: false, rootViewController: FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView()))
        
        //로그인 기능 추가 중이라 로그인뷰컨으로 임시 교체-지현
        let myPage = tabBarNavigationController(unselectedImage: unselectImage, selectedImage: selectImage, isNavigationBarHidden: false, rootViewController: LoginVC())
        viewControllers = [mainPage, diary, financialPlan, myPage]
    }
    
    //MARK: 제네릭으로 navigationController 안쓰는 뷰면 나눠서 반환해주게끔 개선 하면 좋을거 같음
    func tabBarNavigationController(unselectedImage: UIImage, selectedImage: UIImage, isNavigationBarHidden: Bool, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.isNavigationBarHidden = isNavigationBarHidden
        nav.navigationBar.tintColor = .systemBlue
        return nav
    }
}
