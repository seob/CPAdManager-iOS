//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import FBAudienceNetwork

class CPFacebookInterstitialAd: NSObject, CPInterstitialAd, FBInterstitialAdDelegate {
    var delegate: CPInterstitialAdDelegate?
    var interstitialAd: FBInterstitialAd?
    let placementId: String

    init(_ placementId: String) {
        self.placementId = placementId
        super.init()

        FBAdSettings.setLogLevel(.Warning)
    }

    func requestAd() {
        self.interstitialAd = FBInterstitialAd(placementID: self.placementId)
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd()
    }

    func ready() -> Bool {
        return self.interstitialAd?.adValid ?? false
    }

    func showAd(viewController: UIViewController) {
        if self.ready() {
            self.interstitialAd?.showAdFromRootViewController(viewController)
        }
    }

    func setDelegate(delegate: CPInterstitialAdDelegate) -> CPInterstitialAd {
        self.delegate = delegate
        return self
    }

    func interstitialAdDidClose(interstitialAd: FBInterstitialAd) {
        self.delegate?.dismissAd(self)
    }

    func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
        self.delegate?.loadedAd(self)
    }

    func interstitialAd(interstitialAd: FBInterstitialAd, didFailWithError error: NSError) {
        self.delegate?.failedToLoadAd(self, error: error)
    }

}
