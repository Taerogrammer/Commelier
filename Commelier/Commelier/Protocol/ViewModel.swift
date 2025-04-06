//
//  ViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

protocol ViewModel: AnyObject {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
