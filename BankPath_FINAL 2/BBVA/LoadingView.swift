import SwiftUI

struct LoadingView: View {
    private let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    private let bbvaGreen = Color(red: 0/255, green: 153/255, blue: 51/255)
    private let bbvaGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0/255, green: 51/255, blue: 102/255),
            Color(red: 0/255, green: 128/255, blue: 255/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    fileprivate struct CasoExito: Identifiable {
        let id = UUID()
        let title: String
        let exito: String
        let diferencial: String
        let mensaje: String
        let emoji: String
        let imageName: String
    }

    private let casos: [CasoExito] = [
        .init(
            title: "Brand Summit",
            exito: "Transformó la forma de trabajar en eventos.",
            diferencial: "Flexibilidad y salario emocional para su equipo.",
            mensaje: "¡Cuida a tu equipo y verás grandes resultados!",
            emoji: "🎉",
            imageName: "brand_summit_person"
        ),
        .init(
            title: "Gastroadictos",
            exito: "Fusionó sabor y sostenibilidad.",
            diferencial: "Usó prácticas verdes para ganar clientes fieles.",
            mensaje: "¡Cocina con conciencia y marca la diferencia!",
            emoji: "🍴",
            imageName: "gastroadictos_person"
        ),
        .init(
            title: "Tewer",
            exito: "Lideró en energía renovable.",
            diferencial: "Controló sus finanzas con BBVA.",
            mensaje: "¡Cuida tus números y haz crecer tu pyme!",
            emoji: "⚡️",
            imageName: "tewer_person"
        ),
        .init(
            title: "Mimcook",
            exito: "Creció con innovación tecnológica.",
            diferencial: "Digitalizó y atrajo más clientes.",
            mensaje: "¡Conecta con tu mercado desde lo digital!",
            emoji: "📱",
            imageName: "mimcook_person"
        ),
        .init(
            title: "Ecoalf",
            exito: "Inspiró con moda reciclada.",
            diferencial: "Se unió a ‘Proveedores Sostenibles’ de BBVA.",
            mensaje: "¡Apuesta por lo verde y deja huella positiva!",
            emoji: "♻️",
            imageName: "ecoalf_person"
        )
    ]

    @State private var currentIndex = 0
    @State private var timer: Timer?
    @State private var isPaused = false
    @State private var progress: Double = 0.0
    @State private var animateTitle = false
    @State private var animateExit = false
    @Binding var showLoadingView: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Inspiración para tu éxito")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(bbvaGradient)
                    .shadow(color: marino.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.top, 60)
                    .scaleEffect(animateTitle ? 1.0 : 0.8)
                    .opacity(animateTitle ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateTitle)

                Text("Conoce historias de Pymes que triunfaron con BBVA")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .opacity(0.8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(casos) { caso in
                            CasoExitoCard(caso: caso, isCurrent: caso.id == casos[currentIndex].id, isPaused: isPaused)
                                .frame(width: 300, height: 400)
                                .onTapGesture {
                                    isPaused.toggle()
                                    if isPaused {
                                        timer?.invalidate()
                                    } else {
                                        startTimer()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .offset(x: -CGFloat(currentIndex) * 316)
                    .animation(.linear(duration: 0.4), value: currentIndex)
                }
                .frame(height: 420)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(bbvaGradient)
                            .frame(width: geometry.size.width * progress, height: 8)
                            .animation(.linear(duration: 3.5), value: progress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 20)

                Spacer()
            }
            .opacity(animateExit ? 0.0 : 1.0)
            .animation(.easeInOut(duration: 1.0), value: animateExit)
        }
        .onAppear {
            print("LoadingView apareció")
            animateTitle = true
            startTimer()
        }
        .onDisappear {
            print("LoadingView desapareció")
            timer?.invalidate()
        }
    }

    private func startTimer() {
        print("Iniciando temporizador para carrusel")
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            if currentIndex < casos.count - 1 {
                currentIndex += 1
                progress = Double(currentIndex + 1) / Double(casos.count)
                print("Mostrando caso \(currentIndex + 1): \(casos[currentIndex].title)")
            } else {
                print("Carrusel terminado, iniciando animación de salida")
                timer?.invalidate()
                withAnimation {
                    animateExit = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("Ocultando LoadingView")
                    showLoadingView = false
                }
            }
        }
    }
}

struct CasoExitoCard: View {
    fileprivate let caso: LoadingView.CasoExito
    let isCurrent: Bool
    let isPaused: Bool
    private let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    
    var body: some View {
        VStack(spacing: 12) {
            profileImage
            titleSection
            detailsSection
            messageSection
        }
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .opacity(1.0)
    }
    
    private var profileImage: some View {
        Image(caso.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.top, 16)
    }
    
    private var titleSection: some View {
        HStack {
            Text(caso.emoji)
                .font(.system(size: 24))
            Text(caso.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(marino)
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 8) {
            Text("Éxito: \(caso.exito)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Text("Diferente: \(caso.diferencial)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 12)
    }
    
    private var messageSection: some View {
        Text(caso.mensaje)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(marino)
            .italic()
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
    }
    
    private var cardBackground: some View {
        Color.white
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(marino.opacity(isCurrent ? 0.5 : 0.2), lineWidth: 2)
            )
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(showLoadingView: .constant(true))
    }
}
