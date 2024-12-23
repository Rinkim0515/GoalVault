//
//  SceneDelegate.swift
//  Smssme
//
//  Created by 전성진 on 8/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = TabBarController()
        
//        window.rootViewController = MoneyDiaryCreationVC(diaryManager: DiaryCoreDataManager(), transactionItem2: Diary())
//        window.rootViewController = TabBarController()
        
        window.makeKeyAndVisible()
        
        self.window = window
        
    }
    

    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    // 이메일 인증 메일 및 비밀번호 재설정 링크 클릭 후 다시 앱으로 돌아옵니다.
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

