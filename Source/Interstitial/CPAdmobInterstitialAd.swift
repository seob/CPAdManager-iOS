//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import GoogleMobileAds

open class CPAdmobInterstitialAd: CPInterstitialAd {
    fileprivate weak var delegate: CPInterstitialAdDelegate?

    private var interstitial: GADInterstitial?

    private let unitId: String

    public init(unitId: String) {
        self.unitId = unitId
        super.init()
    }

    public override func requestAd() {
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]

        interstitial = GADInterstitial(adUnitID: unitId)
        interstitial?.delegate = self
        interstitial?.load(request)
    }

    public override func ready() -> Bool {
        guard let interstitial = self.interstitial else { return false }
        guard interstitial.isReady else { return false }
        guard interstitial.hasBeenUsed == false else { return false }
        return true
    }

    public override func show(ad viewController: UIViewController) {
        guard let interstitial = interstitial else { return }
        guard interstitial.hasBeenUsed == false else { return }

        interstitial.present(fromRootViewController: viewController)
    }

    public override func set(delegate: CPInterstitialAdDelegate) {
        self.delegate = delegate
    }
}

extension CPAdmobInterstitialAd: GADInterstitialDelegate {
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        delegate?.onLoaded(interstitialAd: self)
    }

    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError){
        delegate?.onFailedToLoad(interstitialAd: self, error: error)
    }

    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        delegate?.onDismissed(interstitialAd: self)
    }
}