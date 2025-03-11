//
//  TabBarController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTabBarAppearance()
    }

    private func configureTabBar() {
        let tickerVC = UINavigationController(rootViewController: TickerViewController())
        let trendingVC = UINavigationController(rootViewController: TrendingViewController())
        let portfolioVC = UINavigationController(rootViewController: PortfolioViewController())

        tickerVC.tabBarItem.title = "거래소"
        tickerVC.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        trendingVC.tabBarItem.title = "코인정보"
        trendingVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill")
        portfolioVC.tabBarItem.title = "포트폴리오"
        portfolioVC.tabBarItem.image = UIImage(systemName: "star")

        setViewControllers([tickerVC, trendingVC, portfolioVC], animated: true)
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .customBlack
    }
}
