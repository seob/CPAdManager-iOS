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

    let interstitialAdManager = CPInterstitialAdManager([
            CPFacebookInterstitialAd("1351290504887194_1351290761553835"),
            CPAdmobInterstitialAd("ca-app-pub-3940256099942544/4411468910")
    ])
//    let interstitialAdManager = CPInterstitialAdManager([
//            CPAdmobInterstitialAd("ca-app-pub-3940256099942544/4411468910"),
//            CPFacebookInterstitialAd("1351290504887194_1351290761553835")
//    ])

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

        self.interstitialAdManager.failForDebug = true
        self.interstitialAdManager.setShowAfterLoadedAd(true, viewController: self)
        self.interstitialAdManager.requestAd()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func requestAd(button: UIButton?) {
        button?.enabled = false
        self.showInterstitialButton?.enabled = false

        self.interstitialAdManager.setShowAfterLoadedAd(false, viewController: nil)
        self.interstitialAdManager.requestAd(self)
    }

    @IBAction func showInterstitialAd(button: UIButton?) {
        self.interstitialAdManager.show(self)
        button?.enabled = false
    }

    @IBAction func reloadAfterDismissAd(button: UIButton?) {
        self.interstitialAdManager.reloadAdAfterDismissAd = true
    }

    func loadedInterstitialAd(adManager: CPInterstitialAdManager) {
        self.showInterstitialButton?.enabled = true
        self.requestInterstitialButton?.enabled = true
    }

    func failedToLoadInterstitialAd(adManager: CPInterstitialAdManager) {
        self.showInterstitialButton?.enabled = false
        self.requestInterstitialButton?.enabled = true
    }

    func dismissAd(adManager: CPInterstitialAdManager) {
    }

}
