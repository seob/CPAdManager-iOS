//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import GoogleMobileAds

open class CPAdmobBannerAd: CPBannerAd {
    public override var identifier: String {
        return "Admob"
    }

    fileprivate var delegate: CPBannerAdDelegate?
    
    private let unitId: String
    private var adView: GADBannerView?

    public init(unitId: String) {
        self.unitId = unitId
    }

    override func request(in viewController: UIViewController) {
        if adView == nil {
            adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            adView?.adUnitID = unitId
            adView?.rootViewController = viewController
            adView?.delegate = self
        }

        let request = GADRequest()
        adView?.load(request)
    }

    override func set(delegate: CPBannerAdDelegate) {
        self.delegate = delegate
    }

    public override func bannerView() -> UIView? {
        return adView
    }

}

extension CPAdmobBannerAd: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        delegate?.onLoaded(bannerAd: self)
    }

    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        delegate?.onFailedToLoad(bannerAd: self, error: error)
    }
}
