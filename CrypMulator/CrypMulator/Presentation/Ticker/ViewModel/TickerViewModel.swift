//
//  TickerViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import RxCocoa
import RxSwift

final class TickerViewModel: ViewModel {
    let tickerListViewModel: TickerListViewModel
    private let disposeBag = DisposeBag()

    init(tickerListViewModel: TickerListViewModel) {
        self.tickerListViewModel = tickerListViewModel
    }

    struct Input {

    }

    struct Output {
        let error: Observable<APIError>
    }

    func transform(input: Input) -> Output {
        return Output(error: tickerListViewModel.errorStream)
    }
}
