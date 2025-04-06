//
//  ReuseIdentifiable.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

protocol ReuseIdentifiable: AnyObject { }

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
