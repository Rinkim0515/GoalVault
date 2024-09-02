//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

class FinancialPlanCreateVC: UIViewController {
    private var financialPlanCreateView: FinancialPlanCreateView
    
    init(textFieldArea: CreateTextView) {
        self.financialPlanCreateView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    override func loadView() {
        view = financialPlanCreateView
    }
}

// MARK: - 화면전환관련
extension FinancialPlanCreateVC {
    private func setupActions() {
        financialPlanCreateView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        let financialPlanConfirmVC = FinancialPlanConfirmVC()
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
    }
}

