//
//  EditPetView.swift
//  mascot
//
//  Created by Jose julian Lopez on 08/05/25.
//


import SwiftUI
import PhotosUI

import SwiftUI
import PhotosUI

struct EditPetView: View {
    @Environment(\.dismiss) private var dismiss
    var petManager: PetManager
    
    @State var petToEdit: Pet

    @State private var name: String
    @State private var sex: PetSex
    @State private var species: PetSpecies
    @State private var breed: String
    @State private var isSterilized: Bool
    
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    
    @State private var showingValidationAlert: Bool = false
    @State private var errorMessage: String = ""

    @State private var showingImagePicker = false

    init(petManager: PetManager, petToEdit: Pet) {
        self.petManager = petManager
        
        _petToEdit = State(initialValue: petToEdit)
        _name = State(initialValue: petToEdit.name)
        _sex = State(initialValue: petToEdit.sex)
        _species = State(initialValue: petToEdit.species)
        _breed = State(initialValue: petToEdit.breed)
        _isSterilized = State(initialValue: petToEdit.isSterilized)
        
        if let imageData = petToEdit.imageData, let uiImage = UIImage(data: imageData) {
            _selectedImage = State(initialValue: uiImage)
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        imageSelectionView
                        formFieldsView
                        
                        Button(action: saveChanges) {
                            Text("Guardar Cambios")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Error de Validación", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $photoItem, matching: .images)
        .onChange(of: photoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                    }
                }
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        ZStack {
            Text("Editar Mascota")
                .font(.custom("Noteworthy", size: 28))
                .foregroundColor(.accent)
                .frame(maxWidth: .infinity)
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white) // Match PetRegistrationView
                        .padding(12)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .padding(.leading, 20)
                Spacer()
            }
        }
        .padding(.vertical, 15)
        .background(Color.white) // Match PetRegistrationView
    }
    
    // MARK: - Image Selection View
    private var imageSelectionView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                if let displayImage = selectedImage {
                    Image(uiImage: displayImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.gray)
                }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(.accent))
                }
                .offset(x: 40, y: 40)
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Form Fields View
    private var formFieldsView: some View {
        VStack(spacing: 20) {
            // Name
            VStack(alignment: .leading, spacing: 5) {
                Text("Nombre")
                    .font(.headline)
                    .foregroundColor(.secondary)
                TextField("Nombre de la mascota", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Sexo")
                    .font(.headline)
                    .foregroundColor(.secondary)
                HStack(spacing: 20) {
                    radioButton(isSelected: sex == .female, label: "F", symbol: "♀︎") {
                        sex = .female
                    }
                    radioButton(isSelected: sex == .male, label: "M", symbol: "♂︎") {
                        sex = .male
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Especie")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Menu {
                    ForEach(PetSpecies.allCases) { speciesOption in
                        Button(speciesOption.rawValue) {
                            species = speciesOption
                        }
                    }
                } label: {
                    HStack {
                        Text(species.rawValue)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.accent)
                    .cornerRadius(10)
                }
            }
            
            // Breed
            VStack(alignment: .leading, spacing: 5) {
                Text("Raza")
                    .font(.headline)
                    .foregroundColor(.secondary)
                TextField("Raza de la mascota", text: $breed)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("¿Tu mascota está esterilizada?")
                    .font(.headline)
                    .foregroundColor(.secondary)
                HStack(spacing: 20) {
                    radioButton(isSelected: !isSterilized, label: "No") {
                        isSterilized = false
                    }
                    radioButton(isSelected: isSterilized, label: "Sí") {
                        isSterilized = true
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Helper View
    private func radioButton(isSelected: Bool, label: String, symbol: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(
                        Circle()
                            .fill(isSelected ? .accent : Color.clear)
                            .padding(4)
                    )
                    .frame(width: 24, height: 24)
                
                if let symbol = symbol {
                    Text(symbol)
                        .font(.title3)
                        .foregroundColor(.accent)
                } else {
                    Text(label)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    // MARK: - Funciones
    private func saveChanges() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "El nombre es obligatorio."
            showingValidationAlert = true
            return
        }
        
        if breed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "La raza es obligatoria."
            showingValidationAlert = true
            return
        }

        var updatedPet = petToEdit
        updatedPet.name = name
        updatedPet.sex = sex
        updatedPet.species = species
        updatedPet.breed = breed
        updatedPet.isSterilized = isSterilized
        
        if let newImage = selectedImage {
            updatedPet.imageData = newImage.jpegData(compressionQuality: 0.7)
        }
        
        petManager.updatePet(updatedPet)
        dismiss()
    }
}
