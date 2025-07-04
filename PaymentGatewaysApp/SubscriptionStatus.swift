//
//  SubscriptionStatus.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 03/07/2025.
//

// MARK: BASIC

//import RevenueCat
//import Foundation
//
//class SubscriptionStatus: ObservableObject {
//    @Published var accessLevel: String = "Free"
//
//    func checkEntitlement() {
//        Task {
//            do {
//                let info = try await Purchases.shared.customerInfo()
//                DispatchQueue.main.async {
//                    if info.entitlements["pro_access"]?.isActive == true {
//                        self.accessLevel = "Pro"
//                    } else if info.entitlements["lite_access"]?.isActive == true {
//                        self.accessLevel = "Lite"
//                    } else {
//                        self.accessLevel = "Free"
//                    }
//                }
//            } catch {
//                print("Error fetching entitlements: \(error)")
//            }
//        }
//    }
//}


// MARK: ADVANCE
import Foundation
import RevenueCat

class SubscriptionStatus: ObservableObject {
    @Published var accessLevel: String = "Free"
    @Published var expiryDate: String = "N/A"
    @Published var renewalDate: String = "N/A"
    @Published var upgradeAvailable: Bool = false
    @Published var downgradeAvailable: Bool = false
    @Published var currentPlan: String = "Free"
    @Published var currentSubscriptionPeriod: String? = nil // To track duration (Weekly/Yearly)
    @Published var packagesByTier: [String: [Package]] = [:] // To track the packages for upgrade/downgrade

    func checkEntitlement() {
        Task {
            do {
                let info = try await Purchases.shared.customerInfo()
                // Use DispatchQueue.main.async to update UI
                DispatchQueue.main.async {
                    if let proEntitlement = info.entitlements["pro_access"], proEntitlement.isActive {
                        self.accessLevel = "Pro"
                        self.currentPlan = "Pro"
                        self.expiryDate = self.formatDate(proEntitlement.expirationDate)
                        self.renewalDate = self.formatDate(proEntitlement.rawData["renewal_date"] as? Date ?? Date())
                        self.upgradeAvailable = false // No upgrade available (already on Pro)
                        self.downgradeAvailable = true // Can downgrade to Lite
                        
                        // Get the duration (Weekly or Yearly) of the Pro plan
                        self.currentSubscriptionPeriod = proEntitlement.productIdentifier.contains("rcw") ? "Weekly" : "Yearly"
                    } else if let liteEntitlement = info.entitlements["lite_access"], liteEntitlement.isActive {
                        self.accessLevel = "Lite"
                        self.currentPlan = "Lite"
                        self.expiryDate = self.formatDate(liteEntitlement.expirationDate)
                        self.renewalDate = self.formatDate(liteEntitlement.rawData["renewal_date"] as? Date ?? Date())
                        self.upgradeAvailable = true // Can upgrade to Pro
                        self.downgradeAvailable = false // Cannot downgrade further (already on Lite)
                        
                        // Get the duration (Weekly or Yearly) of the Lite plan
                        self.currentSubscriptionPeriod = liteEntitlement.productIdentifier.contains("rcw") ? "Weekly" : "Yearly"
                    } else {
                        self.accessLevel = "Free"
                        self.currentPlan = "Free"
                        self.expiryDate = "N/A"
                        self.renewalDate = "N/A"
                        self.upgradeAvailable = true // Can upgrade to Lite or Pro
                        self.downgradeAvailable = false // No downgrade from Free
                        self.currentSubscriptionPeriod = nil
                    }
                }
            } catch {
                print("Error fetching entitlements: \(error)")
            }
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
