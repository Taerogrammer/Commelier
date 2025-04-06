//
//  UIButton+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Combine
import UIKit

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        publisherForEvent(.touchUpInside)
    }
}
