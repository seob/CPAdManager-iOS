//
// Created by Chope on 2016. 7. 2..
// Copyright (c) 2016 Chope. All rights reserved.
//

import Foundation
import FBAudienceNetwork

open class CPFacebookInterstitialAd: CPInterstitialAd {
    public override var identifier: String {
        return "Facebook"
    }
    
    fileprivate weak var delegate: CPInterstitialAdDelegate?

    private var interstitialAd: FBInterstitialAd?
    private let placementId: String

    public init(placementId: String) {
        self.placementId = placementId
        super.init()
    }

    public override func requestAd() {
        interstitialAd = FBInterstitialAd(placementID: placementId)
        interstitialAd?.delegate = self
        interstitialAd?.load()
    }

    public override func ready() -> Bool {
        return interstitialAd?.isAdValid ?? false
    }

    public override func show(ad viewController: UIViewController) {
        guard ready() else { return }

        interstitialAd?.show(fromRootViewController: viewController)
    }

    public override func set(delegate: CPInterstitialAdDelegate) {
        self.delegate = delegate
    }


}

extension CPFacebookInterstitialAd: FBInterstitialAdDelegate {
    public func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
        delegate?.onWillDismissed(interstitialAd: self)
    }

    public func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        delegate?.onDidDismissed(interstitialAd: self)
    }

    public func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        delegate?.onLoaded(interstitialAd: self)
    }

    public func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        delegate?.onFailedToLoad(interstitialAd: self, error: error)
    }
}