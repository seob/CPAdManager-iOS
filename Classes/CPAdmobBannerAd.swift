//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class CPAdmobBannerAd: NSObject, CPBannerAd, GADBannerViewDelegate {
    let unitId: String
    var adView: GADBannerView?
    var delegate: CPBannerAdDelegate?

    init(_ unitId: String) {
        self.unitId = unitId
    }

    public func request(viewController: UIViewController) {
        if self.adView == nil {
            self.adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            self.adView?.adUnitID = self.unitId
            self.adView?.rootViewController = viewController
            self.adView?.delegate = self
        }

        let request = GADRequest()
        self.adView?.loadRequest(request)
    }

    public func setDelegate(delegate: CPBannerAdDelegate) {
        self.delegate = delegate
    }

    public func bannerView() -> UIView? {
        return self.adView
    }

    public func adViewDidReceiveAd(bannerView: GADBannerView!) {
        self.delegate?.loadedAd(self)
    }

    public func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.delegate?.failedToLoadAd(self, error: error)
    }
}
