//
//  EmergencyGuideView.swift
//  mascot
//
//  Created by Jose julian Lopez on 08/05/25.
//

import SwiftUI

import SwiftUI

struct PetEmergency: Identifiable {
    let id = UUID()
    let title: String
    let previewText: String
    let icon: String
    let iconBackgroundColor: Color
    let detailedDescription: String
    
    init(title: String, previewText: String, icon: String, iconBackgroundColor: Color, detailedDescription: String) {
        self.title = title
        self.previewText = previewText
        self.icon = icon
        self.iconBackgroundColor = iconBackgroundColor
        self.detailedDescription = detailedDescription
    }
    static let Data = [
        PetEmergency(
            title: "Envenenamiento",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese 30 a 60 seg...",
            icon: "skull.crossbones.fill",
            iconBackgroundColor: Color.red.opacity(0.9),
            detailedDescription: "En caso de envenenamiento de su mascota:\n\n1. Identifique la sustancia si es posible\n2. Llame inmediatamente a su veterinario o a una línea de toxicología animal\n3. No induzca el vómito sin consulta profesional\n4. Guarde los recipientes, plantas o cualquier muestra del tóxico\n5. Monitoree los síntomas (vómitos, temblores, convulsiones, salivación excesiva)\n6. Mantenga a su mascota en un lugar tranquilo y cálido\n7. Prepare para transportarla al veterinario más cercano\n\nLos primeros 30 minutos son críticos para el tratamiento exitoso de un envenenamiento."
        ),
        PetEmergency(
            title: "Accidentes de tráfico",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese...",
            icon: "exclamationmark.triangle.fill",
            iconBackgroundColor: Color.red.opacity(0.9),
            detailedDescription: "Si su mascota ha sufrido una caída o accidente de tráfico:\n\n1. No mueva al animal si sospecha lesiones en columna o cuello\n2. Aborde con cuidado, incluso una mascota dócil puede morder cuando está herida\n3. Si es necesario, improvise una camilla con una manta o superficie rígida\n4. Controle cualquier sangrado aplicando presión con un paño limpio\n5. Mantenga al animal caliente para prevenir shock\n6. Acuda inmediatamente a un veterinario de urgencia\n\nRecuerde que las lesiones internas no siempre son evidentes, por lo que una evaluación profesional es esencial incluso si su mascota parece estar bien."
        ),
        PetEmergency(
            title: "Atragantamiento y asfixia",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese 30 a 60 seg...",
            icon: "dog.fill",
            iconBackgroundColor: Color.red.opacity(0.9),
            detailedDescription: "Si su mascota está atragantada:\n\n1. Abra la boca con cuidado e intente visualizar el objeto extraño\n2. Si puede verlo, intente retirarlo suavemente con pinzas o sus dedos\n3. Si no puede verlo o alcanzarlo, no insista para evitar empujarlo más adentro\n4. Para perros medianos o grandes, puede intentar la maniobra de Heimlich modificada\n5. Para animales pequeños, sostenga al animal con la cabeza hacia abajo y dé golpes firmes entre los omóplatos\n6. Si el animal pierde el conocimiento, inicie RCP animal y busque ayuda veterinaria inmediata\n\nTenga en cuenta que el tiempo es esencial - si los primeros intentos no funcionan, diríjase inmediatamente a un centro veterinario."
        ),
        PetEmergency(
            title: "Quemaduras",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese 30 a 60 seg...",
            icon: "flame.fill",
            iconBackgroundColor: Color.red.opacity(0.9),
            detailedDescription: "Para tratar quemaduras en su mascota:\n\n1. Enfríe la zona quemada con agua fría corriente durante 10-15 minutos\n2. No aplique hielo directamente sobre la piel\n3. No use ungüentos, mantequilla, pasta de dientes u otros remedios caseros\n4. Cubra la quemadura con un paño limpio, no adhesivo\n5. Para quemaduras químicas, enjuague abundantemente la zona y use guantes si manipula al animal\n6. Evite que el animal lama o rasque la zona afectada\n7. Todas las quemaduras requieren atención veterinaria, especialmente las que afectan áreas extensas o son profundas\n\nLas quemaduras pueden ser más graves de lo que parecen inicialmente y pueden infectarse fácilmente, por lo que la evaluación profesional es crucial."
        )
    ]
}

struct EmergencyGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmergency: PetEmergency?
    
    let emergencies = PetEmergency.Data
    
    var body: some View {
        VStack(spacing: 0) {

            headerView
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(emergencies) { emergency in
                        EmergencyCardView(emergency: emergency)
                            .onTapGesture {
                                selectedEmergency = emergency
                            }
                    }
                }
                .padding(24)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .fullScreenCover(item: $selectedEmergency) { emergency in
            EmergencyDetailView(emergency: emergency)
        }
    }
    
    private var headerView: some View {
        ZStack {
            Text("Guía de emergencia")
                .font(.custom("Noteworthy-Bold", size: 32))
                .foregroundColor(Color.red.opacity(0.7))
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .background(Color.white)
    }
}

struct EmergencyCardView: View {
    let emergency: PetEmergency
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(emergency.iconBackgroundColor)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: emergency.icon)
                        .resizable()
                        .scaledToFit()
                        .padding(16)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(emergency.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(emergency.previewText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
        )
    }
}

struct EmergencyDetailView: View {
    let emergency: PetEmergency
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(emergency.title)
                    .font(.title2.bold())
                    .foregroundColor(Color.red.opacity(0.8))
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Circle().fill(Color.gray.opacity(0.15)))
                    }
                    
                    Spacer()
                }
                .padding(.leading)
            }
            .padding(.vertical)
            
            ScrollView {
                VStack(spacing: 24) {
                    Circle()
                        .fill(emergency.iconBackgroundColor)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: emergency.icon)
                                .resizable()
                                .scaledToFit()
                                .padding(30)
                                .foregroundColor(.white)
                        )
                        .padding(.top)
                    
                    Text(emergency.detailedDescription)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                .padding(16)
            }
        }
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    EmergencyGuideView()
}
