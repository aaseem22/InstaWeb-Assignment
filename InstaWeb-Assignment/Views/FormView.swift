//
//  FormView.swift
//  InstaWeb-Assignment
//
//  Created by Aaseem Mhaskar on 21/01/25.
//

import SwiftUI

struct FormView: View {
    @StateObject
    var viewModel :  FormViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("First Name", text: $viewModel.firstName)
                    TextField("Last Name", text: $viewModel.lastName)
                } header: {
                    Text("Personal Info")
                        .foregroundStyle(.black)
                        .font(.callout)
                        .bold()
                }
                .listRowBackground(Color.section1)
                .listRowSeparatorTint(Color.black)
                
                Section {
                    TextField("Pet Name", text: $viewModel.petName)
                    TextField("Age", text: $viewModel.age)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Pet Info")
                        .foregroundStyle(.black)
                        .font(.callout)
                        .bold()
                }
                .listRowBackground(Color.section1)
                .listRowSeparatorTint(Color.black)
            }
            .scrollContentBackground(.hidden)
            .background(Color.darkgray)
            .navigationTitle("Submit Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.submitForm()
                        viewModel.fetchData()
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
        }
    }
}

#Preview {
    FormView(viewModel: FormViewModel())
}
