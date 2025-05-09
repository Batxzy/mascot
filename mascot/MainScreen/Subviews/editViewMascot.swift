//
//  editMascotView.swift
//  mascot
//
//  PetCare: Integrantes: Salvador Hernández Cuevas ,Ibarra Bonilla (Tláloc)
//

import SwiftUI
import PhotosUI


extension View {
    func debugStroke(_ color: Color = .red) -> some View {
        self.overlay(Rectangle().stroke(color, lineWidth: 1))
    }
}


struct PetRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    var petManager: PetManager
    
    @State private var name: String = ""
    @State private var sex: PetSex = .male
    @State private var birthDate: Date = Date()
    @State private var species: PetSpecies = .dog
    @State private var breed: String = ""
    @State private var isSterilized: Bool = false
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    @State private var showingValidationAlert: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var showSaveButton = true
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        imageSelectionView
                        
                        formFieldsView
                        
                        Button(action: savePet) {
                            Text("Guardar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accent)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Error", isPresented: $showingValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
    
    
    // MARK: - Header View
    
    private var headerView: some View {
        ZStack {
            Text("Registro de Mascotas")
                .font(.custom("Noteworthy", size: 28))
                .foregroundColor(.accent)
                .frame(maxWidth: .infinity)
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .padding(.leading, 20)
                
                Spacer()
            }
        }
        .padding(.vertical, 15)
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
                TextField("Escribe aquí. Maximo 20 palabras", text: $name)
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
                    .background(.accent)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            
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
    
    // MARK: - Helper Views
    
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
    
    // MARK: - Save Action
    
    private func savePet() {
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
        
        petManager.pets.append(newPet)
        
        dismiss()
    }
}
// MARK: - Preview

#Preview {
    PetRegistrationView(petManager: PetManager())
}
