//
//  EditPetView.swift
//  mascot
//
//  Created by Jose julian Lopez on 08/05/25.
//


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

    // State to control the presentation of the Photos picker
    @State private var showingImagePicker = false

    // Initializer to set up @State vars from the petToEdit
    init(petManager: PetManager, petToEdit: Pet) {
        self.petManager = petManager
        
        // Initialize @State properties with the pet's current values
        _petToEdit = State(initialValue: petToEdit) // Store the original pet for its ID
        _name = State(initialValue: petToEdit.name)
        _sex = State(initialValue: petToEdit.sex)
        _species = State(initialValue: petToEdit.species)
        _breed = State(initialValue: petToEdit.breed)
        _isSterilized = State(initialValue: petToEdit.isSterilized)
        
        // Initialize selectedImage if current pet has one
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
                                .background(Color.accentColor) // Use accent color
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button for custom header
        .alert("Error de Validación", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        // This is the single .photosPicker modifier, driven by $showingImagePicker
        .photosPicker(isPresented: $showingImagePicker, selection: $photoItem, matching: .images)
        .onChange(of: photoItem) { _, newItem in
            Task { // Task is appropriate here for async image loading
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // Run UI updates on the main thread
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
                .foregroundColor(Color.red.opacity(0.7))
                .frame(maxWidth: .infinity)
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary) // Adaptive color
                        .padding(12)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .padding(.leading, 20)
                Spacer()
            }
        }
        .padding(.vertical, 15)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Image Selection View
    private var imageSelectionView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(UIColor.systemGray4))
                    .frame(width: 120, height: 120)
                
                if let displayImage = selectedImage {
                    Image(uiImage: displayImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "pawprint.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(UIColor.systemGray))
                }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.red.opacity(0.7)))
                }
                .offset(x: 40, y: 40)
            }
            .padding(.bottom, 20)
           
        }
    }
    
    // MARK: - Form Fields View (Similar to PetRegistrationView)
    private var formFieldsView: some View {
        VStack(spacing: 20) {
            // Name
            VStack(alignment: .leading, spacing: 5) {
                Text("Nombre")
                    .font(.headline)
                    .foregroundColor(.secondary)
                TextField("Nombre de la mascota", text: $name)
                    .padding()
                    .background(Color(UIColor.systemGray6)) // Adapts
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Sex
            VStack(alignment: .leading, spacing: 5) {
                Text("Sexo")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Picker("Sexo", selection: $sex) {
                    ForEach(PetSex.allCases) { sexValue in
                        Text(sexValue.rawValue == "M" ? "Macho (♂)" : "Hembra (♀)").tag(sexValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 5) // Add some vertical padding for segmented picker
            }
            
            // Species
            VStack(alignment: .leading, spacing: 5) {
                Text("Especie")
                    .font(.headline)
                    .foregroundColor(.secondary)
                // Using a Menu for species selection
                Menu {
                    ForEach(PetSpecies.allCases) { speciesValue in
                        Button(speciesValue.rawValue) {
                            species = speciesValue
                        }
                    }
                } label: {
                    HStack {
                        Text(species.rawValue)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Ensure it takes full width
                    .background(Color(UIColor.systemGray6))
                    .foregroundColor(.primary) // Ensure text is visible
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
            }
            
            // Breed
            VStack(alignment: .leading, spacing: 5) {
                Text("Raza")
                    .font(.headline)
                    .foregroundColor(.secondary)
                TextField("Raza de la mascota", text: $breed)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Sterilized Toggle
            Toggle(isOn: $isSterilized) {
                Text("¿Está esterilizado/a?")
                    .font(.headline)
                    .foregroundColor(.secondary) // Keep as secondary for consistency
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
    
    // MARK: - Save Action
    private func saveChanges() {
        // Validate inputs
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

        // Create an updated Pet instance
        var updatedPet = petToEdit // Start with the original to keep the ID
        updatedPet.name = name
        updatedPet.sex = sex
        updatedPet.species = species
        updatedPet.breed = breed
        updatedPet.isSterilized = isSterilized
        
        if let newImage = selectedImage {
            // Use jpegData for potentially better compatibility and control over quality
            updatedPet.imageData = newImage.jpegData(compressionQuality: 0.7)
        }
        // If selectedImage is nil, the existing imageData in updatedPet (from petToEdit) remains,
        // unless you explicitly want to clear it.
        
        petManager.updatePet(updatedPet)
        dismiss()
    }
}
