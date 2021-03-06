# CPAdManager

A library that lists possible ads by requesting multiple ad platforms in sequence.

Make more money with the ad platform.

## Feature

* Admob
  * Banner Ad (only portrait)
  * Interstitial Ad
* Facebook Audience Network
  * Banner Ad (only portrait)
  * Interstitial Ad
* Util
  * is installed facebook util

##Installation

### CocoaPods
```
pod 'CPAdManager-iOS'
```

The version of FBAudienceNetwork and GoogleMobileAds framework is not added as cocoapods dependency, so the version depends on CPAdManager-iOS.
If you want to update the version, please post it on the issue.

### Carthage
```
github "yoonhg84/CPAdManager-iOS"
```

Please add FBAudienceNetwork and GoogleMobileAds framework directly.

## Usage

If you have Facebook installed: 1) FBAudienceNetwork, 2) Admob.
Or, 1) Admob, 2) FBAudienceNetwork.

### Interstitial Ad

```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var showInterstitialButton: UIButton!

    private var interstitialAdManager: CPInterstitialAdManager!

    override func viewDidLoad() {
	    super.viewDidLoad()

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
    }

	@IBAction func showInterstitialAd(_ button: UIButton?) {
        interstitialAdManager.show(from: self)
        button?.isEnabled = false
    }
}
```

### Banner Ad

```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var requestBannerButton: UIButton!
    @IBOutlet fileprivate weak var bannerContainerView: UIView!
    @IBOutlet fileprivate weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!

    private var bannerAdManager: CPBannerAdManager!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @IBAction func requestBanner(_ button: UIButton?) {
        button?.isEnabled = false
        bannerAdManager.request()
    }
}
```

### Natvie Ad
```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var requestNativeButton: UIButton!
    @IBOutlet fileprivate weak var nativeContainerView: UIView!
    @IBOutlet fileprivate weak var nativeContainerViewHeightConstraint: NSLayoutConstraint!

    private var nativeAdManager: CPNativeAdManager!

    override func viewDidLoad() {
    super.viewDidLoad()
    	super.viewDidLoad()
        
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

    @IBAction func showNativeAd(_ button: UIButton?) {
        nativeAdManager.request()
        button?.isEnabled = false
    }
}
```

## Add AD Platform

### Banner

Override CPBannerAd.

```swift
open class CPBannerAd: NSObject {
    func request(in viewController: UIViewController) { }
    func set(delegate: CPBannerAdDelegate) { }
    func bannerView() -> UIView? { return nil }
}
```

### Interstitial

Overrides CPInterstitialAd.

```swift
open class CPInterstitialAd: NSObject {
    func requestAd() { }
    func ready() -> Bool { return false }
    func show(ad viewController: UIViewController) { }
    func set(delegate: CPInterstitialAdDelegate) { }
}
```

##License
CPAdManager is released under the MIT license. [See LICENSE](https://github.com/yoonhg84/CPAdManager-iOS/blob/master/LICENSE) for details.



# CPAdManager

복수개의 광고 플랫폼을 순서대로 요청하여 가능한 광고를 보여주는 라이브러리 입니다.

광고 플랫폼을 이용하여 더 많은 수익을 올리세요.

## Feature

* Admob
  * Banner Ad (only portrait)
  * Interstitial Ad
* Facebook Audience Network
  * Banner Ad (only portrait)
  * Interstitial Ad
* Util
  * is installed facebook util

##Installation

### CocoaPods
```
pod 'CPAdManager-iOS'
```

FBAudienceNetwork, GoogleMobileAds framework 의 버전은 cocoapods dependency 로 추가되지 않기 때문에 버전이 CPAdManager-iOS 에 의존적입니다. 
버전 업데이트를 원하시면 issue에 올려주세요.

### Carthage
```
github "yoonhg84/CPAdManager-iOS"
```

FBAudienceNetwork, GoogleMobileAds framework 를 직접 추가해 주세요.

Please add FBAudienceNetwork and GoogleMobileAds framework directly.

## Usage

Facebook 이 설치되어 있으면 FBAudienceNetwork, Admob 순으로 요청합니다.
아니면 Admob, FBAudienceNetwork 순으로 요청합니다.

### Interstitial Ad

```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var showInterstitialButton: UIButton!

    private var interstitialAdManager: CPInterstitialAdManager!

    override func viewDidLoad() {
	    super.viewDidLoad()

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
    }

	@IBAction func showInterstitialAd(_ button: UIButton?) {
        interstitialAdManager.show(from: self)
        button?.isEnabled = false
    }
}
```

### Banner Ad

```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var requestBannerButton: UIButton!
    @IBOutlet fileprivate weak var bannerContainerView: UIView!
    @IBOutlet fileprivate weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!

    private var bannerAdManager: CPBannerAdManager!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    @IBAction func requestBanner(_ button: UIButton?) {
        button?.isEnabled = false
        bannerAdManager.request()
    }
}
```

### Natvie Ad
```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var requestNativeButton: UIButton!
    @IBOutlet fileprivate weak var nativeContainerView: UIView!
    @IBOutlet fileprivate weak var nativeContainerViewHeightConstraint: NSLayoutConstraint!

    private var nativeAdManager: CPNativeAdManager!

    override func viewDidLoad() {
    super.viewDidLoad()
    	super.viewDidLoad()
        
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

    @IBAction func showNativeAd(_ button: UIButton?) {
        nativeAdManager.request()
        button?.isEnabled = false
    }
}
```

## Add AD Platform

### Banner

CPBannerAd 를 상속 받아 override.

```swift
open class CPBannerAd: NSObject {
    func request(in viewController: UIViewController) { }
    func set(delegate: CPBannerAdDelegate) { }
    func bannerView() -> UIView? { return nil }
}
```

### Interstitial

CPInterstitialAd 를 상속 받아 override.

```swift
open class CPInterstitialAd: NSObject {
    func requestAd() { }
    func ready() -> Bool { return false }
    func show(ad viewController: UIViewController) { }
    func set(delegate: CPInterstitialAdDelegate) { }
}
```

##License
CPAdManager is released under the MIT license. [See LICENSE](https://github.com/yoonhg84/CPAdManager-iOS/blob/master/LICENSE) for details.