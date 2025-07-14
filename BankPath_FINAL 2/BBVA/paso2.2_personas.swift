import SwiftUI


extension Color {
    static let bbvaBlue = Color(red: 0.0, green: 0.19, blue: 0.53)
    static let bbvaLightBlue = Color(red: 0.0, green: 0.68, blue: 0.85)
    static let bbvaWhite = Color.white
    static let bbvaGray = Color.gray.opacity(0.15)
    static let bbvaGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let bbvaGradient = LinearGradient(
        gradient: Gradient(colors: [.bbvaBlue, .bbvaLightBlue, .bbvaBlue.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let bbvaGlow = RadialGradient(
        gradient: Gradient(colors: [.bbvaLightBlue.opacity(0.4), .clear]),
        center: .center,
        startRadius: 0,
        endRadius: 100
    )
}


struct ChecklistItem: Identifiable {
    let id = UUID()
    let text: String
    var isCompleted: Bool
}


struct BlueSectionView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedType: String? = nil
    @State private var pfaeItems = [
        ChecklistItem(text: "CURP (impresa) 📄", isCompleted: false),
        ChecklistItem(text: "Identificación oficial (INE, pasaporte, etc.) 🪪", isCompleted: false),
        ChecklistItem(text: "Comprobante de domicilio fiscal (no mayor a 3 meses) 🏠", isCompleted: false),
        ChecklistItem(text: "Acuse de preinscripción en el RFC (si iniciaste en línea) 📑", isCompleted: false),
        ChecklistItem(text: "Acta de nacimiento (si el CURP no está certificado) 📜", isCompleted: false),
        ChecklistItem(text: "Extranjeros: FMM, carta de naturalización o documento migratorio 🌐", isCompleted: false)
    ]
    @State private var moralItems = [
        ChecklistItem(text: "Acta Constitutiva (notariada) 📜", isCompleted: false),
        ChecklistItem(text: "Poder notarial del representante legal ⚖️", isCompleted: false),
        ChecklistItem(text: "Identificación oficial del representante 🪪", isCompleted: false),
        ChecklistItem(text: "Comprobante de domicilio fiscal 🏠", isCompleted: false),
        ChecklistItem(text: "CURP del representante 📄", isCompleted: false),
        ChecklistItem(text: "Extranjeros: FMM, carta de naturalización o documento migratorio 🌐", isCompleted: false)
    ]
    private let tip = "¡Habla con un contador! La S.A.S. es fácil y sin costos de notario 💡"

    var body: some View {
        ZStack {
            Color.bbvaWhite.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 40) {
              
                    Text("Requisitos y documentos necesarios")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.bbvaGradient)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .shadow(color: .bbvaBlue.opacity(0.2), radius: 5, x: 0, y: 2)
                    
               
                    OptionCardView(
                        title: "Persona Física 👤",
                        items: $pfaeItems,
                        tip: tip,
                        isSelected: selectedType == "PFAE",
                        isExpanded: selectedType == "PFAE"
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedType = selectedType == "PFAE" ? nil : "PFAE"
                        }
                    }
                    
                    OptionCardView(
                        title: "Persona Moral 🏢",
                        items: $moralItems,
                        tip: tip,
                        isSelected: selectedType == "Persona Moral",
                        isExpanded: selectedType == "Persona Moral"
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedType = selectedType == "Persona Moral" ? nil : "Persona Moral"
                        }
                    }
                    
        
                    Text("¡Prepara tus documentos y avanza con BBVA! 🚀")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.bbvaLightBlue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .overlay(
                            Color.bbvaGlow
                                .frame(height: 8)
                                .offset(y: 20)
                        )
                    
                 
                    Button(action: {
                        navigationPath.append("chrisBBVA")

                    }) {
                        Text("Continuar")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.bbvaWhite)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.bbvaLightBlue)
                            .cornerRadius(12)
                            
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("")
    }
}


struct OptionCardView: View {
    let title: String
    @Binding var items: [ChecklistItem]
    let tip: String
    let isSelected: Bool
    let isExpanded: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
      
            Button(action: {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    scale = 0.95
                    glowOpacity = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        scale = 1.0
                        glowOpacity = isSelected ? 1.0 : 0.0
                    }
                }
            }) {
                Text(title)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.bbvaWhite)
                    .padding(.vertical, 40)
                    .frame(width: 255)
                    .frame(height: 180)
                    .background(
                        ZStack {
                            isSelected ? Color.bbvaGradient : LinearGradient(
                                gradient: Gradient(colors: [.bbvaBlue, .bbvaBlue.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            Color.bbvaGlow.opacity(glowOpacity)
                        }
                    )
                    .cornerRadius(20)
                    .shadow(color: .bbvaBlue.opacity(isSelected ? 0.5 : 0.3), radius: 10, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.bbvaWhite.opacity(isSelected ? 0.8 : 0.0), lineWidth: 3)
                    )
            }
            .scaleEffect(scale)
            .padding(.horizontal, 15)
            
 
            if isExpanded {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach($items) { $item in
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    item.isCompleted.toggle()
                                }
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.bbvaGreen)
                                    .font(.system(size: 28))
                                    .scaleEffect(item.isCompleted ? 1.1 : 1.0)
                                    .shadow(color: .bbvaGreen.opacity(item.isCompleted ? 0.4 : 0.0), radius: 4)
                            }
                            Text(item.text)
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundColor(.bbvaBlue)
                        }
                    }
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.bbvaGreen)
                            .font(.system(size: 28))
                            .shadow(color: .bbvaGreen.opacity(0.4), radius: 4)
                        Text(tip)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.bbvaBlue)
                    }
                }
                .padding(25)
                .background(
                    Color.bbvaWhite
                        .cornerRadius(15)
                        .shadow(color: .bbvaGray.opacity(0.3), radius: 8, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.bbvaLightBlue.opacity(0.5), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isExpanded)
    }
}


struct BlueSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BlueSectionView(navigationPath: .constant(NavigationPath()))
    }
}
