//
//  FormView.swift
//  InstaWeb-Assignment
//
//  Created by Aaseem Mhaskar on 21/01/25.
//

import SwiftUI

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    TextField("First Name", text: $viewModel.firstName)
                    TextField("Last Name", text: $viewModel.lastName)
                    TextField("Pet Name", text: $viewModel.petName)
                    TextField("Age", text: $viewModel.age)
                        .keyboardType(.numberPad)
                }
                
                Button(action:{
                    viewModel.submitForm()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .navigationTitle("Submit Data")
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.error?.message ?? "Unknown error occurred")
            }
            .alert("Success", isPresented: $viewModel.isSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Form submitted successfully!")
            }
        }
    }
}

#Preview {
    FormView()
}
