//
//  PetCardView.swift
//  mascot
//
//  PetCare: Integrantes: Salvador Hernández Cuevas ,Ibarra Bonilla (Tláloc)
//

import SwiftUI
    
struct PetCardView: View {
    let pet: Pet
    
    @State private var showingDeleteConfirmationAlert = false
    var onDeleteAction: () -> Void
    var onEditAction: () -> Void
    
    var body: some View {
        Menu {
            Button {
                onEditAction()
            } label: {
                Label("Editar", systemImage: "pencil.circle.fill")
            }
            
            Button(role: .destructive) {
                showingDeleteConfirmationAlert = true
            } label: {
                Label("Eliminar", systemImage: "trash.circle.fill")
            }
        } label: {
            cardContentView
        }
        .confirmationDialog(
            "Confirmar Eliminación",
            isPresented: $showingDeleteConfirmationAlert,
            titleVisibility: .visible
        ) {
            Button("Eliminar \(pet.name)", role: .destructive) {
                onDeleteAction()
            }
            
            Button("Cancelar", role: .cancel) {
            }
        } message: {
            Text("¿Estás seguro de que quieres eliminar a \(pet.name)? Esta acción no se puede deshacer.")
        }
    }
    
    private var cardContentView: some View {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(.accent)
                        .frame(width: 60, height: 60)
                    
                    if let petImage = pet.image {
                        petImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Image(
                            pet.species == .cat ? "Gato" : "perro")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Nombre: ").bold() + Text(pet.name)
                        Spacer()
                    }
                    HStack {
                        Text("Mascota: ").bold() + Text(pet.species.rawValue)
                        Spacer()
                    }
                    HStack {
                        Text("Raza: ").bold() + Text(pet.breed)
                        Spacer()
                    }
                    HStack {
                        Text("Género: ").bold()
                        Text(pet.sex == .male ? "♂" : "♀")
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                .font(.system(size: 14))
                .foregroundColor(.primary)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 2)
            }
            .contentShape(Rectangle())
        }
    }

