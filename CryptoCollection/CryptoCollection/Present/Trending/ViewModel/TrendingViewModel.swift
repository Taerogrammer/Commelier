//
//  TrendingViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class TrendingViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    enum SettingAction {
        case navigateToDetail(String)
        case showAlert
    }

    struct Input {
        let searchBarTapped: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }

    struct Output {
        let action: Observable<SettingAction>
    }

    func transform(input: Input) -> Output {
        let action = PublishSubject<SettingAction>()

        input.searchBarTapped
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, text in
                action.onNext(text.count >= 2 ? SettingAction.navigateToDetail(text) : SettingAction.showAlert)
            }
            .disposed(by: disposeBag)

        return Output(action: action)
    }
}
