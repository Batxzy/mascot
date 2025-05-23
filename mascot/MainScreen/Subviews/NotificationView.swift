//
//  NotificationView.swift
//  mascot
//
//  PetCare: Integrantes: Salvador Hernández Cuevas ,Ibarra Bonilla (Tláloc)
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notificationEnabled") private var notificationsEnabled = true
    @Namespace private var animation
    
//MARK: - body
    var body: some View {
        VStack(spacing: 0) {

            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    Circle()
                        .fill(notificationsEnabled ? Color.accent : .gray)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "bell.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .padding(30)
                        )
                        .padding(.top, 20)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: notificationsEnabled)
                        .scaleEffect(notificationsEnabled ? 1.05 : 1.0)
                        .animation(.spring(response: 0.4), value: notificationsEnabled)
                    
                   
                    HStack {
                        Text(notificationsEnabled ?
                             "Todas las notificaciones están activadas" :
                             "Todas las notificaciones están desactivadas")
                            .foregroundStyle(notificationsEnabled ? .white : .gray)
                            .font(.system(size: 16, weight: .medium))
                            .animation(.easeInOut(duration: 0.2), value: notificationsEnabled)
                        
                        Spacer()
                        
                        Toggle("", isOn: $notificationsEnabled.animation(.spring(response: 0.3, dampingFraction: 0.7)))
                            .labelsHidden()
                            .tint(notificationsEnabled ? Color.accent : .gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(notificationsEnabled ? Color.accent.opacity(0.8) : Color.gray.opacity(0.15))
                            .animation(.spring(response: 0.3), value: notificationsEnabled)
                    )
                    .padding(.horizontal)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.gray)
                        
                        ZStack(alignment: .leading) {
                            if notificationsEnabled {
                                Text("Como lo solicitaste todas las notificaciones de la aplicación PetCare están activadas.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .transition(.opacity)
                                    .id("enabled")
                            } else {
                                Text("Como lo solicitaste, todas las notificaciones de la aplicación PetCare están desactivadas.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .transition(.opacity)
                                    .id("disabled")
                            }
                        }
                        .animation(.smooth(), value: notificationsEnabled)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }

//MARK: - views
    private var headerView: some View {
        ZStack {
            Text("Notificaciones")
                .font(.custom("Noteworthy-Bold", size: 28))
                .foregroundColor(.accent)
                .frame(maxWidth: .infinity)
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .padding(12)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .padding(.leading, 16)
                
                Spacer()
            }
        }
        .padding(.vertical, 15)
        .background(Color.white)
    }
}


#Preview {
    NavigationStack {
        NotificationsView()
    }
}
