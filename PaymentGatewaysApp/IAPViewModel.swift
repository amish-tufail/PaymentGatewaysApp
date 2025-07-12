//
//  IAPViewModel.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 03/07/2025.
//

import Foundation
import RevenueCat

// MARK: Same for basic and complex case
// Handles the RevenueCat SDK directly (offers, purchases, upgrades, restores).
// Refer Xmind RC 2
final class IAPViewModel: ObservableObject {
    @Published var packagesByTier: [String: [Package]] = [:]
    
    func loadOfferings() {
        Task {
            do {
                let offerings = try await Purchases.shared.offerings()
                guard let current = offerings.current else { return }
                
                var grouped: [String: [Package]] = [:]
                
                for package in current.availablePackages {
                    let id = package.storeProduct.productIdentifier
                    if id.contains("lite") {
                        grouped["Lite", default: []].append(package)
                    } else if id.contains("pro") {
                        grouped["Pro", default: []].append(package)
                    }
                }

                DispatchQueue.main.async {
                    self.packagesByTier = grouped
                }
            } catch {
                print("Failed to load offerings: \(error)")
            }
        }
    }
}
