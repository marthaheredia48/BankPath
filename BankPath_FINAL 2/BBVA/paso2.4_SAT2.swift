import SwiftUI
import UIKit


struct GuidedSATAppointmentView: View {
    @State private var currentStep: Int = 0
    @State private var completedSteps: Set<Int> = []
    @State private var continueButtonScale: CGFloat = 1.0
    @State private var continueButtonGlowOpacity: Double = 0.0
    @Binding var navigationPath: NavigationPath


    
    private let steps = [
        TutorialStep(
            title: "Haces tu negocio legal y confiable 🏢",
            description: "Con el RFC, tu empresa queda registrada oficialmente, lo que da confianza a clientes y proveedores. Es como el CURP de tu negocio.",
            emoji: "💻"
        ),
        TutorialStep(
            title: "Puedes dar facturas y atraer más clientes 🌐",
            description: "Puedes emitir facturas electrónicas, algo que piden muchas empresas grandes. Esto te abre puertas a más ventas.",
            emoji: "💡"
        ),
        TutorialStep(
            title: "Accedes a apoyos o créditos 📞",
            description: "Con RFC, puedes pedir créditos para Pymes o entrar a programas del gobierno, como capacitaciones o subsidios, sin necesidad de banco.",
            emoji: "☎️"
        ),
        TutorialStep(
            title: "Evitas multas y problemas 🗺️",
            description: "Estar registrado te ayuda a cumplir con el SAT y evita que te cobren multas o impuestos atrasados por no estar en regla.",
            emoji: "📍"
        ),
        TutorialStep(
            title: "Pagas impuestos más fáciles 💡",
            description: "Puedes elegir un régimen como el RESICO, que es simple y tiene impuestos bajos, perfecto para Pymes que apenas comienzan. Así, cumples con el SAT sin complicarte la vida.",
            emoji: "✅"
        )
    ]
    
    private var progress: Float {
        Float(completedSteps.count) / Float(steps.count)
    }
    
    private var isTutorialComplete: Bool {
        completedSteps.count == steps.count
    }
    
    var body: some View {
        ZStack {
            Color.bbvaWhite.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 30) {
             
                    Text("Beneficios de sacar un RFC para una Pyme (pequeña o mediana empresa)🌟")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.bbvaGradient)
                        .padding(.top, 40)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .shadow(color: .bbvaBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                        .fixedSize(horizontal: false, vertical: true)
                    
         
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .bbvaGreen))
                        .background(Color.bbvaGray)
                        .padding(.horizontal, 20)
                        .frame(height: 10)
                        .cornerRadius(5)
                    
               
                    ZStack {
                        ForEach(steps.indices, id: \.self) { index in
                            SATAppointmentStepView(
                                step: steps[index],
                                isActive: index == currentStep,
                                isCompleted: completedSteps.contains(index)
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    completedSteps.insert(index)
                                    print("Completed step \(index + 1)/\(steps.count)")
                                    if currentStep < steps.count - 1 {
                                        currentStep += 1
                                    }
                                }
                            }
                            .offset(y: index == currentStep ? 0 : 100)
                            .opacity(index == currentStep ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.4), value: currentStep)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                  
             
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            continueButtonScale = 0.90
                            continueButtonGlowOpacity = 1.0
                            print("continuar")
                            navigationPath.append("FINAL")

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                continueButtonScale = 1.0
                                continueButtonGlowOpacity = 0.0
                            }
                        }
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.prepare()
                        impact.impactOccurred()
                    }) {
                        Text("Continuar")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.bbvaWhite)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isTutorialComplete ? Color.bbvaLightBlue : Color.bbvaGray)
                            .cornerRadius(12)
                            .shadow(color: .bbvaBlue.opacity(isTutorialComplete ? 0.5 : 0.3), radius: 6, x: 0, y: 4)
                            .overlay(
                                Color.bbvaGlow
                                    .frame(height: 6)
                                    .offset(y: 6)
                                    .opacity(isTutorialComplete ? continueButtonGlowOpacity : 0.0)
                            )
                    }
                    .scaleEffect(continueButtonScale)
                    .buttonStyle(.plain)
                    .disabled(!isTutorialComplete)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}


struct SATAppointmentStepView: View {
    let step: TutorialStep
    let isActive: Bool
    let isCompleted: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            Text(step.emoji)
                .font(.system(size: 60))
                .padding(.top, 20)
            
            Text(step.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.bbvaBlue)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(step.description)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.bbvaBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    scale = 0.95
                    glowOpacity = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        scale = 1.0
                        glowOpacity = 0.0
                    }
                }
            }) {
                Text(isCompleted ? "✓ Completado" : "Entendido")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.bbvaWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCompleted ? Color.bbvaGreen : Color.bbvaLightBlue)
                    .cornerRadius(10)
                    .shadow(color: .bbvaBlue.opacity(0.3), radius: 6, x: 0, y: 4)
                    .overlay(
                        Color.bbvaGlow.opacity(glowOpacity)
                            .cornerRadius(10)
                    )
            }
            .scaleEffect(scale)
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .disabled(isCompleted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            Color.bbvaWhite
                .cornerRadius(15)
                .shadow(color: .bbvaGray.opacity(0.3), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.bbvaLightBlue.opacity(0.4), lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 15)
    }
}


struct GuidedSATAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedSATAppointmentView(navigationPath: .constant(NavigationPath()))
    }
}
