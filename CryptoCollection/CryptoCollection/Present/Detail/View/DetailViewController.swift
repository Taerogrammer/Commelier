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
    private let barButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: nil,
        action: nil)

    override func configureHierarchy() {

    }

    override func configureLayout() {

    }

    override func configureView() {
        bind()
    }

    override func configureNavigation() {
        navigationItem.leftBarButtonItem = barButton
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func bind() {
        let input = DetailViewModel.Input(
            barButtonTapped: barButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)


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
