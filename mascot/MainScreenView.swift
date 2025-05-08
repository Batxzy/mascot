//
//  MainScreenView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//
import SwiftUI
import PhotosUI

struct MainScreenView: View {
    @State private var petManager = PetManager()
    @State private var showAddPet = false
    @State private var showSettingsOverlay = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // Custom top bar
                    HStack {
                        Button(action: {
                            // Always wrap in withAnimation to ensure consistent behavior
                            withAnimation(.spring(.smooth)) {
                                showSettingsOverlay.toggle()
                            }
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.gray.opacity(0.7))
                                .font(.system(size: 35))
                                .symbolEffect(.pulse, options: .repeating.speed(0.5), isActive: showSettingsOverlay)
                        }
                        .padding(.leading, 12)

                        Spacer()

                        Button(action: {
                            showAddPet = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 37))
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .zIndex(2)

                    // Main content container
                    VStack(spacing: 0) {
                        // Logo and welcome area
                        VStack(spacing: 8) {
                            Image("Simbolodeentrada")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 235, height: 235)

                            Text("¡Bienvenido!")
                                .font(.custom("Noteworthy-Bold", size: 36))
                                .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                        }

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
                                .padding(15)
                                .animation(.spring(.smooth), value: petManager.pets)
                            }
                            .scrollIndicators(.hidden)
                        }

                        Spacer()
                    }
                    .background(Color.white)
                }
                .zIndex(0)

                // Settings overlay with consistent animation
                if showSettingsOverlay {
                    SettingsOverlayView(isShowing: $showSettingsOverlay)
                        .transition(.move(edge: .leading))
                        .zIndex(10)
                }
            }
            .sheet(isPresented: $showAddPet) {
                PetRegistrationView(petManager: petManager)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
struct SettingsOverlayView: View {
    @Binding var isShowing: Bool
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Dimmed background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            isShowing = false
                        }
                    }
                
                VStack(spacing: 0) {
                    VStack {
                        ZStack {
                            Group {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 110, height: 110)
                                
                                if let selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                }
                            }
                            .background(.white)
                            .clipShape(Circle())

                            // Camera button with tap gesture to open image picker
                            Button {
                                showImagePicker = true
                            } label: {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.gray)
                                    )
                                    .shadow(radius: 1)
                            }
                            .offset(x: 38, y: 38)
                        }
                        .padding(.top, 90)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 1, green: 0.4, blue: 0.4))
                    
                    VStack(spacing: 0) {
                        Button(action: {
                            // Handle profile action
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "person.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                                
                                Text("Perfil")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        Button(action: {
                            // Handle notifications action
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "bell.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                                
                                Text("Notificaciones")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .frame(maxHeight: .infinity)
                }
                .frame(width: min(geometry.size.width * 0.70, 300), height: geometry.size.height)
                .background(Color.white)
                .edgesIgnoringSafeArea(.vertical)
                .shadow(radius: 15)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .transition(.asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

// Modern Image Picker using PhotosUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss picker
            picker.dismiss(animated: true)
            
            // Exit if no selection
            guard let result = results.first else { return }
            
            // Load selected image
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage, error == nil else { return }
                    
                    // Update on main thread
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image
                    }
                }
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
