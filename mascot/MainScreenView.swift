//
//  MainScreenView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//
import SwiftUI

struct MainScreenView: View {
    // Using the modern @State for the PetManager
    @State private var petManager = PetManager()
    @State private var showAddPet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the side panels
                Color(red: 0.8, green: 0.4, blue: 0.4)
                    .ignoresSafeArea()
                
                // Main content container
                VStack(spacing: 0) {
                    // Content area
                    VStack {
                        // Logo and welcome area
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 1, green: 0.4, blue: 0.4))
                                    .frame(width: 140, height: 140)
                                
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .symbolRenderingMode(.hierarchical)
                            }
                            .padding(.bottom, 10)
                            
                            Text("¡Bienvenido!")
                                .font(.custom("Noteworthy-Bold", size: 36))
                                .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                        }
                        .padding(.vertical)
                        
                        // Pet cards in scroll view with improved styling
                        if petManager.pets.isEmpty {
                            ContentUnavailableView {
                                Label("No hay mascotas", systemImage: "pawprint")
                            } description: {
                                Text("Agrega una mascota usando el botón +")
                            } actions: {
                                Button("Agregar Mascota") {
                                    showAddPet = true
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(petManager.pets) { pet in
                                        PetCardView(pet: pet)
                                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                                    }
                                }
                                .padding(.horizontal)
                                .animation(.spring(duration: 0.5), value: petManager.pets)
                            }
                            .scrollIndicators(.hidden)
                            .scrollClipDisabled()
                        }
                        
                        Spacer()
                        
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        // Settings action
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray)
                            .symbolEffect(.pulse, options: .repeating.speed(0.5), isActive: false)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddPet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.white)
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 24))
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Add sample data if needed
                if petManager.pets.isEmpty {
                    petManager.addPet(Pet(
                        name: "Mazapán",
                        sex: .female,
                        species: .cat,
                        breed: "Mixto",
                        isSterilized: true
                    ))
                    
                    petManager.addPet(Pet(
                        name: "Boss",
                        sex: .male,
                        species: .dog,
                        breed: "PitBull Terrier Americano",
                        isSterilized: false
                    ))
                }
            }
            .sheet(isPresented: $showAddPet) {
                // Use your PetRegistrationView instead
                PetRegistrationView(petManager: petManager)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// Pet card component using the modern Pet model
struct PetCardView: View {
    let pet: Pet
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color(red: 1, green: 0.4, blue: 0.4))
                    .frame(width: 60, height: 60)
                
                // Use the pet's image if available, otherwise use SF Symbol
                if let petImage = pet.image {
                    petImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: pet.species == .cat ? "cat.fill" : "dog.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.hierarchical)
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
                        .foregroundColor(pet.sex == .male ? .blue : .pink)
                    Spacer()
                }
            }
            .font(.system(size: 14))
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(radius: isPressed ? 1 : 2)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(duration: 0.2), value: isPressed)
        .onTapGesture {
            isPressed = true
            // Haptic feedback
            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
            impactGenerator.impactOccurred()
            
            // Release tap effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
