//
//  SearchViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Toast

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureView() {
        
    }
}
