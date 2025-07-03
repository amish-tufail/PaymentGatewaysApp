//
//  ContentView.swift
//  PaymentGatewaysApp
//
//  Created by Amish Tufail on 30/06/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var openIAP = false
    @StateObject private var status = SubscriptionStatus()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Current Plan:")
                    Text(status.accessLevel)
                        .foregroundColor(.blue)
                }
                .bold()

                Button("Buy Subscription") {
                    openIAP.toggle()
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
        }
    }
}


#Preview {
    ContentView()
}



