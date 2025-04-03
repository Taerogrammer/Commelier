//
//  PortfolioViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit
import SnapKit

final class PortfolioViewController: BaseViewController {
    private let segmentedControl = UnderlineSegmentedControl(items: [StringLiteral.Portfolio.assetOverview, StringLiteral.Portfolio.transaction])
    private let totalAssetViewController: TotalAssetViewController
    private let transactionViewController: TradeHistoryViewController
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)

    var segViewControllers: [BaseViewController] {
        [totalAssetViewController, transactionViewController]
    }
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [segViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil)
        }
    }

    init(totalAssetViewController: TotalAssetViewController, transactionViewController: TradeHistoryViewController) {
        self.totalAssetViewController = totalAssetViewController
        self.transactionViewController = transactionViewController
        super.init()
    }

    override func configureHierarchy() {
        view.addSubviews([segmentedControl, pageViewController.view])

    }

    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(4)
            make.top.equalTo(segmentedControl.snp.bottom).offset(4)
        }
    }

    override func configureView() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 12)
        ], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)

        pageViewController.delegate = self
        pageViewController.dataSource = self


    }

    override func configureNavigation() {
        navigationItem.title = StringLiteral.NavigationTitle.portfolio
    }
}

// MARK: - @objc
extension PortfolioViewController {
    @objc private func changeValue(control: UISegmentedControl) {
        print(#function)
      self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - page view controller
extension PortfolioViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController),
        index - 1 >= 0
      else { return nil }
      return self.segViewControllers[index - 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController),
        index + 1 < self.segViewControllers.count
      else { return nil }
      return self.segViewControllers[index + 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool
    ) {
      guard
        let viewController = pageViewController.viewControllers?[0],
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController)
      else { return }
      self.currentPage = index
      self.segmentedControl.selectedSegmentIndex = index
    }
}

