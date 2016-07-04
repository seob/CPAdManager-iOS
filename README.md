# CPAdManager-iOS

For people that earn money using mobile ads (Admob, Facebook Audience Network)

## Feature

* Admob
* Facebook Audience Network
* Banner Ad (only portrait)
* Interstitial Ad

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
