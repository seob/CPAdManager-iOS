//
//  ViewController.swift
//  CPAdManager
//
//  Created by Chope on 2016. 7. 2..
//  Copyright (c) 2016 Chope. All rights reserved.
//


import UIKit


class ViewController: UIViewController, CPInterstitialAdManagerDelegate {
    @IBOutlet weak var requestInterstitialButton: UIButton?
    @IBOutlet weak var showInterstitialButton: UIButton?

    let admob: CPInterstitialAd = CPAdmobInterstitialAd(unitId: "ca-app-pub-3940256099942544/4411468910")
    let facebook: CPInterstitialAd = CPFacebookInterstitialAd(placementId: "1351290504887194_1351290761553835")

    let interstitialAdManager: CPInterstitialAdManager

    public required init?(coder aDecoder: NSCoder) {
        interstitialAdManager = CPInterstitialAdManager(interstitialAds: [
                admob,
                facebook,
        ], firstAd: CPUtil.isInstalledFacebook() ? facebook : admob)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

        interstitialAdManager.delegate = self
        interstitialAdManager.failForDebug = true
        interstitialAdManager.requestAd()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func requestAd(_ button: UIButton?) {
        button?.isEnabled = false
        showInterstitialButton?.isEnabled = false
        interstitialAdManager.requestAd()
    }

    @IBAction func showInterstitialAd(_ button: UIButton?) {
        interstitialAdManager.show(from: self)
        button?.isEnabled = false
    }

    func onLoaded(interstitialAdManager: CPInterstitialAdManager) {
        showInterstitialButton?.isEnabled = true
        requestInterstitialButton?.isEnabled = true
    }

    func onFailedToLoad(interstitialAdManager: CPInterstitialAdManager) {
        showInterstitialButton?.isEnabled = false
        requestInterstitialButton?.isEnabled = true
    }

    func onDismissed(interstitialAd: CPInterstitialAdManager) {
    }

}
