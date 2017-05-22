# CPAdManager-iOS

CPAdManager was developed for individual developers using multiple advertising platforms.
If the ad request fails, request an ad on the following ad platform:
I expect your profits to go up one dollar.

## Requirements

* Swift >= 3.1
* FBAudienceNetwork >= 4.22
* Firebase/AdMob >= 3.17

## Feature

* Support Admob, Facebook-Audience-Network
  * Support Interstitial AD
  * Support Banner Ad (only portrait)
* If fail to load, request ad automatically.
* Delegation of AD load completion and failure.

## Usage

### Interstitial Ad

Show interstitial ad after loaded

```swift
class ViewController : UIViewController {
  let interstitialAdManager = CPInterstitialAdManager([
          CPFacebookInterstitialAd("Facebook Audience Network placement id"),
          CPAdmobInterstitialAd("Admob ad unit id")
  ])

  override func viewDidLoad() {
      super.viewDidLoad()

      self.interstitialAdManager.setShowAfterLoadedAd(true, viewController: self)
      self.interstitialAdManager.requestAd(nil)
  }
}
```

Show interstitial when click

```swift
soon...
```

### Banner Ad

```swift
class ViewController: UIViewController {
    @IBOutlet weak var bannerContainerHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var bannerContainerView: UIView?
    var bannerAdManager: CPBannerAdManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bannerContainerHeightLayoutConstraint?.constant = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 90 : 50
        self.bannerAdManager = CPBannerAdManager(self, ads: [
                CPFacebookBannerAd("Facebook Audience Network placement id"),
                CPAdmobBannerAd("Admob ad unit id")
        ])
        self.bannerAdManager?.rootViewController = self
        self.bannerAdManager?.containerView = self.bannerContainerView
        self.bannerAdManager?.request()
    }
}
```

## License

CPAdManager-iOS is released under the MIT license. [See LICENSE](https://github.com/yoonhg84/CPAdManager-iOS/blob/master/LICENSE) for details.