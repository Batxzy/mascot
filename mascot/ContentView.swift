//
//  ContentView.swift
//  mascot
//
//  Created by Jose julian Lopez on 07/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var petManager = PetManager()
    @State private var userManager = UserManager()
    @State private var navigateToPetRegistration = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content area
                VStack(spacing: 0) {
                    // Content based on selected tab
                    TabContent(selectedTab: selectedTab,
                               petManager: petManager,
                               userManager: userManager)
                    
                    // Custom tab bar
                    CustomTabBar(
                        selectedTab: $selectedTab,
                        navigateToPetRegistration: $navigateToPetRegistration
                    )
                }
                .navigationDestination(isPresented: $navigateToPetRegistration) {
                    PetRegistrationView(petManager: petManager)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct TabContent: View {
    let selectedTab: Int
    let petManager: PetManager
    let userManager: UserManager
    
    var body: some View {
        switch selectedTab {
        case 0:
            MainScreenView(petManager: petManager, userManager: userManager)
        case 1:
            EmergencyGuideView()
        default:
            MainScreenView(petManager: petManager, userManager: userManager)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var navigateToPetRegistration: Bool
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            // Tab 1 - Home
            TabBarButton(
                isSelected: selectedTab == 0,
                icon: "house.fill",
                title: "Inicio",
                animation: animation
            ) {
                selectedTab = 0
            }
            
            // Middle Add Pet Button
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                
                Button(action: {
                    navigateToPetRegistration = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 37))
                        .foregroundStyle(.accent.opacity(0.9))
                }
            }
            .offset(y: -20)
            
            // Tab 3 - Emergency Guide
            TabBarButton(
                isSelected: selectedTab == 1,
                icon: "cross.case.fill",
                title: "Emergencias",
                animation: animation
            ) {
                selectedTab = 1
            }
        }
        .frame(height: 70)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: -5)
        )
    }
}

struct TabBarButton: View {
    let isSelected: Bool
    let icon: String
    let title: String
    let animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                
                
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .accent : .gray)
                    
                    Text(title)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(isSelected ? .accent : .gray)
                
                if isSelected {
                    Capsule()
                        .fill(Color.accent)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                        .padding(.horizontal, 15)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)
                        .padding(.horizontal, 15)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    ContentView()
}
