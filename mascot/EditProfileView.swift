//
//  editView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//

import SwiftUI
import PhotosUI




struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    private var userManager = UserManager()
    
    // Form fields
    @State private var name: String = ""
    @State private var gender: Gender = .female
    @State private var birthDate: Date = Date()
    @State private var phoneNumber: String = ""
    @State private var country: String = ""
    
    // Available countries (would typically come from an API)
    private let countries = ["México", "Estados Unidos", "España", "Argentina", "Colombia", "Chile", "Perú", "Brasil"]
    @State private var showCountryPicker = false
    
    // Image picker
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    // Validation
    @State private var showingValidationAlert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
            
            VStack(spacing: 0) {
                // Header with back button
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile image section
                        profileImageView
                        
                        // Form fields
                        formFieldsView
                        
                        // Save button
                        saveButton
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        
        .photosPicker(isPresented: $showingImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
        .alert("Error", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showCountryPicker) {
            countryPickerSheet
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            ZStack {
                // Title in the center
                Text("Ficha de perfil")
                    .font(.custom("Noteworthy", size: 30))
                    .foregroundColor(Color.pink)
                    .frame(maxWidth: .infinity)
                
                // Back button aligned to the leading edge
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.gray.opacity(0.3)))
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 15)
    }
    
    // MARK: - Profile Image View
    private var profileImageView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.gray)
                }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.accent))
                }
                .offset(x: 55, y: 55)
            }
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Form Fields View
    private var formFieldsView: some View {
        VStack(spacing: 20) {
            // Name field
            VStack(alignment: .leading, spacing: 8) {
                Text("Nombre")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("Escribe aquí. Maximo 20 palabras", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Gender selection
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 20) {
                    ForEach(Gender.allCases) { genderOption in
                        genderRadioButton(
                            isSelected: gender == genderOption,
                            symbol: genderOption.symbol
                        ) {
                            gender = genderOption
                        }
                    }
                }
            }
            
            // Birth date
            VStack(alignment: .leading, spacing: 8) {
                Text("Fecha de nacimiento")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Phone number
            VStack(alignment: .leading, spacing: 8) {
                Text("Teléfono")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                TextField("Escribe aquí. Maximo 20 palabras", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Country selection
            VStack(alignment: .leading, spacing: 8) {
                Text("País")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    showCountryPicker = true
                }) {
                    HStack {
                        Text(country.isEmpty ? "Seleccionar" : country)
                            .foregroundColor(country.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Country Picker Sheet
    private var countryPickerSheet: some View {
        NavigationStack {
            List {
                ForEach(countries, id: \.self) { countryName in
                    Button(action: {
                        country = countryName
                        showCountryPicker = false
                    }) {
                        Text(countryName)
                    }
                }
            }
            .navigationTitle("Seleccionar País")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        showCountryPicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: saveUserProfile) {
            Text("Guardar")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.accent)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Helper Views
    private func genderRadioButton(isSelected: Bool, symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Circle()
                    .stroke(isSelected ? Color.pink : Color.gray, lineWidth: 2)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.pink.opacity(0.7) : Color.clear)
                            .padding(4)
                    )
                    .frame(width: 30, height: 50)
                
                Text(symbol)
                    .font(.title)
                    .foregroundColor(isSelected ? .pink : .gray)
            }
        }
    }
    
    // MARK: - Save Action
    func saveUserProfile() {
        // Validate required fields
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "El nombre es obligatorio"
            showingValidationAlert = true
            return
        }
        
        if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "El número de teléfono es obligatorio"
            showingValidationAlert = true
            return
        }
        
        if country.isEmpty {
            errorMessage = "Selecciona un país"
            showingValidationAlert = true
            return
        }
        
        // Create new user
        var newUser = User(
            name: name,
            gender: gender,
            birthDate: birthDate,
            phoneNumber: phoneNumber,
            country: country
        )
        
        if let selectedImage = selectedImage {
            newUser.setImage(selectedImage)
        }
        
        // Save user data
        userManager.saveUser(newUser)
        
        // Dismiss the view
        dismiss()
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
