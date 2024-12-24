//
//  MainPageVC.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import DGCharts
import SafariServices
import UIKit

class MainPageVC: UIViewController {
    private let mainPageView: MainPageView = MainPageView()
    private let chartDataManager = ChartDataManager()
    private let assetsCoreDataManager = AssetsCoreDataManager()
    private let financialPlanManager = FinancialPlanManager.shared
    private let diaryCoreDataManager = DiaryCoreDataManager.shared
    var dataEntries: [PieChartDataEntry] = []
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

        
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainPageView
        setupCenterButtonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        

        setChart()
        //        requestNotification()
    }
    
    //MARK: - Methods
    private func setupCenterButtonEvent() {
        mainPageView.chartCenterButton.addTarget(self, action: #selector(editViewPush), for: .touchUpInside)
    }
    
    private func setupTableView() {
        mainPageView.benefitVerticalTableView.delegate = self
        mainPageView.benefitVerticalTableView.dataSource = self
        
        mainPageView.benefitVerticalTableView.register(BenefitVerticalCell.self, forCellReuseIdentifier: "BenefitVerticalCell")
    }
    
    
    // 알림 권한 요청
    //    private func requestNotification() {
    //        NotificationManager.shared.requestAuthorization { [weak self] granted in
    //            DispatchQueue.main.async {
    //                  if granted {
    //                      // 알림 권한이 허용된 경우
    //                      print("알림 권한이 허용되었습니다.")
    //                      NotificationManager.shared.setNotificationEnabled(userID: Auth.auth().currentUser?.uid)
    //                  } else {
    //                      // 알림 권한이 거부된 경우
    //                      print("알림 권한이 거부되었습니다.")
    //                      // 알림 비활성화 시 알림 취소
    //                      NotificationManager.shared.cancelAllNotifications()
    //                  }
    //              }
    //        }
    //    }
    
    func setChart() {
        // 차트에서 표현할 데이터 리스트
        var assetsList = chartDataManager.assetsToChartData(array: assetsCoreDataManager.selectAllAssets())
        let financialPlan = chartDataManager.planToChartData(array: financialPlanManager.fetchAllFinancialPlans(), title: "플랜 자산")
        let diary = chartDataManager.diaryToChartData(array: diaryCoreDataManager.fetchDiaries())
        
        assetsList.append(financialPlan)
        assetsList.append(diary)
        assetsList.sort { $0.title! < $1.title! }
        
        let data = chartDataManager.pieChartPercentageData(array: assetsList)
        let entries = data.0
        let totalAmount = data.1
        
        let predefinedColors: [UIColor] = [
            UIColor(hex: "#3FB6DC"), // 청록색
            UIColor(hex: "#2DC76D"), // 녹색
            UIColor(hex: "#FF7052"), // 주황색
            UIColor(hex: "#FFC107"), // 노란색
            UIColor(hex: "#FF5722"), // 진한 주황색 계열
            UIColor(hex: "#8BC34A"), // 연한 녹색 계열
            UIColor(hex: "#673AB7"), // 보라색 계열
            UIColor(hex: "#9C27B0"), // 밝은 보라색 계열
            UIColor(hex: "#00BCD4"), // 하늘색 계열
            UIColor(hex: "#E91E63") // 분홍색 계열
        ]
        
        var dataSet: PieChartDataSet
        if entries.count != 0 {
            dataSet = PieChartDataSet(entries: entries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
            
            // 미리 정의된 색상 배열을 섹터에 맞춰 순환하여 적용
            dataSet.colors = entries.enumerated().map { index, _ in
                return predefinedColors[index % predefinedColors.count]
            }
            
            dataSet.valueColors = dataSet.colors.map { _ in
                return .darkGray
            }
            mainPageView.chartCenterButton.setTitle("자산목록 보기", for: .normal)
            mainPageView.pieChartView.alpha = 1.0
        } else {
            // 데이터 없을시 더미데이터
            let entries = [
                PieChartDataEntry(value: 40, label: "자동차"),
                PieChartDataEntry(value: 30, label: "부동산"),
                PieChartDataEntry(value: 20, label: "현금"),
                PieChartDataEntry(value: 10, label: "주식")
            ]
            
            dataSet = PieChartDataSet(entries: entries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
            dataSet.colors = [
                UIColor.lightGray,
                UIColor.darkGray,
                UIColor.gray,
                UIColor.black
            ]
            dataSet.valueColors = dataSet.colors.map { _ in
                return .white
            }
            mainPageView.chartCenterButton.setTitle("등록된 자산이 없습니다.\n자산을 등록해 주세요", for: .normal)
            mainPageView.pieChartView.alpha = 0.5
        }
        let chartData = PieChartData(dataSet: dataSet)
        mainPageView.pieChartView.data = chartData
        mainPageView.totalAssetsValueLabel.text = "\(KoreanCurrencyFormatter.shared.string(from:(Int64(totalAmount)))) 원"
    }
    
    @objc func editViewPush() {
        navigationController?.pushViewController(AssetsListVC(), animated: true)
    }
    
}



extension MainPageVC: UITabBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 사파리 연결
        let benefitKey = Array(Benefit.shared.benefitData.keys)[indexPath.row]
        guard let url = URL(string: Benefit.shared.benefitData[benefitKey] ?? "") else { return }
        let safariVC = SFSafariViewController(url: url)
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(safariVC, animated: true, completion: nil)
        }
    }
}

//MARK: - 청년혜택 총정리
extension MainPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension MainPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Benefit.shared.benefitData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitVerticalCell", for: indexPath) as? BenefitVerticalCell else {
            return UITableViewCell()
        }
        
        let title = Array(Benefit.shared.benefitData.keys.sorted(by: >))[indexPath.row]
        cell.titleLabel.text = title
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let imageName = "benefit\(indexPath.row + 1)"
        cell.cellIconView.image = UIImage(named: imageName)
        
        return cell
    }
}
