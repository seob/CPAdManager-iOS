//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

public protocol CPInterstitialAd {
    func requestAd()
    func ready() -> Bool
    func showAd(viewController: UIViewController)
    func setDelegate(delegate: CPInterstitialAdDelegate) -> CPInterstitialAd
}

public protocol CPInterstitialAdDelegate {
    func loadedAd(interstitialAd: CPInterstitialAd)
    func failedToLoadAd(interstitialAd: CPInterstitialAd, error: NSError)
    func dismissAd(interstitialAd: CPInterstitialAd)
}

public protocol CPInterstitialAdManagerDelegate {
    func loadedInterstitialAd(adManager: CPInterstitialAdManager)
    func failedToLoadInterstitialAd(adManager: CPInterstitialAdManager)
    func dismissAd(adManager: CPInterstitialAdManager)
}

public class CPInterstitialAdManager: CPInterstitialAdDelegate {
    private let ads: [CPInterstitialAd]
    private var indexOfAd = 0 {
        didSet {
            print("index of ad : \(self.indexOfAd)")
        }
    }

    private var delegate: CPInterstitialAdManagerDelegate?
    private var showAfterLoadedAd = false
    private var viewControllerForShowAfterLoadedAd: UIViewController?
    var reloadAdAfterDismissAd = false
    var failForDebug = false

    public init(_ ads: [CPInterstitialAd]) {
        self.ads = ads.flatMap { $0 }
        let _ = self.ads.flatMap { $0.setDelegate(self) }

        assert(ads.count > 0)
    }

    public func setShowAfterLoadedAd(show: Bool, viewController: UIViewController?) {
        assert((show && viewController != nil) || (!show && viewController == nil))

        self.showAfterLoadedAd = show
        self.viewControllerForShowAfterLoadedAd = viewController
    }

    public func requestAd(delegate: CPInterstitialAdManagerDelegate? = nil) {
        assert((self.showAfterLoadedAd && delegate == nil) || (!self.showAfterLoadedAd && delegate != nil))

        self.delegate = delegate
        let ad: CPInterstitialAd = self.ads[self.indexOfAd]
        ad.requestAd()
    }

    public func ready() -> Bool {
        let ad: CPInterstitialAd = self.ads[self.indexOfAd]
        return ad.ready()
    }

    public func show(viewController: UIViewController) {
        let ad: CPInterstitialAd = self.ads[self.indexOfAd]
        ad.showAd(viewController)
    }

    public func loadedAd(interstitialAd: CPInterstitialAd) {
        if arc4random_uniform(2) == 0 {
            self.failedToLoadAd(interstitialAd, error: NSError(domain: "test", code: 0, userInfo: nil))
            return
        }

        self.delegate?.loadedInterstitialAd(self)

        if let viewController = self.viewControllerForShowAfterLoadedAd where self.showAfterLoadedAd {
            interstitialAd.showAd(viewController)
        }
    }

    public func failedToLoadAd(interstitialAd: CPInterstitialAd, error: NSError) {
        self.delegate?.failedToLoadInterstitialAd(self)

        self.indexOfAd = (self.indexOfAd + 1) % self.ads.count
        self.requestAd(self.delegate)
    }

    public func dismissAd(interstitialAd: CPInterstitialAd) {
        self.delegate?.dismissAd(self)

        if self.reloadAdAfterDismissAd {
            assert(!self.showAfterLoadedAd)

            interstitialAd.requestAd()
        }
    }

}
