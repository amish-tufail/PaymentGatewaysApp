//
//  PaymentGatewaysAppApp.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 30/06/2025.
//

import SwiftUI
import RevenueCat

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
