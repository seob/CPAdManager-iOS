//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit
import GoogleMobileAds

open class CPAdmobNativeAd: CPNativeAd {
    public override var identifier: String {
        return "Admob"
    }

    fileprivate weak var delegate: CPNativeAdDelegate?

    private var adView: GADNativeExpressAdView?
    
    private let unitId: String
    private let adSize: GADAdSize

    public init(unitId: String, adSize: GADAdSize = kGADAdSizeBanner) {
        self.unitId = unitId
        self.adSize = adSize
    }

    public override func request(in viewController: UIViewController) {
        if adView == nil {
            adView = GADNativeExpressAdView(adSize: adSize)
            adView?.adUnitID = unitId
            adView?.rootViewController = viewController
            adView?.delegate = self
        }

        let videoOptions = GADVideoOptions()
        videoOptions.startMuted = true
        adView?.setAdOptions([videoOptions])

        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
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