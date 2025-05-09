//
//  model.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//

import SwiftUI

// MARK: - Enums

/// Pet species options - limited to dog/cat with ability to expand
enum PetSpecies: String, CaseIterable, Identifiable, Codable {
    case dog = "Perro"
    case cat = "Gato"
    // Add more as needed
    
    var id: String { rawValue }
}

/// Pet sex options
enum PetSex: String, CaseIterable, Identifiable, Codable {
    case male = "M"
    case female = "F"
    
    var id: String { rawValue }
}

// MARK: - Pet Model

struct Pet: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
    var imageData: Data?
    var sex: PetSex
    var species: PetSpecies
    var breed: String
    var isSterilized: Bool
    
    var image: Image? {
        guard let imageData, let uiImage = UIImage(data: imageData) else { return nil }
        return Image(uiImage: uiImage)
    }
    
    mutating func setImage(_ uiImage: UIImage) {
        self.imageData = uiImage.jpegData(compressionQuality: 0.7)
    }
}

// MARK: - Pets Manager

@Observable class PetManager {
    var pets: [Pet] = []
    
    // MARK: - Funciones
    
    func addPet(_ pet: Pet) {
        pets.append(pet)
    }
    
    func removePet(at indexSet: IndexSet) {
        pets.remove(atOffsets: indexSet)
    }
    
    func removePet(withID id: UUID) {
        pets.removeAll { $0.id == id }
    }
    
    func updatePet(_ updatedPet: Pet) {
        guard let index = pets.firstIndex(where: { $0.id == updatedPet.id }) else { return }
        pets[index] = updatedPet
    }
    
    // MARK: - Computed properties
    
    var dogs: [Pet] {
        pets.filter { $0.species == .dog }
    }
    
    var cats: [Pet] {
        pets.filter { $0.species == .cat }
    }
    
    var sterilizedPets: [Pet] {
        pets.filter { $0.isSterilized }
    }
    
    var nonSterilizedPets: [Pet] {
        pets.filter { !$0.isSterilized }
    }
    
    func getPets(ofSpecies species: PetSpecies) -> [Pet] {
        pets.filter { $0.species == species }
    }
    
    func getPets(ofSex sex: PetSex) -> [Pet] {
        pets.filter { $0.sex == sex }
    }
}


enum Gender: String, CaseIterable, Identifiable {
    case female = "Femenino"
    case male = "Masculino"
    case nonBinary = "No binario"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .female: return "♀"
        case .male: return "♂"
        case .nonBinary: return "⚧"
        }
    }
}

// User model with public initializer
struct User: Identifiable {
    var id = UUID()
    var name: String
    var gender: Gender
    var birthDate: Date
    var phoneNumber: String
    var country: String
    private var uiImage: UIImage?
    
    // Explicitly public initializer
    init(name: String, gender: Gender, birthDate: Date, phoneNumber: String, country: String) {
        self.name = name
        self.gender = gender
        self.birthDate = birthDate
        self.phoneNumber = phoneNumber
        self.country = country
    }
    
    var image: Image? {
        if let uiImage = uiImage {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    mutating func setImage(_ image: UIImage) {
        self.uiImage = image
    }
}

// User Manager
@Observable class UserManager {
    var currentUser: User?
    
    func saveUser(_ user: User) {
        self.currentUser = user
    }
}
