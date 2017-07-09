//
// Created by Chope on 2017. 6. 1..
// Copyright (c) 2017 ChopeIndustry. All rights reserved.
//

import UIKit
import FBAudienceNetwork


open class CPFacebookNativeAd: CPNativeAd {
    public override var identifier: String {
        return "Facebook"
    }
    
    fileprivate weak var delegate: CPNativeAdDelegate?
    fileprivate weak var viewController: UIViewController?

    fileprivate var adView: FBNativeAdView?
    fileprivate var adViewType: FBNativeAdViewType

    private let placementId: String

    public init(placementId: String, adViewType: FBNativeAdViewType = .genericHeight100) {
        self.placementId = placementId
        self.adViewType = adViewType
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
        let adView = FBNativeAdView(nativeAd: nativeAd, with: adViewType)
        nativeAd.registerView(forInteraction: adView, with: viewController)

        adView.frame.size.height = {
            switch adViewType {
            case .genericHeight100:
                return 100
            case .genericHeight120:
                return 120
            case .genericHeight300:
                return 300
            case .genericHeight400:
                return 400
            }
        }()

        self.adView = adView
        delegate?.onLoaded(nativeAd: self)
    }

    public func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        delegate?.onFailedToLoad(nativeAd: self, error: error)
    }
}
