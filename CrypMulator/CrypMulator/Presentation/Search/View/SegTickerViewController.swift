//
//  SegTickerView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import SnapKit

final class SegTickerViewController: BaseViewController {
    private let label = UILabel()

    override func configureHierarchy() {
        view.addSubview(label)
    }

    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        label.text = "거래소 항목은 준비중입니다."
    }
}
