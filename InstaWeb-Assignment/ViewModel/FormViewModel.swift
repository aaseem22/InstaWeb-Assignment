//
//  FormViewModel.swift
//  InstaWeb-Assignment
//
//  Created by Aaseem Mhaskar on 21/01/25.
//

import Foundation
import Combine

class FormViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var petName: String = ""
    @Published var age: String = ""
    
    @Published var isLoading: Bool = false
    @Published var error: NetworkError?
    @Published var isSuccess: Bool = false
    @Published var isFetching: Bool = false
    @Published var submittedData: [FormData] = []
    var isFormValid: Bool {
            !firstName.isEmpty && !lastName.isEmpty && !petName.isEmpty && !age.isEmpty
        }
    
 
    private let apiURL = "https://67932dcb5eae7e5c4d8dce12.mockapi.io/user/data"
    
    func submitForm() {
        guard isFormValid else { return }
        isLoading = true
        error = nil
        
        let formData = FormData(
            firstName: firstName,
            lastName: lastName,
            petName: petName,
            age: age
        )
        
        guard let url = URL(string: apiURL) else {
            isLoading = false
            error = .invalidURL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(formData)
        } catch {
            isLoading = false
            self.error = .decodingError
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = .serverError(error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self?.error = .invalidResponse
                    return
                }
                
                guard let _ = data else {
                    self?.error = .noData
                    return
                }
                
                self?.isSuccess = true
                self?.clearForm()
            }
        }.resume()
    }
    
    func fetchData() {
        isFetching = true
        error = nil
        
        guard let url = URL(string: apiURL) else {
            isFetching = false
            error = .invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isFetching = false
                
                if let error = error {
                    self?.error = .serverError(error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self?.error = .invalidResponse
                    return
                }
                
                guard let data = data else {
                    self?.error = .noData
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([FormData].self, from: data)
                    self?.submittedData = decodedData
                } catch {
                    self?.error = .decodingError
                }
            }
        }.resume()
    }
    
    private func clearForm() {
        firstName = ""
        lastName = ""
        petName = ""
        age = ""
    }
}
