//
// Created by Chope on 2016. 7. 3..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import FBAudienceNetwork

class CPFacebookBannerAd: NSObject, CPBannerAd, FBAdViewDelegate {
    let placementId: String
    var adView: FBAdView?
    var delegate: CPBannerAdDelegate?

    init(_ placementId: String) {
        self.placementId = placementId
    }

    func request(viewController: UIViewController) {
        if self.adView == nil {
            let adSize = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner
            self.adView = FBAdView(placementID: self.placementId, adSize: adSize, rootViewController: viewController)
            self.adView?.delegate = self
        }
        self.adView?.loadAd()
    }

    func setDelegate(delegate: CPBannerAdDelegate) {
        self.delegate = delegate
    }

    func bannerView() -> UIView? {
        return self.adView
    }

    internal func adViewDidLoad(adView: FBAdView) {
        self.delegate?.loadedAd(self)
    }

    internal func adView(adView: FBAdView, didFailWithError error: NSError) {
        self.delegate?.failedToLoadAd(self, error: error)
    }
}
