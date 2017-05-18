//
// Created by Chope on 2017. 5. 17..
// Copyright (c) 2017 Chope. All rights reserved.
//

import Foundation

public struct AdPlatformQueue<T: Equatable> {
    public var current: T {
        return queue[index]
    }
    public var count: Int {
        return queue.count
    }
    
    private var queue: [T]
    private var index: Int

    public init(ads: [T], firstAd: T? = nil) {
        assert(ads.count > 0)

        index = ads.index(where: { $0 == firstAd }) ?? 0
        queue = ads
    }

    public mutating func next() {
        index = (index + 1) % queue.count
    }
}