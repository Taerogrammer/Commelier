//
//  BaseViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit

class BaseViewController: UIViewController, ViewConfiguration {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
        configureDefaultSetting()
        bind()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }

    func configureLayout() { }

    func configureView() { }

    func configureNavigation() { }

    func configureDefaultSetting() {
        view.backgroundColor = SystemColor.background

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = SystemColor.background
        appearance.titleTextAttributes = [.foregroundColor: SystemColor.label]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = SystemColor.label
    }

    func bind() { }

    deinit {
        print(#function, self)
    }
}
