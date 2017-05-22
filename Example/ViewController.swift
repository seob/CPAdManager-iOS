//
//  ViewController.swift
//  CPAdManager
//
//  Created by Chope on 2016. 7. 2..
//  Copyright (c) 2016 Chope. All rights reserved.
//


import UIKit
import CPAdManager


class ViewController: UIViewController, CPInterstitialAdManagerDelegate, CPBannerAdManagerDelegate {
    @IBOutlet fileprivate weak var requestBannerButton: UIButton!
    @IBOutlet fileprivate weak var showInterstitialButton: UIButton!
    @IBOutlet fileprivate weak var bannerContainerView: UIView!
    @IBOutlet fileprivate weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!

    private let admob: CPInterstitialAd = CPAdmobInterstitialAd(unitId: "ca-app-pub-3940256099942544/4411468910")
    private let facebook: CPInterstitialAd = CPFacebookInterstitialAd(placementId: "1351290504887194_1726465200703054")
    private let interstitialAdManager: CPInterstitialAdManager

    private let admobBanner = CPAdmobBannerAd(unitId: "ca-app-pub-3940256099942544/6300978111")
    private let facebookBanner = CPFacebookBannerAd(placementId: "1351290504887194_1351290761553835")
    private let bannerAdManager: CPBannerAdManager

    public required init?(coder aDecoder: NSCoder) {
        interstitialAdManager = CPInterstitialAdManager(interstitialAds: [
                admob,
                facebook,
        ], firstAd: CPUtil.isInstalledFacebook() ? facebook : admob)

        bannerAdManager = CPBannerAdManager(bannerAds: [
                admobBanner,
                facebookBanner
        ], firstAd: CPUtil.isInstalledFacebook() ? facebookBanner: admobBanner)

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

        interstitialAdManager.delegate = self
        interstitialAdManager.failForDebug = true
        interstitialAdManager.requestAd()

        bannerAdManager.containerView = bannerContainerView
        bannerAdManager.rootViewController = self
        bannerAdManager.containerViewHeightConstraint = bannerContainerViewHeightConstraint
        bannerAdManager.delegate = self
        bannerAdManager.failForDebug = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func requestBanner(_ button: UIButton?) {
        button?.isEnabled = false
        bannerAdManager.request()
    }

    @IBAction func showInterstitialAd(_ button: UIButton?) {
        interstitialAdManager.show(from: self)
        button?.isEnabled = false
    }

    func onLoaded(interstitialAdManager: CPInterstitialAdManager) {
        showInterstitialButton?.isEnabled = true
    }

    func onFailedToLoad(interstitialAdManager: CPInterstitialAdManager) {
        showInterstitialButton?.isEnabled = false
    }

    func onDismissed(interstitialAd: CPInterstitialAdManager) {
    }

    func onFailedToLoad(bannerAdManager: CPBannerAdManager) {
        requestBannerButton.isEnabled = true
    }

    func onLoaded(bannerAdManager: CPBannerAdManager, height: CGFloat) {
        print("chope: \(bannerContainerViewHeightConstraint.constant): (height)")
        requestBannerButton.isEnabled = true
    }

}
