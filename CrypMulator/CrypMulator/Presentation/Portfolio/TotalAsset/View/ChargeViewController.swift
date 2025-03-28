//
//  ChargeViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class ChargeViewController: BaseViewController {

    override func configureView() {
        let lbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "테스트"

            return lbl
        }()

        view.addSubview(lbl)

        lbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
