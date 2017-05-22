//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import FBAudienceNetwork

open class CPFacebookBannerAd: CPBannerAd {
    fileprivate weak var delegate: CPBannerAdDelegate?

    private var adView: FBAdView?

    private let placementId: String

    public init(placementId: String) {
        self.placementId = placementId
    }

    override func request(in viewController: UIViewController) {
        if adView == nil {
            let adSize = (UIDevice.current.userInterfaceIdiom == .pad) ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner
            adView = FBAdView(placementID: placementId, adSize: adSize, rootViewController: viewController)
            adView?.delegate = self
        }
        adView?.loadAd()
    }

    override func set(delegate: CPBannerAdDelegate) {
        self.delegate = delegate
    }

    public override func bannerView() -> UIView? {
        return adView
    }
}

extension CPFacebookBannerAd: FBAdViewDelegate {
    public func adViewDidLoad(_ adView: FBAdView) {
        delegate?.onLoaded(bannerAd: self)
    }

    public func adView(_ adView: FBAdView, didFailWithError error: Error) {
        delegate?.onFailedToLoad(bannerAd: self, error: error)
    }
}