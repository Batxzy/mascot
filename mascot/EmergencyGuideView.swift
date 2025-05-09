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
    let image: String
    let iconBackgroundColor: Color
    let detailedDescription: String
    
    init(title: String, previewText: String, image: String, iconBackgroundColor: Color, detailedDescription: String) {
        self.title = title
        self.previewText = previewText
        self.image = image
        self.iconBackgroundColor = iconBackgroundColor
        self.detailedDescription = detailedDescription
    }
    static let Data = [
        PetEmergency(
            title: "Envenenamiento",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese 30 a 60 seg...",
            image: "Skull",
            iconBackgroundColor: .accent,
            detailedDescription: "En caso de envenenamiento de su mascota:\n\n1. Identifique la sustancia si es posible\n2. Llame inmediatamente a su veterinario o a una línea de toxicología animal\n3. No induzca el vómito sin consulta profesional\n4. Guarde los recipientes, plantas o cualquier muestra del tóxico\n5. Monitoree los síntomas (vómitos, temblores, convulsiones, salivación excesiva)\n6. Mantenga a su mascota en un lugar tranquilo y cálido\n7. Prepare para transportarla al veterinario más cercano\n\nLos primeros 30 minutos son críticos para el tratamiento exitoso de un envenenamiento."
        ),
        PetEmergency(
            title: "Accidentes de tráfico",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota",
            image: "Danger",
            iconBackgroundColor: .accent,
            detailedDescription: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. \n\nTómese unos instantes para evaluar la situación de forma segura y verificar si hay peligros inmediatos, como tráfico adicional. Si es seguro acercarse, hágalo con cuidado y hable a su mascota con voz suave para tranquilizarla. \n\nEvite movimientos bruscos que puedan agravar posibles lesiones internas. Si sospecha de alguna lesión grave, como dificultad para respirar, sangrado abundante o incapacidad para moverse, no intente mover a su mascota a menos que sea absolutamente necesario para evitar un peligro mayor. \n\nEn ese caso, intente deslizarla suavemente sobre una tabla rígida o manta. Llame inmediatamente a su veterinario o a un hospital de animales de emergencia para recibir orientación sobre cómo proceder y para informarles de su llegada. Mantenga a su mascota abrigada y tranquila durante el traslado."
        ),
        PetEmergency(
            title: "Atragantamiento y asfixia",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese unos 30 a 60 segundos",
            image: "Choke",
            iconBackgroundColor: .accent,
            detailedDescription: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese unos 30 a 60 segundos para intentar determinar si su mascota puede respirar o si está haciendo algún esfuerzo por expulsar algo. \n\nObserve si tose con fuerza, lo cual indica que aún hay flujo de aire. Si no tose, se está asfixiando visiblemente, babea excesivamente o sus encías o lengua se tornan azuladas, actúe de inmediato. Intente abrir con cuidado su boca para ver si puede identificar y remover el objeto con los dedos o pinzas, teniendo precaución de no empujarlo más adentro. \n\nSi no lo ve o no puede alcanzarlo, realice la maniobra de Heimlich adaptada al tamaño de su mascota. \n\nPara perros grandes, coloque su puño justo debajo de la caja torácica y empuje hacia arriba y hacia adentro varias veces.\n\nPara perros pequeños y gatos, sosténgalos boca abajo y realice compresiones firmes en la parte superior del abdomen. Si no tiene éxito, busque atención veterinaria de emergencia de forma inmediata. Incluso si logra remover el objeto, es crucial una revisión veterinaria para descartar posibles daños internos."
        ),
        PetEmergency(
            title: "Quemaduras",
            previewText: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese unos 30 a 60 segundos para evaluar la causa y la gravedad de la quemadura.",
            image: "Fire",
            iconBackgroundColor: .accent,
            detailedDescription: "No entre en pánico. Una respuesta rápida es importante pero entrar en pánico puede interferir con el proceso de ayudar a su mascota. Tómese unos 30 a 60 segundos para evaluar la causa y la gravedad de la quemadura. \n\nSi es una quemadura química, intente enjuagar el área afectada con abundante agua corriente durante al menos 10 a 15 minutos para eliminar cualquier residuo químico, teniendo cuidado de que el agua no entre en los ojos o la boca de su mascota. \n\nPara quemaduras térmicas leves (enrojecimiento sin ampollas), aplique compresas frías o agua fría suavemente sobre el área afectada para aliviar el dolor. No aplique ungüentos, aceites ni otras sustancias caseras, ya que podrían empeorar la quemadura o dificultar la evaluación veterinaria. \n\nSi la quemadura es extensa, profunda, presenta ampollas, o afecta áreas sensibles como la cara, las patas o los genitales, busque atención veterinaria de emergencia de inmediato. \n\nMantenga a su mascota abrigada y evite que se lama o rasque la zona quemada mientras la transporta al veterinario. Es importante que un profesional evalúe la quemadura y determine el tratamiento adecuado para prevenir infecciones y promover la curación."
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
                .foregroundColor(.accent)
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
                    Image(emergency.image)
                        .resizable()
                        .scaledToFit()
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
                    .foregroundColor(.accent)
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
                            Image(emergency.image)
                                .resizable()
                                .scaledToFit()
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
