//
// Created by Chope on 2017. 5. 17..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public struct CPUtil {
    public static func isInstalledFacebook() -> Bool {
        guard let url: URL = URL(string: "fbauth2://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    public static func resize(_ size: CGSize, fitWidth: CGFloat) -> CGSize {
        let ratio: CGFloat = fitWidth / size.width
        return CGSize(width: fitWidth, height: size.height * ratio)
    }
}

public extension UIView {
    public func addLaunchScreenView(name: String) -> UIView? {
        guard let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            assertionFailure()
            return nil
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
        addConstraints(constraints)

        return view
    }
}

extension UIStoryboard {
    public func addLaunchScreen(nibName: String) -> UIView? {
        guard let viewController = instantiateInitialViewController() else {
            assertionFailure()
            return nil
        }
        guard let launchView = viewController.view.addLaunchScreenView(name: nibName) else {
            assertionFailure()
            return nil
        }
        return launchView
    }
}