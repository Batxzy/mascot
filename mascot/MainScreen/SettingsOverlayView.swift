//
//  SettingsOverlayView.swift
//  mascot
//
//  Created by Jose julian Lopez on 08/05/25.
//

import SwiftUI

struct SettingsOverlayView: View {
    @Binding var isShowing: Bool
    @Binding var navigationPath: NavigationPath
    var userManager: UserManager
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    private var userImage: UIImage? {
        if let selectedImage = selectedImage {
            return selectedImage
        } else if let currentUser = userManager.currentUser, let userImage = currentUser.image {
            let uiImage = userImage.asUIImage()
            return uiImage
        }
        return nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.smooth()) {
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
                                
                                if let userImage = userImage {
                                    Image(uiImage: userImage)
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
                    .background(.accent)
                    
                    VStack(spacing: 0) {
                        if let user = userManager.currentUser {
                            Text(user.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.vertical, 12)
                        }
                        
                        Button(action: {
                            withAnimation {
                                isShowing = false
                                navigationPath.append("profile")
                            }
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "person.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                                
                                Text("Perfil")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        Button(action: {
                            withAnimation {
                                isShowing = false
                                navigationPath.append("notifications")
                            }
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "bell.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                                
                                Text("Notificaciones")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
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
            .onChange(of: selectedImage) { _, newImage in
                if let newImage = newImage, var user = userManager.currentUser {
                    user.setImage(newImage)
                    userManager.saveUser(user)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .transition(.asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

extension View {
    @MainActor
    func asUIImage(size: CGSize) -> UIImage {
        let renderer = ImageRenderer(content: self)
        renderer.proposedSize = .init(size)
        return renderer.uiImage ?? UIImage()
    }
}

extension Image {
    @MainActor func asUIImage(width: CGFloat = 300, height: CGFloat = 300) -> UIImage {
        return self
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .asUIImage(size: CGSize(width: width, height: height))
    }
}
