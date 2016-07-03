//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class CPAdmobInterstitialAd: NSObject, CPInterstitialAd, GADInterstitialDelegate {
    var delegate: CPInterstitialAdDelegate?
    var interstitial: GADInterstitial?
    let unitId: String

    init(_ unitId: String) {
        self.unitId = unitId
        super.init()
    }

    public func requestAd() {
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        self.interstitial = GADInterstitial(adUnitID: unitId)
        self.interstitial?.delegate = self
        self.interstitial?.loadRequest(request)
    }

    public func ready() -> Bool {
        guard let interstitial = self.interstitial else {
            return false
        }
        return interstitial.isReady && !interstitial.hasBeenUsed
    }

    public func showAd(viewController: UIViewController) {
        if let used = self.interstitial?.hasBeenUsed where used == false {
            self.interstitial?.presentFromRootViewController(viewController)
        }
    }

    public func setDelegate(delegate: CPInterstitialAdDelegate) -> CPInterstitialAd {
        self.delegate = delegate
        return self
    }

    public func interstitialDidReceiveAd(ad: GADInterstitial!) {
        self.delegate?.loadedAd(self)
    }

    public func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        self.delegate?.failedToLoadAd(self, error: error)
    }

    public func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.delegate?.dismissAd(self)
    }

}
