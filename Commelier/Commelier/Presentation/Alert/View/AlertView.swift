//
//  AlertView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/10/25.
//

import UIKit
import SnapKit

final class AlertView: BaseView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let lineView = BaseView()
    let messageLabel = UILabel()
    let retryButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(stackView)
        [titleLabel, messageLabel, lineView, retryButton].forEach { stackView.addArrangedSubview($0) }
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        retryButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
    }

    override func configureView() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = SystemColor.label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textColor = SystemColor.label
        lineView.backgroundColor = SystemColor.divider
        retryButton.setTitle("다시 시도하기", for: .normal)
        retryButton.setTitleColor(SystemColor.label, for: .normal)
        retryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        titleLabel.text = "안내"
        messageLabel.text = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
    }

}
