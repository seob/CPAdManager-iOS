//
//  ViewController.swift
//  CPAdManager
//
//  Created by Chope on 2016. 7. 2..
//  Copyright (c) 2016 Chope. All rights reserved.
//


import UIKit
import CPAdManager
import FBAudienceNetwork


class ViewController: UIViewController {
    @IBOutlet fileprivate weak var requestBannerButton: UIButton!
    @IBOutlet fileprivate weak var requestNativeButton: UIButton!
    @IBOutlet fileprivate weak var showInterstitialButton: UIButton!
    @IBOutlet fileprivate weak var bannerContainerView: UIView!
    @IBOutlet fileprivate weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var nativeContainerView: UIView!
    @IBOutlet fileprivate weak var nativeContainerViewHeightConstraint: NSLayoutConstraint!

    private var interstitialAdManager: CPInterstitialAdManager!
    private var bannerAdManager: CPBannerAdManager!
    private var nativeAdManager: CPNativeAdManager!

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

        FBAdSettings.setLogLevel(.error)

        interstitialAdManager = CPInterstitialAdManager(interstitialAds: [
                CPAdmobInterstitialAd(unitId: "ca-app-pub-3940256099942544/1033173712"),
                CPFacebookInterstitialAd(placementId: "1351290504887194_1726465200703054")
        ], identifierForFirstAd: "facebook") { [weak self] manager, state in
            switch state {
            case .idle:
                break
            case .errorForOneCycle:
                self?.showInterstitialButton?.isEnabled = false
            case .loaded:
                self?.showInterstitialButton?.isEnabled = true
            case .willDismissed:
                break
            case .didDismissed:
                break
            }
        }
        interstitialAdManager.failForDebug = true
        interstitialAdManager.requestAd()

        bannerAdManager = CPBannerAdManager(bannerAds: [
                CPAdmobBannerAd(unitId: "ca-app-pub-3940256099942544/6300978111"),
                CPFacebookBannerAd(placementId: "1351290504887194_1351290761553835")
        ], identifierForFirstAd: "facebook", viewController: self, containerView: bannerContainerView) { [weak self] manager, state in
            guard let ss = self else { return }

            switch state {
            case .loaded(let height):
                ss.bannerContainerViewHeightConstraint.constant = height
                print("CPAdManager: \(ss.bannerContainerViewHeightConstraint.constant): \(height)")
            case .errorForOneCycle:
                break
            case .idle:
                break
            }
            ss.requestBannerButton.isEnabled = true
        }
        bannerAdManager.failForDebug = true
        bannerAdManager.request()

        nativeAdManager = CPNativeAdManager(nativeAds: [
                CPAdmobNativeAd(unitId: "ca-app-pub-3940256099942544/4270592515"),
                CPFacebookNativeAd(placementId: "1351290504887194_1773840312632209", adViewType: .genericHeight300)
        ], identifierForFirstAD: "Admob", containerView: nativeContainerView) { [weak self] _, state in
            switch state {
            case .loaded(let height):
                self?.nativeContainerViewHeightConstraint.constant = height
            case .errorForOneCycle:
                break
            case .idle:
                break
            }

            self?.requestNativeButton.isEnabled = true
        }
        nativeAdManager.rootViewController = self
        nativeAdManager.failForDebug = true
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

    @IBAction func showNativeAd(_ button: UIButton?) {
        nativeAdManager.request()
        button?.isEnabled = false
    }
}