//
//  SaveAcountDetailsVc.swift
//  PasswordManger
//
//  Created by hb on 18/09/24.
//

import SwiftUI

struct SaveAcountDetailsVc: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var accountName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidated: Bool = true
    @State private var errorMessage: String = "Please enter app name"

    var onSave: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            inputField("Account name", text: $accountName)
                .onChange(of: accountName) { _ in hideError() }
            inputField("Username/Email", text: $email)
                .onChange(of: email) { _ in hideError() }
            inputField("Password", text: $password)
                .onChange(of: password) { _ in hideError() }

            if !isValidated {
                Text(errorMessage)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.red)
            }

            addButton
        }
        .padding()
    }

    // MARK: - Views
    private func inputField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray)
                .opacity(0.2))
    }

    private var addButton: some View {
        Button("Add New Account") {
            addNewAccount()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    // MARK: - Functions
    private func addNewAccount() {
        checkValidations()
        if isValidated {
            let newAccount = AcountsDetails(appName: accountName, mail: email, password: password)
            CoreData.shared.saveAccount(newAccount)
            onSave?()
            dismiss()
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
        isValidated = false
        errorMessage = message
    }

    private func hideError() {
        isValidated = true
    }
}
