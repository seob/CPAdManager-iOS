//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit
import GoogleMobileAds

open class CPAdmobNativeAd: CPNativeAd {
    var unitId: String
    var delegate: CPNativeAdDelegate?
    var adView: GADNativeExpressAdView?

    public init(unitId: String) {
        self.unitId = unitId
    }

    public override func request(in viewController: UIViewController) {
        if adView == nil {
            adView = GADNativeExpressAdView(adSize: kGADAdSizeLargeBanner)
            adView?.adUnitID = unitId
            adView?.rootViewController = viewController
            adView?.delegate = self
        }

        let request = GADRequest()
        adView?.load(request)
    }

    public override func set(delegate: CPNativeAdDelegate) {
        self.delegate = delegate
    }

    public override func nativeView() -> UIView? {
        return adView
    }
}

extension CPAdmobNativeAd: GADNativeExpressAdViewDelegate {
    public func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        delegate?.onLoaded(nativeAd: self)
    }

    public func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        delegate?.onFailedToLoad(nativeAd: self, error: error)
    }
}