//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import GoogleMobileAds

class CPAdmobInterstitialAd: NSObject, CPInterstitialAd, GADInterstitialDelegate {
    var delegate: CPInterstitialAdDelegate?
    var interstitial: GADInterstitial?
    let unitId: String

    init(_ unitId: String) {
        self.unitId = unitId
        super.init()
    }

    func requestAd() {
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        self.interstitial = GADInterstitial(adUnitID: unitId)
        self.interstitial?.delegate = self
        self.interstitial?.loadRequest(request)
    }

    func ready() -> Bool {
        guard let interstitial = self.interstitial else {
            return false
        }
        return interstitial.isReady && !interstitial.hasBeenUsed
    }

    func showAd(viewController: UIViewController) {
        if let used = self.interstitial?.hasBeenUsed where used == false {
            self.interstitial?.presentFromRootViewController(viewController)
        }
    }

    func setDelegate(delegate: CPInterstitialAdDelegate) -> CPInterstitialAd {
        self.delegate = delegate
        return self
    }

    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        self.delegate?.loadedAd(self)
    }

    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.delegate?.failedToLoadAd(self, error: error)
    }

    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.delegate?.dismissAd(self)
    }

}
