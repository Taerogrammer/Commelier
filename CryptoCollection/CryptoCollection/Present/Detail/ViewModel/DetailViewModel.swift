//
//  DetailViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let id: Observable<String>

    struct Input {

    }

    struct Output {

    }

    init(id: String) {
        self.id = Observable.just(id)
    }

    func transform(input: Input) -> Output {

        return Output()
    }
}
