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
