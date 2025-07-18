//
//  BaseView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit

class BaseView: UIView, ViewConfiguration {
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = SystemColor.black
        configureHierarchy()
        configureLayout()
        configureView()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() { }

    func configureLayout() { }

    func configureView() { }

    func bind() { }
}
