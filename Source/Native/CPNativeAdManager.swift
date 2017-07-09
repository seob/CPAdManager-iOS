//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit

open class CPNativeAd: NSObject, AdIdentifier {
    public var identifier: String { return "" }

    func request(in viewController: UIViewController) { }
    func set(delegate: CPNativeAdDelegate) { }
    func nativeView() -> UIView? { return nil }
}

public protocol CPNativeAdDelegate: class {
    func onLoaded(nativeAd: CPNativeAd)
    func onFailedToLoad(nativeAd: CPNativeAd, error: Error)
}

public enum NativeADState {
    case idle
    case errorForOneCycle
    case loaded(height: CGFloat)
}

open class CPNativeAdManager {
    public weak var rootViewController: UIViewController?

    public var failForDebug = false

    fileprivate weak var containerView: UIView?

    fileprivate var adQueue: AdPlatformQueue<CPNativeAd>
    fileprivate var errorController: ErrorController
    fileprivate var state: NativeADState = .idle {
        didSet {
            print("CPAdManager: Native: state: \(state)")
            changedStateBlock?(self, state)
        }
    }

    private let changedStateBlock: ((CPNativeAdManager, NativeADState) -> Void)?

    public init(nativeAds: [CPNativeAd], identifierForFirstAD: String, containerView: UIView, changedState: ((CPNativeAdManager, NativeADState) -> Void)? = nil) {
        self.containerView = containerView
        self.changedStateBlock = changedState

        adQueue = AdPlatformQueue(ads: nativeAds, identifierForFirstAd: identifierForFirstAD)

        errorController = ErrorController(threshold: nativeAds.count)
        errorController.onNext = { [weak self] in
            self?.adQueue.next()
            self?.request()
        }
        errorController.onErrorForOneCycle = { [weak self] in
            self?.state = .errorForOneCycle
            self?.adQueue.next()
            self?.errorController.reset()
        }

        nativeAds.forEach { $0.set(delegate: self) }
    }

    public func request() {
        assert(rootViewController != nil)
        assert(containerView != nil)

        guard containerView != nil else { return }
        guard let rootViewController = rootViewController else { return }

        adQueue.current.request(in: rootViewController)

        print("CPAdManager: Native: \(adQueue.current.identifier): request")
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

        print("CPAdManager: Native: \(nativeAd.identifier): loaded")

        errorController.reset()

        bannerView.removeFromSuperview()
        bannerView.frame.size.width = containerView.bounds.size.width

        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        containerView.addSubview(bannerView)

        state = .loaded(height: bannerView.bounds.size.height)
    }

    public func onFailedToLoad(nativeAd: CPNativeAd, error: Error) {
        print("CPAdManager: Native: \(nativeAd.identifier): failed")

        errorController.reportError()
    }
}