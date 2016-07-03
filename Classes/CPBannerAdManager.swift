//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import UIKit

public protocol CPBannerAd {
    func request(viewController: UIViewController)
    func setDelegate(delegate: CPBannerAdDelegate)
    func bannerView() -> UIView?
}

public protocol CPBannerAdDelegate {
    func loadedAd(bannerAd: CPBannerAd)
    func failedToLoadAd(bannerAd: CPBannerAd, error: NSError)
}

public class CPBannerAdManager: CPBannerAdDelegate {
    let ads: [CPBannerAd]
    var indexOfAd = 0 {
        didSet {
//            print("index of banner ad : \(self.indexOfAd)")
        }
    }
    var containerView: UIView?
    weak var rootViewController: UIViewController?
    var failForDebug = false

    init(_ rootViewController: UIViewController, ads: [CPBannerAd]) {
        self.rootViewController = rootViewController
        self.ads = ads.flatMap { $0 }
        let _ = self.ads.map { $0.setDelegate(self) }
    }

    func request() {
        assert(self.containerView != nil)

        if let rootViewController = self.rootViewController {
            let ad = self.ads[self.indexOfAd]
            ad.request(rootViewController)
        }
    }

    public func loadedAd(bannerAd: CPBannerAd) {
        guard let containerView = self.containerView else {
            return
        }

        if self.failForDebug && arc4random_uniform(2) == 0 {
            self.failedToLoadAd(bannerAd, error: NSError(domain: "test", code: 0, userInfo: nil))
            return
        }

        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }

        if let bannerView = bannerAd.bannerView() {
            bannerView.frame = containerView.bounds
            containerView.addSubview(bannerView)
        }
    }

    public func failedToLoadAd(bannerAd: CPBannerAd, error: NSError) {
        self.indexOfAd = (self.indexOfAd + 1) % self.ads.count
        self.request()
    }

}
