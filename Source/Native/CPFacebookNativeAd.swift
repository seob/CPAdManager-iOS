//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit
import FBAudienceNetwork


open class CPFacebookNativeAd: CPNativeAd {
    fileprivate weak var delegate: CPNativeAdDelegate?

    fileprivate var adView: FBNativeAdView?
    fileprivate var viewController: UIViewController?

    private let placementId: String

    public init(placementId: String) {
        self.placementId = placementId
    }

    override func request(in viewController: UIViewController) {
        self.viewController = viewController

        let nativeAd = FBNativeAd(placementID: placementId)
        nativeAd.delegate = self
        nativeAd.load()
    }

    override func set(delegate: CPNativeAdDelegate) {
        self.delegate = delegate
    }

    public override func nativeView() -> UIView? {
        return adView
    }
}

extension CPFacebookNativeAd: FBNativeAdDelegate {
    public func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        guard let viewController = viewController else { return }
        let adView = FBNativeAdView(nativeAd: nativeAd, with: .genericHeight100)
        nativeAd.registerView(forInteraction: adView, with: viewController)

        self.adView = adView
        delegate?.onLoaded(nativeAd: self)
    }

    public func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        delegate?.onFailedToLoad(nativeAd: self, error: error)
    }
}
