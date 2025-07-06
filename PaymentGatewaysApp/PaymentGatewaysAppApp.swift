//
//  PaymentGatewaysAppApp.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 30/06/2025.
//

import SwiftUI
import RevenueCat

/**
 
 // 1. Setup on Appstore Connect
 // 2. Setup on RC -> E -> P -> O
 // 3. Install SDK
 // 4. Init
 // 5. IAPVM -> handle the purchase thing
 // 5. Status -> Used to unlock access level features pro lite etc after purchase like this feature unlocks on pro and this in lite this is handled by this
 // 5. Paywall -> Setup on RC Console -> Here just call PaywallView() -> That's it
 
 */
@main
struct PaymentGatewaysAppApp: App {
    init() {
                                        // Project specfic key
        Purchases.configure(withAPIKey: "appl_JBtoeTslddkIDDayVOkOLbFcIky")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
