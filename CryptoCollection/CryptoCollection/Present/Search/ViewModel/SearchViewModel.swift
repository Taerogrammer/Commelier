//
//  SearchViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    enum SettingAction {
        case popViewController
    }

    private var searchText: String

    struct Input {
        let barButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let action: PublishRelay<SettingAction>
    }

    init(searchText: String) {
        self.searchText = searchText
    }

    func transform(input: Input) -> Output {
        let action = PublishRelay<SettingAction>()
        input.barButtonTapped
            .bind(with: self) { owner, _ in
                action.accept(SettingAction.popViewController)
            }
            .disposed(by: disposeBag)


        return Output(
            action: action)
    }
}
