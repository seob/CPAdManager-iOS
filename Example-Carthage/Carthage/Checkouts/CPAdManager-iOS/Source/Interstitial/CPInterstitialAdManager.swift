//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

open class CPInterstitialAd: NSObject {
    func requestAd() { }
    func ready() -> Bool { return false }
    func show(ad viewController: UIViewController) { }
    func set(delegate: CPInterstitialAdDelegate) { }
}

public protocol CPInterstitialAdDelegate: class {
    func onLoaded(interstitialAd: CPInterstitialAd)
    func onFailedToLoad(interstitialAd: CPInterstitialAd, error: Error)
    func onDismissed(interstitialAd: CPInterstitialAd)
}

public protocol CPInterstitialAdManagerDelegate: class {
    func onLoaded(interstitialAdManager: CPInterstitialAdManager)
    func onFailedToLoad(interstitialAdManager: CPInterstitialAdManager)
    func onDismissed(interstitialAd: CPInterstitialAdManager)
}

open class CPInterstitialAdManager {
    public var failForDebug: Bool = true

    public weak var delegate: CPInterstitialAdManagerDelegate?

    fileprivate var adQueue: AdPlatformQueue<CPInterstitialAd>
    fileprivate var errorController: ErrorController

    public init(interstitialAds: [CPInterstitialAd], firstAd: CPInterstitialAd? = nil) {
        adQueue = AdPlatformQueue(ads: interstitialAds, firstAd: firstAd)
        errorController = ErrorController(threshold: interstitialAds.count)

        interstitialAds.forEach { [weak self] ad in
            guard let ss = self else { return }
            ad.set(delegate: ss)
        }
        errorController.onError = { [weak self] in
            guard let ss = self else { return }
            ss.delegate?.onFailedToLoad(interstitialAdManager: ss)
        }
    }

    public func requestAd() {
        adQueue.current.requestAd()
    }

    public func show(from viewController: UIViewController) {
        let ad: CPInterstitialAd = adQueue.current

        guard ad.ready() else { return }

        ad.show(ad: viewController)
    }
}

extension CPInterstitialAdManager: CPInterstitialAdDelegate {
    public func onLoaded(interstitialAd: CPInterstitialAd) {
        if failForDebug == true && arc4random_uniform(2) == 0 {
            onFailedToLoad(interstitialAd: interstitialAd, error: AdError.testFailure)
            return
        }

        errorController.reset()
        delegate?.onLoaded(interstitialAdManager: self)
    }

    public func onFailedToLoad(interstitialAd: CPInterstitialAd, error: Error) {
        errorController.fail()

        adQueue.next()
        requestAd()
    }

    public func onDismissed(interstitialAd: CPInterstitialAd) {
        delegate?.onDismissed(interstitialAd: self)
        requestAd()
    }
}