//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit

open class CPNativeAd: NSObject {
    func request(in viewController: UIViewController) { }
    func set(delegate: CPNativeAdDelegate) { }
    func nativeView() -> UIView? { return nil }
}

public protocol CPNativeAdDelegate: class {
    func onLoaded(nativeAd: CPNativeAd)
    func onFailedToLoad(nativeAd: CPNativeAd, error: Error)
}

public protocol CPNativeAdManagerDelegate: class {
    func onFailedToLoad(nativeAdManager: CPNativeAdManager)
    func onLoaded(nativeAdManager: CPNativeAdManager)
}

open class CPNativeAdManager {
    public weak var containerView: UIView?
    public weak var rootViewController: UIViewController?
    public weak var delegate: CPNativeAdManagerDelegate?

    fileprivate var adQueue: AdPlatformQueue<CPNativeAd>
    fileprivate var errorController: ErrorController

    public var failForDebug = false

    public init(nativeAds: [CPNativeAd], firstAd: CPNativeAd? = nil) {
        adQueue = AdPlatformQueue(ads: nativeAds, firstAd: firstAd)
        errorController = ErrorController(threshold: nativeAds.count)
        errorController.onError = { [weak self] in
            guard let ss = self else { return }
            ss.delegate?.onFailedToLoad(nativeAdManager: ss)
        }

        nativeAds.forEach { $0.set(delegate: self) }
    }

    public func request() {
        assert(rootViewController != nil)
        assert(containerView != nil)

        guard containerView != nil else { return }
        guard let rootViewController = rootViewController else { return }

        adQueue.current.request(in: rootViewController)
    }
}

extension CPNativeAdManager: CPNativeAdDelegate {
    public func onLoaded(nativeAd: CPNativeAd) {
        guard let containerView = containerView else {
            return
        }
        guard let bannerView = nativeAd.nativeView() else {
            onFailedToLoad(nativeAd: nativeAd, error: AdError.notExistAdView)
            return
        }
        if failForDebug == true, arc4random_uniform(2) == 0 {
            onFailedToLoad(nativeAd: nativeAd, error: AdError.testFailure)
            return
        }

        errorController.reset()

        bannerView.frame = containerView.bounds

        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        containerView.addSubview(bannerView)

        delegate?.onLoaded(nativeAdManager: self)
    }

    public func onFailedToLoad(nativeAd: CPNativeAd, error: Error) {
        errorController.fail()
        adQueue.next()
        request()
    }
}