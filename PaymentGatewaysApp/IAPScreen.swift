//
//  IAPScreen.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 03/07/2025.
//

// MARK: BASIC

//import SwiftUI
//import RevenueCat
//
//struct IAPScreen: View {
//    
//    @StateObject private var viewModel = IAPViewModel()
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        TabView {
//            ForEach(viewModel.packagesByTier.sorted(by: { $0.key < $1.key }), id: \.key) { tier, packages in
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("\(tier) Package")
//                        .font(.largeTitle.bold())
//
//                    ForEach(packages, id: \.identifier) { package in
//                        Button {
//                            purchase(package)
//                        } label: {
//                            VStack(alignment: .leading) {
//                                Text("\(package.storeProduct.localizedTitle)")
//                                Text(package.storeProduct.localizedPriceString)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding()
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(8)
//                    }
//                }
//                .padding()
//            }
//        }
//        .tabViewStyle(.page(indexDisplayMode: .automatic))
//        .onAppear {
//            viewModel.loadOfferings()
//        }
//    }
//    
//    private func purchase(_ package: Package) {
//          Task {
//              do {
//                  let result = try await Purchases.shared.purchase(package: package)
//                  let entitlements = result.customerInfo.entitlements.active.keys
//                  print("Unlocked: \(entitlements)")
//                  dismiss()
//              } catch {
//                  print("Purchase failed: \(error.localizedDescription)")
//              }
//          }
//      }
//}
//
//#Preview {
//    IAPScreen()
//}




// MARK: ADVANCE 1

//import SwiftUI
//import RevenueCat
//
//struct IAPScreen: View {
//
//    @StateObject private var viewModel = IAPViewModel()
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var status: SubscriptionStatus
//    @State private var showAlert: Bool = false
//    @State private var alertMessage: String = ""
//
//    var body: some View {
//        TabView {
//            ForEach(viewModel.packagesByTier.sorted(by: { $0.key < $1.key }), id: \.key) { tier, packages in
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("\(tier) Package")
//                        .font(.largeTitle.bold())
//
//                    ForEach(packages, id: \.identifier) { package in
//                        // Show only upgrade/downgrade options based on user's current plan
//                        if canDisplayPackage(package) {
//                            Button {
//                                purchase(package)
//                            } label: {
//                                VStack(alignment: .leading) {
//                                    Text("\(package.storeProduct.localizedTitle)")
//                                    Text(package.storeProduct.localizedPriceString)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            .padding()
//                            .background(Color.blue.opacity(0.1))
//                            .cornerRadius(8)
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .tabViewStyle(.page(indexDisplayMode: .automatic))
//        .onAppear {
//            viewModel.loadOfferings()
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Purchase Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    private func canDisplayPackage(_ package: Package) -> Bool {
//        // Logic to show only upgrade/downgrade options based on user's access level
//        if status.accessLevel == "Free" {
//            return true // Free users see all packages
//        } else if status.accessLevel == "Lite" {
//            return package.identifier.contains("pro") // Lite user can upgrade to Pro
//        } else if status.accessLevel == "Pro" {
//            return package.identifier.contains("lite") // Pro user can downgrade to Lite
//        }
//        return false
//    }
//
//    private func purchase(_ package: Package) {
//        Task {
//            do {
//                let result = try await Purchases.shared.purchase(package: package)
//                let entitlements = result.customerInfo.entitlements.active.keys
//                if entitlements.contains("pro_access") {
//                    alertMessage = "You’ve upgraded to Pro!"
//                } else if entitlements.contains("lite_access") {
//                    alertMessage = "You’ve upgraded to Lite!"
//                }
//                showAlert.toggle()
//                dismiss()
//            } catch {
//                alertMessage = "Purchase failed: \(error.localizedDescription)"
//                showAlert.toggle()
//            }
//        }
//    }
//}


// MARK: ADVANCE 2
//
//  IAPScreen.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 03/07/2025.
//

import SwiftUI
import RevenueCat

struct IAPScreen: View {
    
    @StateObject private var viewModel = IAPViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var status: SubscriptionStatus
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Available Packages")
                .font(.largeTitle.bold())

            // Show message if the user can upgrade or downgrade
            if status.upgradeAvailable {
                Text("You can upgrade to:")
                    .foregroundColor(.green)
                    .font(.headline)
            } else if status.downgradeAvailable {
                Text("You can downgrade to:")
                    .foregroundColor(.red)
                    .font(.headline)
            } else {
                Text("No upgrades or downgrades available.")
                    .foregroundColor(.gray)
                    .font(.headline)
            }

            // Show relevant packages based on upgrade/downgrade availability
            if status.upgradeAvailable {
                showUpgradePackages
            } else if status.downgradeAvailable {
                showDowngradePackages
            } else {
                showAllPackages // Show all for free users
            }
        }
        .padding()
        .onAppear {
            viewModel.loadOfferings()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Purchase Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .environmentObject(status)
    }
    
    // Show available packages for upgrade
    var showUpgradePackages: some View {
        ForEach(viewModel.packagesByTier["Pro"] ?? [], id: \.identifier) { package in
            Button {
                purchase(package)
            } label: {
                VStack(alignment: .leading) {
                    Text("\(package.storeProduct.localizedTitle)")
                    Text(package.storeProduct.localizedPriceString)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Display subscription duration (Weekly or Yearly)
                    if package.storeProduct.subscriptionPeriod?.unit == .week {
                        Text("Duration: Weekly")
                            .foregroundColor(.gray)
                    } else if package.storeProduct.subscriptionPeriod?.unit == .year {
                        Text("Duration: Yearly")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // Show available packages for downgrade
    var showDowngradePackages: some View  {
        ForEach(viewModel.packagesByTier["Lite"] ?? [], id: \.identifier) { package in
            Button {
                purchase(package)
            } label: {
                VStack(alignment: .leading) {
                    Text("\(package.storeProduct.localizedTitle)")
                    Text(package.storeProduct.localizedPriceString)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Display subscription duration (Weekly or Yearly)
                    if package.storeProduct.subscriptionPeriod?.unit == .week {
                        Text("Duration: Weekly")
                            .foregroundColor(.gray)
                    } else if package.storeProduct.subscriptionPeriod?.unit == .year {
                        Text("Duration: Yearly")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // Show all available packages for free users
    var showAllPackages: some View {
        ForEach(viewModel.packagesByTier.sorted(by: { $0.key < $1.key }), id: \.key) { tier, packages in
            VStack(alignment: .leading, spacing: 20) {
                Text("\(tier) Package")
                    .font(.headline)
                
                ForEach(packages, id: \.identifier) { package in
                    Button {
                        purchase(package)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(package.storeProduct.localizedTitle)")
                            Text(package.storeProduct.localizedPriceString)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // Display subscription duration (Weekly or Yearly)
                            if package.storeProduct.subscriptionPeriod?.unit == .week {
                                Text("Duration: Weekly")
                                    .foregroundColor(.gray)
                            } else if package.storeProduct.subscriptionPeriod?.unit == .year {
                                Text("Duration: Yearly")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }

    private func purchase(_ package: Package) {
        Task {
            do {
                let result = try await Purchases.shared.purchase(package: package)
                let entitlements = result.customerInfo.entitlements.active.keys
                if entitlements.contains("pro_access") {
                    alertMessage = "You’ve upgraded to Pro!"
                } else if entitlements.contains("lite_access") {
                    alertMessage = "You’ve upgraded to Lite!"
                }
                showAlert.toggle()
//                dismiss()
            } catch {
                alertMessage = "Purchase failed: \(error.localizedDescription)"
                showAlert.toggle()
            }
        }
    }
}




#Preview {
    IAPScreen()
}


