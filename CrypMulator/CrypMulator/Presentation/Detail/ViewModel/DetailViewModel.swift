//
//  DetailViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let request: TickerDetailRequest

    init(request: TickerDetailRequest) {
        self.request = request
        print("request ==> ", request)
    }

    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
