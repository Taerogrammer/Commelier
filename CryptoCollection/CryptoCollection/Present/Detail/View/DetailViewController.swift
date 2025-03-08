//
//  DetailViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: BaseViewController {
    let viewModel: DetailViewModel

    override func configureView() {
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
}
