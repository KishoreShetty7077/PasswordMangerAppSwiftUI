//
//  ShowAccountDetailsVc.swift
//  PasswordManger
//
//  Created by hb on 19/09/24.
//

import SwiftUI

struct ShowAccountDetailsVc: View {
    
    var item: AcountsDetails
    @Binding var data: [AcountsDetails]
    @State private var accountName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @State private var isDisableEditing: Bool = true
    @State private var isValidated: Bool = true
    @State private var errorMessage: String = "Please enter app name"

    var body: some View {
        VStack {
            accountDetailsSection
            actionButtons
        }
        .padding(5)
        .onAppear(perform: loadData)
    }

    // MARK: - Subviews
    private var accountDetailsSection: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Account Details")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.blue)

            detailField(title: "Account Type", text: $accountName)
            detailField(title: "Username/Email", text: $email)
            detailField(title: "Password", text: $password)

            if !isValidated {
                Text(errorMessage)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
            }
        }
        .padding(20)
    }

    private func detailField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
            TextField("", text: text)
                .font(.system(size: 18, weight: .bold))
                .disabled(isDisableEditing)
                .focused($isFocused)
                .onChange(of: isDisableEditing) { newValue in
                    isFocused = !newValue
                }
        }
    }

    private var actionButtons: some View {
        HStack {
            Spacer()
            editButton
            deleteButton
            Spacer()
        }
    }

    private var editButton: some View {
        Button {
            isDisableEditing.toggle()
            if isDisableEditing {
                checkValidations()
                if isValidated {
                    updateData()
                }
            }
        } label: {
            Text(isDisableEditing ? "Edit" : "Save")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 125, height: 20)
        .padding()
        .background(Color.black)
        .cornerRadius(30)
    }

    private var deleteButton: some View {
        Button {
            if isDisableEditing {
                deleteAccount()
            }
        } label: {
            Text("Delete")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 125, height: 20)
        .padding()
        .background(isDisableEditing ? Color.red : Color.gray)
        .cornerRadius(30)
    }

    // MARK: - Functions
    private func loadData() {
        accountName = item.appName
        email = item.mail
        password = item.password
    }

    private func deleteAccount() {
        if let index = data.firstIndex(where: { item.id == $0.id }) {
            data.remove(at: index)
            dismiss()
            CoreData.shared.deleteAccount(accountID: item.id)
        }
    }

    private func updateData() {
        if let index = data.firstIndex(where: { item.id == $0.id }) {
            data[index].appName = accountName
            data[index].mail = email
            data[index].password = password
            CoreData.shared.updateAccount(data[index])
        }
    }

    private func checkValidations() {
        if accountName.isEmpty {
            showValidationError("Please enter the account name")
        } else if email.isEmpty {
            showValidationError("Please enter the username/email")
        } else if password.isEmpty {
            showValidationError("Please enter the password")
        } else {
            isValidated = true
        }
    }

    private func showValidationError(_ message: String) {
        isDisableEditing = false
        isValidated = false
        errorMessage = message
    }
}
