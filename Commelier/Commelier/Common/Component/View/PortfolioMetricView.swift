//
//  PortfolioMetricView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import UIKit
import SnapKit

final class PortfolioMetricView: BaseView {

    private let contentLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String, initialValue: String = "0") {
        super.init(frame: .zero)
        self.contentLabel.text = title
        self.valueLabel.text = initialValue
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureHierarchy() {
        addSubviews([contentLabel, valueLabel])
    }

    override func configureLayout() {
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerY.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerY.equalToSuperview()
        }
    }

    override func configureView() {
        contentLabel.font = SystemFont.Body.primary
        contentLabel.textColor = SystemColor.label
        valueLabel.font = SystemFont.Body.boldPrimary
        valueLabel.textColor = SystemColor.label
    }

    func updateValue(_ value: Double) {
        valueLabel.text = String(value)
    }

    func updateValueFormatted(_ value: Double) {
        valueLabel.text = String(format: "%.2f%%", value)
    }

    func updateValue(_ text: String, color: UIColor) {
        valueLabel.text = text
        valueLabel.textColor = color
    }
}
