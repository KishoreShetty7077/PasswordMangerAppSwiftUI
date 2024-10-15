//
//  ContentView.swift
//  PasswordManger
//
//  Created by hb on 18/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var accountsData: [AcountsDetails] = []
    @State private var presentSheet = false
    @State private var selectedItem: AcountsDetails?

    var body: some View {
        NavigationStack {
            VStack {
                headerView

                Divider()
                    .background(Color.gray)

                accountsListView

                addButton
                    .padding()
                    .frame(height: 100)
            }
            .background(Color(UIColor(red: 243/255, green: 245/255, blue: 250/255, alpha: 1)))
            .overlay {
                if accountsData.isEmpty {
                    noDataOverlay
                }
            }
            .onAppear {
                fetchAccountsData()
            }
        }
    }

    // MARK: - Views
    private var headerView: some View {
        HStack {
            Text("Password Manager")
                .font(.system(size: 20, weight: .bold))
            Spacer()
        }
        .padding(.leading)
    }

    private var accountsListView: some View {
        List {
            ForEach(accountsData) { item in
                Section {
                    accountRow(for: item)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(25)
        }
        .sheet(item: $selectedItem) { selectedItem in
            ShowAccountDetailsVc(item: selectedItem, data: $accountsData)
                .presentationDetents([.height(400)])
        }
        .listStyle(.plain)
        .background(Color.clear)
    }

    private func accountRow(for item: AcountsDetails) -> some View {
        HStack(alignment: .center) {
            Text(item.appName)
                .font(.system(size: 18, weight: .medium))
            Text("*******")
                .foregroundColor(.gray)
            Spacer()
            Button {
                selectedItem = item
            } label: {
                Image(systemName: "chevron.right")
                    .font(.footnote)
            }
        }
    }

    private var addButton: some View {
        HStack {
            Spacer()
            Button {
                presentSheet.toggle()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .sheet(isPresented: $presentSheet) {
                SaveAcountDetailsVc(onSave: fetchAccountsData)
                    .presentationDetents([.height(300)])
            }
        }
    }

    private var noDataOverlay: some View {
        VStack {
            Text("No accounts found.Click Add button to add your account details!")
                .frame(height: 100, alignment: .center)
        }
        .padding()
    }

    // MARK: - Core Data Fetch
    private func fetchAccountsData() {
        accountsData = CoreData.shared.fetchDataFromCoreData()
    }
}


#Preview {
    ContentView()
}
