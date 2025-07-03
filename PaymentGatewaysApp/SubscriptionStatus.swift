//
//  SubscriptionStatus.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 03/07/2025.
//


import RevenueCat
import Foundation

class SubscriptionStatus: ObservableObject {
    @Published var accessLevel: String = "Free"

    func checkEntitlement() {
        Task {
            do {
                let info = try await Purchases.shared.customerInfo()
                DispatchQueue.main.async {
                    if info.entitlements["pro_access"]?.isActive == true {
                        self.accessLevel = "Pro"
                    } else if info.entitlements["lite_access"]?.isActive == true {
                        self.accessLevel = "Lite"
                    } else {
                        self.accessLevel = "Free"
                    }
                }
            } catch {
                print("Error fetching entitlements: \(error)")
            }
        }
    }
}
