//
//  AlertViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/10/25.
//

import UIKit
import SnapKit


final class AlertViewController: BaseViewController {
    private let alertView = AlertView()
    weak var delegate: AlertViewDismissDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func configureHierarchy() {
        view.addSubview(alertView)
    }

    override func configureLayout() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }

    override func configureView() {
        view.backgroundColor = UIColor.customGray.withAlphaComponent(0.6)
        alertView.backgroundColor = UIColor.white
        alertView.retryButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.alertViewDismiss()
    }

    @objc func tapped() {
        dismiss(animated: true)
    }
}
