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
        let tickerVC = UINavigationController(rootViewController: TickerFactory.make())
        let trendingVC = UINavigationController(rootViewController: InformationViewController())
        let portfolioVC = UINavigationController(rootViewController: PortfolioViewController())

        tickerVC.tabBarItem.title = StringLiteral.TabBar.ticker
        tickerVC.tabBarItem.image = SystemIcon.chartLine
        trendingVC.tabBarItem.title = StringLiteral.TabBar.information
        trendingVC.tabBarItem.image = SystemIcon.chartBarFilled
        portfolioVC.tabBarItem.title = StringLiteral.TabBar.portfolio
        portfolioVC.tabBarItem.image = SystemIcon.chartPie

        setViewControllers([tickerVC, trendingVC, portfolioVC], animated: true)
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = SystemColor.black
    }
}
