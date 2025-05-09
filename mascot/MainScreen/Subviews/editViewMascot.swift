//
//  editView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//

import SwiftUI
import PhotosUI

// Extensión en View que permite leer el tamaño usando un modificador.
extension View {
    
    func debugStroke(_ color: Color = .red) -> some View {
        self.overlay(Rectangle().stroke(color, lineWidth: 1))
    }
}


struct PetRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
   var petManager = PetManager()
    
    // Form fields
    @State private var name: String = ""
    @State private var sex: PetSex = .male
    @State private var birthDate: Date = Date()
    @State private var species: PetSpecies = .dog
    @State private var breed: String = ""
    @State private var isSterilized: Bool = false
    
    // Image picker
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    // Validation
    @State private var showingValidationAlert: Bool = false
    @State private var errorMessage: String = ""
    
    // Date formatter for display
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Pet image selection
                            imageSelectionView
                            
                            // Form fields
                            formFieldsView
                        }
                        .padding()
                    }
                }
            }
            
            .alert("Error", isPresented: $showingValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
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
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        ZStack {
            // Title in the center
            Text("Registro de Mascotas")
                .font(.custom("Noteworthy", size: 28))
                .foregroundColor(Color.red.opacity(0.7))
                .frame(maxWidth: .infinity)
            
            // Back button aligned to the leading edge
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .padding(.leading, 20)
                
                Spacer() // Push the button to the left
            }
        }
        .padding(.vertical, 10)
        .background(Color.white)
    }
    
    // MARK: - Image Selection View
    
    private var imageSelectionView: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                if let selectedImage {
                    Image(uiImage: selectedImage)
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
                        .background(Circle().fill(Color.red.opacity(0.7)))
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
                TextField("Escribe aquí. Maximo 20 palabras", text: $name)
                    .padding()
                    .background(Color.white)
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
            
            // Birth date
            VStack(alignment: .leading, spacing: 5) {
                Text("Fecha de nacimiento")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Species
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
                        Text(species.rawValue.isEmpty ? "Seleccionar" : species.rawValue)
                            .foregroundColor(species.rawValue.isEmpty ? .gray : .white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            
            // Breed
            VStack(alignment: .leading, spacing: 5) {
                Text("Raza")
                    .font(.headline)
                    .foregroundColor(.secondary)
                TextField("Escribe aquí. Maximo 20 palabras", text: $breed)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Sterilized
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
    
    // MARK: - Navigation Bar View
    
    private var navigationBarView: some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                VStack(spacing: 5) {
                    Image(systemName: "pawprint")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Mascotas")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
            }
            
            Button(action: {}) {
                VStack(spacing: 5) {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Citas")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
            }
            
            Button(action: {}) {
                VStack(spacing: 5) {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Salud")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
    
    // MARK: - Helper Views
    
    private func radioButton(isSelected: Bool, label: String, symbol: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.red.opacity(0.7) : Color.clear)
                            .padding(4)
                    )
                    .frame(width: 24, height: 24)
                
                if let symbol = symbol {
                    Text(symbol)
                        .font(.title3)
                        .foregroundColor(.pink.opacity(0.8))
                } else {
                    Text(label)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    // MARK: - Save Action
    
    private func savePet() {
        // Validate required fields
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "El nombre es obligatorio"
            showingValidationAlert = true
            return
        }
        
        if breed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "La raza es obligatoria"
            showingValidationAlert = true
            return
        }
        
        // Create new pet
        var newPet = Pet(
            name: name,
            sex: sex,
            species: species,
            breed: breed,
            isSterilized: isSterilized
        )
        
        if let selectedImage = selectedImage {
            newPet.setImage(selectedImage)
        }
        
        // Add to manager
        petManager.addPet(newPet)
        
        // Dismiss the view
        dismiss()
    }
}

// MARK: - Preview

struct PetRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        PetRegistrationView()
    }
}
