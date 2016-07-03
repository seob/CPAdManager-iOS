//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import FBAudienceNetwork

public class CPFacebookInterstitialAd: NSObject, CPInterstitialAd, FBInterstitialAdDelegate {
    var delegate: CPInterstitialAdDelegate?
    var interstitialAd: FBInterstitialAd?
    let placementId: String

    init(_ placementId: String) {
        self.placementId = placementId
        super.init()

        FBAdSettings.setLogLevel(.Warning)
    }

    public func requestAd() {
        self.interstitialAd = FBInterstitialAd(placementID: self.placementId)
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd()
    }

    public func ready() -> Bool {
        return self.interstitialAd?.adValid ?? false
    }

    public func showAd(viewController: UIViewController) {
        if self.ready() {
            self.interstitialAd?.showAdFromRootViewController(viewController)
        }
    }

    public func setDelegate(delegate: CPInterstitialAdDelegate) -> CPInterstitialAd {
        self.delegate = delegate
        return self
    }

    public func interstitialAdDidClose(interstitialAd: FBInterstitialAd) {
        self.delegate?.dismissAd(self)
    }

    public func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
        self.delegate?.loadedAd(self)
    }

    public func interstitialAd(interstitialAd: FBInterstitialAd, didFailWithError error: NSError) {
        self.delegate?.failedToLoadAd(self, error: error)
    }

}
