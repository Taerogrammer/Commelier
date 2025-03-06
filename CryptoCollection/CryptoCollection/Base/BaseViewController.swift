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

    func configureDefaultSetting() { }

    deinit {
        print(#function)
    }
}
