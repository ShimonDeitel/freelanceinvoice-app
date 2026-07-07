import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAdd = false
    @State private var showPaywall = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.client)
                                    .font(Theme.bodyFont.weight(.semibold))
                                    .foregroundColor(.white)
                                Text(item.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                            Text(String(format: "$%.2f", item.amount))
                                .foregroundColor(Theme.accent2)
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Freelanceinvoice")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showAdd = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddItemView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
        }
        .tint(Theme.accent)
    }
}

struct AddItemView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @State private var client: String = ""
    @State private var amountText: String = ""
    @State private var paid: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("New Invoice") {
                TextField("Client", text: $client)
                    .accessibilityIdentifier("field_client")
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_amount")
                Toggle("Paid", isOn: $paid)
                    .accessibilityIdentifier("field_paid")
                }
            }
            .navigationTitle("Add Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = FreelanceinvoiceItem(client: client, amount: Double(amountText) ?? 0, paid: paid)
                        store.add(item)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
