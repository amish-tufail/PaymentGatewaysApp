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

    var body: some View {
        TabView {
            ForEach(viewModel.packagesByTier.sorted(by: { $0.key < $1.key }), id: \.key) { tier, packages in
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(tier) Package")
                        .font(.largeTitle.bold())

                    ForEach(packages, id: \.identifier) { package in
                        Button {
                            purchase(package)
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(package.storeProduct.localizedTitle)")
                                Text(package.storeProduct.localizedPriceString)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .onAppear {
            viewModel.loadOfferings()
        }
    }
    
    private func purchase(_ package: Package) {
          Task {
              do {
                  let result = try await Purchases.shared.purchase(package: package)
                  let entitlements = result.customerInfo.entitlements.active.keys
                  print("Unlocked: \(entitlements)")
                  dismiss()
              } catch {
                  print("Purchase failed: \(error.localizedDescription)")
              }
          }
      }
}

#Preview {
    IAPScreen()
}
