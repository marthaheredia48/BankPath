import SwiftUI


struct TutorialStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
}


struct GuidedRegistrationTutorialView: View {
    @State private var currentStep: Int = 0
    @State private var completedSteps: Set<Int> = []
    @Binding var navigationPath: NavigationPath
    
    private let steps = [
        TutorialStep(
            title: "¿Qué es Persona Física? 👤",
            description: "Es para ti si tienes un negocio pequeño, como una tienda o un puesto. Tú manejas todo, incluyendo los impuestos y papeles.",
            emoji: "🏠"
        ),
        TutorialStep(
            title: "Más sobre Persona Física 📝",
            description: "Funciona si vendes cosas, haces productos o trabajas en el campo, como agricultura. ¡Es simple para empezar!",
            emoji: "🌾"
        ),
        TutorialStep(
            title: "¿Qué es Persona Moral? 🏢",
            description: "Es para negocios con socios o que quieren crecer mucho, como una empresa. Necesitas un documento oficial.",
            emoji: "🤝"
        ),
        TutorialStep(
            title: "Más sobre Persona Moral 💸",
            description: "Por ejemplo, una S.A.S. es buena si tu negocio gana menos de $5 millones al año. Es para empresas formales.",
            emoji: "📜"
        ),
        TutorialStep(
            title: "Consejo importante 💡",
            description: "Habla con un contador. ¡Una S.A.S. es rápida y no pagas notario, ideal para formalizarte fácil!",
            emoji: "💡"
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
            
            VStack(spacing: 30) {
                Text("Aprende sobre tu registro 🌟")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.bbvaGradient)
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .shadow(color: .bbvaBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .bbvaGreen))
                    .background(Color.bbvaGray)
                    .padding(.horizontal, 20)
                    .frame(height: 10)
                    .cornerRadius(5)
                
                ZStack {
                    ForEach(steps.indices, id: \.self) { index in
                        TutorialStepView(
                            step: steps[index],
                            isActive: index == currentStep,
                            isCompleted: completedSteps.contains(index)
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                completedSteps.insert(index)
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
                    print("Continuar presionado en tutorial")
                    navigationPath.append("personas")
                }) {
                    Text("Continuar")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.bbvaWhite)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isTutorialComplete ? Color.bbvaLightBlue : Color.bbvaGray)
                        .cornerRadius(12)
                }
                .disabled(!isTutorialComplete)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .onAppear {
            print("GuidedRegistrationTutorialView apareció")
        }
    }
}

struct TutorialStepView: View {
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
            
            Text(step.description)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.bbvaBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
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
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .disabled(isCompleted)
        }
        .frame(maxWidth: .infinity)
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

struct GuidedRegistrationTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedRegistrationTutorialView(navigationPath: .constant(NavigationPath()))
    }
}
