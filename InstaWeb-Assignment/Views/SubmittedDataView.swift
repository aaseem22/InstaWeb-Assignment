//
//  SubmittedDataView.swift
//  InstaWeb-Assignment
//
//  Created by Aaseem Mhaskar on 21/01/25.
//

import SwiftUI

struct SubmittedDataView: View {
    @StateObject private var viewModel = FormViewModel()
    @State private var presentationSheet = false
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isFetching {
                    ProgressView("Loading data...")
                } else if !viewModel.submittedData.isEmpty {
                    List(viewModel.submittedData, id: \.firstName) { data in
                        Section{
                            HStack{
                                Text("\(data.firstName)")
                                    .font(.headline)
                            }
                            Text("\(data.lastName)")
                                .font(.headline)
                        } header: {
                            Text("Name:")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        .listRowBackground(Color.section1)
                        .listRowSeparatorTint(Color.black)
                        
                        Section{
                            Text("Pet Name: \(data.petName)")
                                .font(.subheadline)
                            Text("Age: \(data.age)")
                                .font(.subheadline)
                        }header: {
                            Text("Pet Info:")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        .listRowBackground(Color.section2)
                        .listRowSeparatorTint(Color.black)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.darkgray)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading data")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchData()
                        }
                        .padding()
                    }
                } else {
                    Text("No data available")
                        .font(.headline)
                }
            }
            .navigationTitle("Submitted Data")
            .refreshable {
                viewModel.fetchData()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        presentationSheet = true
                    }
                    .foregroundStyle(.black)
    
                }
                //            .navigationBarBackButtonHidden()
                
            }
            .sheet(isPresented: $presentationSheet){
                FormView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                 
            }
            .onAppear {
                viewModel.fetchData()
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
    SubmittedDataView()
}
