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

struct ContentView: View {
    @State private var openIAP = false
    @State private var showPaymentSheet: Bool = false
    @StateObject private var status = SubscriptionStatus()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
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
            
            .sheet(isPresented: $showPaymentSheet, onDismiss: {
                status.checkEntitlement()
            }, content: {
                PaywallView()
            })
            .environmentObject(status)
        }
    }
}

#Preview {
    ContentView()
}





