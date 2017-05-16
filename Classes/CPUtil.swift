//
// Created by Chope on 2017. 5. 17..
// Copyright (c) 2017 Chope. All rights reserved.
//

import UIKit

public struct CPUtil {
    public static func isInstalledFacebook() -> Bool {
        guard let url = URL(string: "fbauth2://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
