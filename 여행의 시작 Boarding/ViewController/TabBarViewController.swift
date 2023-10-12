//
//  TabBarViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import AVFoundation

class TabBarViewController: UITabBarController {
    
    let picker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBar()
    }
    
    func setUpTabBar() {
        // Set CustomTabBar
        let customTabBar = CustomTabBar()
        customTabBar.centerButtonActionHandler = {
            self.cameraButtonPressed()
        }
        customTabBar.tabbarColor = Gray.white
        customTabBar.tabBarItemColor = Boarding.blue
        customTabBar.unselectedItemColor = Gray.light
        customTabBar.buttonImage = UIImage(named: "Plus")
        setValue(customTabBar, forKey: "tabBar")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Pretendard.regular(12)], for: .normal)
        
        // ViewController Connect
        let homeVC = UINavigationController(rootViewController: NewHomeViewController())
        homeVC.tabBarItem.image = UIImage(named: "Home")
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -5, vertical: 0)
        
        let planVC = UINavigationController(rootViewController: PlanViewController())
        planVC.tabBarItem.image = UIImage(named: "Plan")
        planVC.tabBarItem.title = "플랜"
        planVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        
        let recordVC = UINavigationController(rootViewController: RecordViewController())
        recordVC.tabBarItem.image = UIImage(named: "Record")
        recordVC.tabBarItem.title = "기록"
        recordVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 30, vertical: 0)
        
        let myPageVC = ChangableNavigationController(rootViewController: MyPageViewController())
        myPageVC.tabBarItem.image = UIImage(named: "MyPage")
        myPageVC.tabBarItem.title = "마이페이지"
        myPageVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        
        setViewControllers([homeVC, planVC, recordVC, myPageVC], animated: true)
    }
    
    func cameraButtonPressed() {
        #if targetEnvironment(simulator)
        fatalError()
        #endif
        // 카메라 권한 취소되어있을 때 Alert
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            if isAuthorized {
                self?.openCamera()
            } else {
                self?.goSetting()
            }
        }
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "현재 카메라 사용에 대한 접근 권한이 없습니다.", message: "설정 > Boarding탭에서 접근을 활성화 할 수 있습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        let confirm = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingURL) else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            let cameraVC = CameraViewController()
            cameraVC.modalPresentationStyle = .overCurrentContext
            cameraVC.modalTransitionStyle = .coverVertical
            self.present(cameraVC, animated: true)
        }
    }
}
