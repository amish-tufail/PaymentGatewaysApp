//
//  ContentView.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 30/06/2025.
//

// MARK: BASIC

//import SwiftUI
//
//struct ContentView: View {
//    @State private var openIAP = false
//    @StateObject private var status = SubscriptionStatus()
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading, spacing: 20) {
//                HStack {
//                    Text("Current Plan:")
//                    Text(status.accessLevel)
//                        .foregroundColor(.blue)
//                }
//                .bold()
//
//                Button("Buy Subscription") {
//                    openIAP.toggle()
//                }
//            }
//            .padding()
//            .navigationTitle("RC Test")
//            .onAppear {
//                status.checkEntitlement()
//            }
//            .sheet(isPresented: $openIAP, onDismiss: {
//                status.checkEntitlement() // refresh after purchase
//            }) {
//                IAPScreen()
//            }
//        }
//    }
//}
//
//
//#Preview {
//    ContentView()
//}




// MARK: ADVANCE

//
//  ContentView.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 30/06/2025.
//

import SwiftUI
import RevenueCatUI
import RevenueCat

struct ContentView: View {
    @State private var openIAP = false
    @State private var showPaymentSheet: Bool = false
    @StateObject private var status = SubscriptionStatus()
    
    
    // MARK: METADATA FEATURE
    @State var showText: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: METADATA FEATURE
                if showText {
                    Text("META DATA TEXT SHOWING - ENABLED")
                } else {
                    Text("META DATA TEXT NOT SHOWING - DISABLED")
                }
                HStack {
                    // Display the duration (Weekly or Yearly) first
                    if let subscriptionPeriod = status.currentSubscriptionPeriod {
                        Text(subscriptionPeriod)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }

                    // Display the current plan (Lite or Pro)
                    Text(status.currentPlan)
                        .foregroundColor(.blue)
                }
                .bold()

                // Show upgrade or downgrade options based on current plan
                if status.accessLevel == "Free" {
                    Text("Upgrade to Lite or Pro")
                        .foregroundColor(.green)
                } else if status.upgradeAvailable {
                    Text("You can upgrade to Pro")
                        .foregroundColor(.green)
                } else if status.downgradeAvailable {
                    Text("You can downgrade to Lite")
                        .foregroundColor(.red)
                }
                
                // Show expiry and renewal dates
                Text("Expiry Date: \(status.expiryDate)")
                Text("Renewal Date: \(status.renewalDate)")

                // Button to open IAP screen
                Button("Buy Subscription") {
                    openIAP.toggle()
                }
                
                Button {
                    showPaymentSheet = true
                } label: {
                    Text("Show Paywall")
                }
            }
            .padding()
            .navigationTitle("RC Test")
            .onAppear {
                status.checkEntitlement()
            }
            .sheet(isPresented: $openIAP, onDismiss: {
                status.checkEntitlement() // refresh after purchase
            }) {
                IAPScreen()
            }
            // MARK: PAYWALL FEATURE
            .sheet(isPresented: $showPaymentSheet, onDismiss: {
                status.checkEntitlement()
            }, content: {
                PaywallView()
            })
            // Every time show by entitilment
//            .presentPaywallIfNeeded(requiredEntitlementIdentifier: "default") // like if i want to display paywall on each open if not subscribed - give the enitilment you wnat to show pro or lite
            // FOOTER FEATURE
            .paywallFooter(condensed: true) // false for full view and true for all plan condensed view
            .environmentObject(status)
            // MARK: META DATA feature attach to each specific offering case
            .task {
                guard let result = try? await Purchases.shared.offerings().current else { return }
                showText = result.getMetadataValue(for: "showText", default: false)
            }
        }
    }
}

#Preview {
    ContentView()
}





