//
// Created by Chope on 2017. 5. 18..
// Copyright (c) 2017 Chope. All rights reserved.
//

import Foundation

open class ErrorController {
    public var onError: (()->Void)?

    private var failureCount: Int = 0

    private let threshold: Int

    public init(threshold: Int) {
        self.threshold = threshold
    }

    public func reset() {
        failureCount = 0
    }

    public func fail() {
        failureCount += 1

        if failureCount == threshold {
            onError?()
        }
    }
}
