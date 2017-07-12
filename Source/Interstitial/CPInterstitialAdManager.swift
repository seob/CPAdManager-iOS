//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

open class CPInterstitialAd: NSObject, AdIdentifier {
    public var identifier: String { return "" }
    
    func requestAd() { }
    func ready() -> Bool { return false }
    func show(ad viewController: UIViewController) { }
    func set(delegate: CPInterstitialAdDelegate) { }
}

public protocol CPInterstitialAdDelegate: class {
    func onLoaded(interstitialAd: CPInterstitialAd)
    func onFailedToLoad(interstitialAd: CPInterstitialAd, error: Error)
    func onWillDismissed(interstitialAd: CPInterstitialAd)
    func onDidDismissed(interstitialAd: CPInterstitialAd)
}

public enum InterstitialADState {
    case idle
    case errorForOneCycle
    case loaded
    case willDismissed
    case didDismissed
}

open class CPInterstitialAdManager {
    public var failForDebug: Bool = true
    public var isAutoRefreshMode: Bool = false
    public var changedStateBlock: ((CPInterstitialAdManager, InterstitialADState) -> Void)?

    fileprivate var adQueue: AdPlatformQueue<CPInterstitialAd>
    fileprivate var errorController: ErrorController
    fileprivate var state: InterstitialADState = .idle {
        didSet {
            print("CPAdManager: Interstitial: state: \(state)")
            changedStateBlock?(self, state)
        }
    }

    public init(interstitialAds: [CPInterstitialAd], identifierForFirstAd: String, changedState: ((CPInterstitialAdManager, InterstitialADState) -> Void)? = nil) {
        adQueue = AdPlatformQueue(ads: interstitialAds, identifierForFirstAd: identifierForFirstAd)
        errorController = ErrorController(threshold: interstitialAds.count)
        changedStateBlock = changedState

        interstitialAds.forEach { [weak self] ad in
            guard let ss = self else { return }
            ad.set(delegate: ss)
        }

        errorController.onNext = { [weak self] in
            self?.adQueue.next()
            self?.requestAd()
        }
        errorController.onErrorForOneCycle = { [weak self] in
            self?.state = .errorForOneCycle
            self?.adQueue.next()
            self?.errorController.reset()
        }
    }

    public func requestAd() {
        adQueue.current.requestAd()

        print("CPAdManager: Interstitial: \(adQueue.current.identifier): request")
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

        print("CPAdManager: Interstitial: \(interstitialAd.identifier): loaded")

        errorController.reset()
        state = .loaded
    }

    public func onFailedToLoad(interstitialAd: CPInterstitialAd, error: Error) {
        print("CPAdManager: Interstitial: \(interstitialAd.identifier): failed")

        errorController.reportError()
    }

    public func onWillDismissed(interstitialAd: CPInterstitialAd) {
        state = .willDismissed
    }

    public func onDidDismissed(interstitialAd: CPInterstitialAd) {
        state = .didDismissed

        if isAutoRefreshMode {
            requestAd()
        }
    }
}