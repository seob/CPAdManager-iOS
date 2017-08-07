//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

public protocol AdIdentifier: Equatable {
    var identifier: String { get }
}

open class CPBannerAd: NSObject, AdIdentifier {
    public var identifier: String { return "" }
    
    func request(in viewController: UIViewController) { }
    func set(delegate: CPBannerAdDelegate) { }
    func bannerView() -> UIView? { return nil }
}

public protocol CPBannerAdDelegate: class {
    func onLoaded(bannerAd: CPBannerAd)
    func onFailedToLoad(bannerAd: CPBannerAd, error: Error)
}

public enum BannerADState {
    case idle
    case errorForOneCycle
    case loaded(height: CGFloat)
}

open class CPBannerAdManager {
    public var failForDebug = false
    public var changedStateBlock: ((CPBannerAdManager, BannerADState) -> Void)?

    fileprivate weak var containerView: UIView!
    
    fileprivate var adQueue: AdPlatformQueue<CPBannerAd>
    fileprivate var errorController: ErrorController
    fileprivate var state: BannerADState = .idle {
        didSet {
            print("CPAdManager: Banner: state: \(state)")
            changedStateBlock?(self, state)
        }
    }

    private weak var viewController: UIViewController!

    public init(bannerAds: [CPBannerAd], identifierForFirstAd: String, viewController: UIViewController, containerView: UIView, changedState: ((CPBannerAdManager, BannerADState) -> Void)? = nil) {
        self.viewController = viewController
        self.containerView = containerView
        self.changedStateBlock = changedState
        adQueue = AdPlatformQueue(ads: bannerAds, identifierForFirstAd: identifierForFirstAd)

        errorController = ErrorController(threshold: bannerAds.count)
        errorController.onNext = { [weak self] in
            self?.adQueue.next()
            self?.request()
        }
        errorController.onErrorForOneCycle = { [weak self] in
            self?.state = .errorForOneCycle
            self?.adQueue.next()
            self?.errorController.reset()
        }
        
        bannerAds.forEach { $0.set(delegate: self) }
    }

    public func request() {
        assert(containerView != nil)
        assert(viewController != nil)

        adQueue.current.request(in: viewController)
        print("CPAdManager: Banner: \(adQueue.current.identifier): request")
    }

    public func showIfNeeded() {
        guard let containerView = containerView else { return }
        guard let bannerView = adQueue.current.bannerView() else { return }

        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        containerView.addSubview(bannerView)

        let height: CGFloat = CPUtil.resize(bannerView.frame.size, fitWidth: containerView.frame.size.width).height
        state = .loaded(height: height)
    }
}

extension CPBannerAdManager: CPBannerAdDelegate {
    public func onLoaded(bannerAd: CPBannerAd) {
        guard let _ = bannerAd.bannerView() else {
            onFailedToLoad(bannerAd: bannerAd, error: AdError.notExistAdView)
            return
        }
        if failForDebug == true, arc4random_uniform(2) == 0 {
            onFailedToLoad(bannerAd: bannerAd, error: AdError.testFailure)
            return
        }
        
        print("CPAdManager: Banner: \(bannerAd.identifier): loaded")

        errorController.reset()

        showIfNeeded()
    }

    public func onFailedToLoad(bannerAd: CPBannerAd, error: Error) {
        print("CPAdManager: Banner: \(bannerAd.identifier): failed")

        errorController.reportError()
    }
}