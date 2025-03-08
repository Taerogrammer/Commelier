//
//  DetailViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: BaseViewController {
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    private let titleView = DetailTitleView()

    override func configureHierarchy() {

    }

    override func configureLayout() {

    }

    override func configureView() {
        bind()
    }

    override func configureNavigation() {

    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func bind() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input: input)

        output.data
            .withLatestFrom(output.data)
            .bind(with: self) { owner, value in
                owner.titleView.image.kf.setImage(with: URL(string: value.first!.image))
                owner.titleView.id.text = value.first?.symbol.uppercased()
                owner.navigationItem.titleView = owner.titleView
            }
            .disposed(by: disposeBag)

    }
}
