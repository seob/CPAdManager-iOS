//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

open class CPBannerAd: NSObject {
    func request(in viewController: UIViewController) { }
    func set(delegate: CPBannerAdDelegate) { }
    func bannerView() -> UIView? { return nil }
}

public protocol CPBannerAdDelegate: class {
    func onLoaded(bannerAd: CPBannerAd)
    func onFailedToLoad(bannerAd: CPBannerAd, error: Error)
}

public protocol CPBannerAdManagerDelegate: class {
    func onFailedToLoad(bannerAdManager: CPBannerAdManager)
    func onLoaded(bannerAdManager: CPBannerAdManager, height: CGFloat)
}

open class CPBannerAdManager {
    public weak var containerView: UIView?
    public weak var rootViewController: UIViewController?
    public weak var containerViewHeightConstraint: NSLayoutConstraint?
    public weak var delegate: CPBannerAdManagerDelegate?

    fileprivate var adQueue: AdPlatformQueue<CPBannerAd>
    fileprivate var errorController: ErrorController

    var failForDebug = false

    init(bannerAds: [CPBannerAd], firstAd: CPBannerAd? = nil) {
        adQueue = AdPlatformQueue(ads: bannerAds, firstAd: firstAd)
        errorController = ErrorController(threshold: bannerAds.count)
        errorController.onError = { [weak self] in
            guard let ss = self else { return }
            ss.delegate?.onFailedToLoad(bannerAdManager: ss)
        }
        
        bannerAds.forEach { $0.set(delegate: self) }
    }

    func request() {
        assert(rootViewController != nil)
        assert(containerView != nil)

        guard containerView != nil else { return }
        guard let rootViewController = rootViewController else { return }

        adQueue.current.request(in: rootViewController)
    }
}

extension CPBannerAdManager: CPBannerAdDelegate {
    public func onLoaded(bannerAd: CPBannerAd) {
        guard let containerView = containerView else {
            return
        }
        guard let bannerView = bannerAd.bannerView() else {
            onFailedToLoad(bannerAd: bannerAd, error: AdError.notExistBannerView)
            return
        }
        guard failForDebug == false, arc4random_uniform(2) == 0 else {
            onFailedToLoad(bannerAd: bannerAd, error: AdError.testFailure)
            return
        }

        errorController.reset()

        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        containerView.addSubview(bannerView)

        let height: CGFloat = CPUtil.resize(bannerView.frame.size, fitWidth: containerView.frame.size.width).height
        containerViewHeightConstraint?.constant = height
        delegate?.onLoaded(bannerAdManager: self, height: height)
    }

    public func onFailedToLoad(bannerAd: CPBannerAd, error: Error) {
        errorController.fail()
        adQueue.next()
        request()
    }
}