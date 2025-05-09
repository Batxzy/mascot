//
//  MainScreenView.swift
//  mascot
//
//  PetCare: Integrantes: Salvador Hernández Cuevas ,Ibarra Bonilla (Tláloc)
//
import SwiftUI
import PhotosUI

struct MainScreenView: View {
    var petManager: PetManager
    var userManager : UserManager
    @State private var showAddPetSheet = false
    @State private var showSettingsOverlay = false
    @State private var navigationPath = NavigationPath()
//MARK: - Body
    var body: some View {
           NavigationStack(path: $navigationPath) {
               ZStack {
                   mainUILayer
                       .zIndex(0)

                   if showSettingsOverlay {
                       settingsOverlayLayer
                           .transition(.move(edge: .leading))
                           .zIndex(10)
                   }
               }
               .sheet(isPresented: $showAddPetSheet) {
                   PetRegistrationView(petManager: petManager)
                       .presentationDetents([.large])
                       .presentationDragIndicator(.visible)
               }
               .navigationDestination(for: String.self) { destination in
                   navigationDestinationView(for: destination)
               }
               .navigationDestination(for: Pet.self) { petToEdit in
                   EditPetView(petManager: petManager, petToEdit: petToEdit)
               }
           }
       }

       private var mainUILayer: some View {
           VStack(spacing: 0) {
               topBarView
               contentAreaView
           }
       }

       private var topBarView: some View {
           ZStack {
               Image("Logo")
                   .resizable()
                   .scaledToFit()
                   .frame(height: 52)
               HStack {
                   Button(action: {
                       withAnimation(.spring(.smooth)) {
                           showSettingsOverlay.toggle()
                       }
                   }) {
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
           }
       }

//MARK: - views
    private var contentAreaView: some View {
       VStack(spacing: 0) {
           VStack(spacing: 8) {
               Image("Simbolodeentrada")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 200, height: 200)
               
               if let user = userManager.currentUser {
                   Text("¡Bienvenido, \(user.name)!")
                       .font(.custom("Noteworthy-Bold", size: 32))
                       .foregroundColor(.accent)
               } else {
                   Text("¡Bienvenido!")
                       .font(.custom("Noteworthy-Bold", size: 32))
                       .foregroundColor(.accent)
               }
           }
           .padding(.top)

           if petManager.pets.isEmpty {
               ContentUnavailableView {
                   Label("No hay mascotas", systemImage: "pawprint")
               } description: {
                   Text("Agrega una mascota usando el botón + en la esquina superior.")
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           } else {
               ScrollView {
                   LazyVStack(spacing: 16) {
                       ForEach(petManager.pets) { pet in
                           PetCardView(
                               pet: pet,
                               onDeleteAction: {
                                   petManager.removePet(withID: pet.id)
                               },
                               onEditAction: {
                                   navigationPath.append(pet)
                               }
                           )
                           .transition(.opacity.combined(with: .move(edge: .bottom)))
                       }
                   }
                   .padding(24)
                   .animation(.spring(.smooth), value: petManager.pets)
               }
               .scrollIndicators(.hidden)
           }
           Spacer()
       }
       .background(Color.white)
    }

    private var settingsOverlayLayer: some View {
       SettingsOverlayView(
           isShowing: $showSettingsOverlay,
           navigationPath: $navigationPath,
           userManager: userManager
       )
    }

    @ViewBuilder
    private func navigationDestinationView(for destination: String) -> some View {
       switch destination {
       case "profile":
           EditProfileView(userManager: userManager)
       case "notifications":
           NotificationsView()
       default:
           Text("Destino desconocido: \(destination)")
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


#Preview {
    MainScreenView(petManager: PetManager(), userManager: UserManager())
}
