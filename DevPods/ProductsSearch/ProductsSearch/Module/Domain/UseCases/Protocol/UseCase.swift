//
//  UseCase.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
