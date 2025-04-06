//
//  CustomNumberPadView.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Combine
import UIKit
import SnapKit

final class CustomNumberPadView: BaseView {

    var buttonTapped = PassthroughSubject<String, Never>()

    private let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["00", "0", "←"]
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        for row in buttons {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 12
            hStack.distribution = .fillEqually

            for title in row {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.setTitleColor(SystemColor.white, for: .normal)
                button.titleLabel?.font = SystemFont.Title.large
                button.backgroundColor = SystemColor.black
                button.layer.cornerRadius = 8
                button.addAction(UIAction(handler: { [weak self] _ in
                    self?.buttonTapped.send(title)
                }), for: .touchUpInside)

                hStack.addArrangedSubview(button)
            }

            stackView.addArrangedSubview(hStack)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
