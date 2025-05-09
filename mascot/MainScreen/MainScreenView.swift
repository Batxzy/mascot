//
//  MainScreenView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//
import SwiftUI
import PhotosUI

struct MainScreenView: View {
    var petManager: PetManager
    var userManager : UserManager
    @State private var showAddPet = false
    @State private var showSettingsOverlay = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
            NavigationStack(path: $navigationPath) {
                ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                withAnimation(.spring(.smooth)) {
                                    showSettingsOverlay.toggle()
                                }
                            }
                            ){
                                Image(systemName: "gearshape.fill")
                                    .foregroundStyle(.gray.opacity(0.7))
                                    .font(.system(size: 35))
                            }
                            .padding(.leading, 12)

                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                        .zIndex(2)

                        VStack(spacing: 0) {
                            
                            VStack(spacing: 8) {
                                Image("Simbolodeentrada")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 235, height: 235)

                                if let user = userManager.currentUser {
                                    Text("¡Bienvenido, \(user.name)!")
                                        .font(.custom("Noteworthy-Bold", size: 36))
                                        .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                                } else {
                                    Text("¡Bienvenido!")
                                        .font(.custom("Noteworthy-Bold", size: 36))
                                        .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                                }
                            }

                            if petManager.pets.isEmpty {
                                ContentUnavailableView {
                                    Label("No hay mascotas", systemImage: "pawprint")
                                } description: {
                                    Text("Agrega una mascota usando el botón +")
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

                    if showSettingsOverlay {
                        SettingsOverlayView(
                            isShowing: $showSettingsOverlay,
                            navigationPath: $navigationPath,
                            userManager: userManager
                        )
                        .transition(.move(edge: .leading))
                        .zIndex(10)
                    }
                }
                .sheet(isPresented: $showAddPet) {
                    PetRegistrationView(petManager: petManager)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "profile":
                        EditProfileView(userManager: userManager)
                    case "notifications":
                        NotificationsView()
                    default:
                        Text("Destino desconocido")
                    }
                }
            }
        }
    }

struct RadioButtonGroup: View {
    let options: [String]
    @State var selectedIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(options.indices, id: \.self) { index in
                Button {
                    selectedIndex = index
                } label: {
                    HStack {
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                            .background(
                                Circle()
                                    .fill(selectedIndex == index ? Color.accent : Color.clear)
                                    .padding(4)
                            )
                            .frame(width: 24, height: 24)
                        
                        Text(options[index])
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
            }
        }
    }
}

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
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image
                    }
                }
            }
        }
    }
}

struct PetCardView: View {
    let pet: Pet
    @State private var isPressedForTapEffect = false
    @State private var showActionButtons = false
    @State private var showingDeleteConfirmationAlert = false

    var onDeleteAction: () -> Void = { print("Default delete action triggered") }
    var onEditAction: () -> Void = { print("Default edit action triggered") }
    
    var body: some View {
        ZStack {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color(red: 1, green: 0.4, blue: 0.4))
                        .frame(width: 60, height: 60)
                    
                    if let petImage = pet.image {                         petImage
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
                    .shadow(radius: isPressedForTapEffect ? 1 : 2)
            }
            .scaleEffect(isPressedForTapEffect ? 0.98 : 1.0)
            .allowsHitTesting(!showActionButtons)
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                withAnimation(.spring(duration: 0.2)) {
                    isPressedForTapEffect = pressing
                }
            }) {
                withAnimation(.spring()) {
                    showActionButtons = true
                }
            }

            // Action Buttons Overlay
            if showActionButtons {
                Color.black.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showActionButtons = false
                        }
                    }
                
                
                HStack(spacing: 25) {
                    Button {
                        onEditAction()
                        withAnimation(.spring()) {
                            showActionButtons = false
                        }
                    } label: {
                        VStack {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                            Text("Edit")
                                .font(.caption)
                        }
                        .padding(10)
                        .frame(width: 70, height: 70)
                        .background(.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                    }
                    
                    Button {
                        showingDeleteConfirmationAlert = true
                    } label: {
                        VStack {
                            Image(systemName: "trash.circle.fill")
                                .font(.title)
                            Text("Delete")
                                .font(.caption)
                        }
                        .padding(10)
                        .frame(width: 70, height: 70)
                        .background(.red.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .alert("Confirm Deletion", isPresented: $showingDeleteConfirmationAlert) {
            Button("Delete \(pet.name)", role: .destructive) {
                onDeleteAction()
                withAnimation(.spring()) {
                    showActionButtons = false
                }
            }
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    showActionButtons = false
                }
            }
        } message: {
            Text("Are you sure you want to delete \(pet.name)? This action cannot be undone.")
        }
    }
}

#Preview {
    MainScreenView(petManager: PetManager(), userManager: UserManager())
}
