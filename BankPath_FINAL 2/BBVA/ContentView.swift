
import SwiftUI

struct ContentView: View {
    let treeImages = ["tree1", "tree2", "tree3", "tree4", "tree5"]
    let levels = ["1", "2", "3", "4", "5"]
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    @State private var selectedLevel: Int? = nil
    @State private var navigationPath = NavigationPath()
    @State private var completedLevels: Set<Int> = []
    @AppStorage("hasShownLoadingView") private var hasShownLoadingView = false
    @State private var showLoadingView = false
    @State private var hasInitialized = false
    
    var body: some View {
        ZStack {
            NavigationStack(path: $navigationPath) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("BankPath")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(marino)
                            .padding(.top, 90)
                            .shadow(color: .white, radius: 7, x: 5, y: 1)
                        
                        ZStack {
                            PathView(count: levels.count)
                                .padding(.horizontal, 40)
                                .padding(.top, 100)
                            
                            LevelButtonsPath(
                                levels: levels,
                                treeImages: treeImages,
                                selectedLevel: $selectedLevel,
                                navigationPath: $navigationPath,
                                completedLevels: $completedLevels
                            )
                            .padding(.horizontal, 40)
                        }
                        .frame(height: 600)
                        
                        Button(action: {
                            print("Finalizar presionado, navegando a HolaChris")
                            navigationPath = NavigationPath()
                            navigationPath.append("hola_chris")
                        }) {
                            Text("Finalizar")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(height: 70)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 55)
                                        .fill(marino.opacity(completedLevels.count == levels.count ? 0.7 : 0.3))
                                        .shadow(color: marino, radius: 9, x: 0, y: 4)
                                )
                        }
                        .padding(.horizontal, 120)
                        .padding(.bottom, 20)
                        .padding(.top, -60)
                        .disabled(completedLevels.count != levels.count)
                        
                       
                        Button(action: {
                            print("Restableciendo hasShownLoadingView")
                            hasShownLoadingView = false
                            showLoadingView = true
                        }) {
                            Text("¡Conoce más!")
                                .font(.caption)
                                .foregroundColor(marino)
                                .padding(.vertical, 5)
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.1), .white.opacity(0.4)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ).ignoresSafeArea()
                    )
                    .navigationDestination(for: String.self) { destination in
                        switch destination {
                        case "cuenta":
                            cuenta(navigationPath: $navigationPath)
                        case "empresa":
                            empresa(navigationPath: $navigationPath)
                        case "nombre":
                            nombre(navigationPath: $navigationPath)
                        case "nombre2":
                            nombre2(navigationPath: $navigationPath)
                        case "emprendimiento":
                            EmprendimientoView(navigationPath: $navigationPath)
                        case "ingresos":
                            IngresosView(navigationPath: $navigationPath)
                        case "formalizar":
                            FormalizarNegocioView(navigationPath: $navigationPath)
                        case "guided_tutorial":
                            GuidedRegistrationTutorialView(navigationPath: $navigationPath)
                        case "personas":
                            BlueSectionView(navigationPath: $navigationPath)
                        case "SAT2":
                            GuidedSATAppointmentView(navigationPath: $navigationPath)
                        case "FINAL":
                            GuidedTaxRegimeView(navigationPath: $navigationPath)
                        case "paso3":
                            primer(navigationPath: $navigationPath)
                        case "paso4":
                            segundo(navigationPath: $navigationPath)
                        case "paso4.2":
                            tercero(navigationPath: $navigationPath)
                        case "paso5":
                            ScoringReviewView(navigationPath: $navigationPath)
                        case "paso5.2":
                            ContractSigningView(navigationPath: $navigationPath)
                        case "candado":
                            candado(navigationPath: $navigationPath)
                        case "hola_chris":
                            HolaChris()
                        case "chrisBBVA":
                            RFCRegistrationView1(navigationPath: $navigationPath)
                        case let destination where destination.hasPrefix("mapa_oportunidades_"):
                            let categoria = destination.replacingOccurrences(of: "mapa_oportunidades_", with: "")
                            MapaOportunidadesView(navigationPath: $navigationPath)
                        default:
                            Text("Destino no encontrado: \(destination)")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            if showLoadingView {
                LoadingView(showLoadingView: $showLoadingView)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .onAppear {
            print("ContentView apareció")
            if !hasInitialized && !hasShownLoadingView {
                print("Mostrando LoadingView por primera vez")
                showLoadingView = true
                hasShownLoadingView = true
                hasInitialized = true
            }
        }
    }
}

struct PathView: View {
    let count: Int
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            let verticalSegment = height / CGFloat(count + 1)
            var path = Path()
            var startX = width * 0.3
            path.move(to: CGPoint(x: startX, y: 0))
            for i in 1...count {
                let nextX = i % 2 == 0 ? width * 0.3 : width * 0.7
                let controlY = verticalSegment * CGFloat(i) - verticalSegment * 0.5
                let endY = verticalSegment * CGFloat(i)
                path.addCurve(
                    to: CGPoint(x: nextX, y: endY),
                    control1: CGPoint(x: startX, y: controlY),
                    control2: CGPoint(x: nextX, y: controlY)
                )
                startX = nextX
            }
            context.stroke(path, with: .color(.blue.opacity(0.7)), lineWidth: 15)
        }
    }
}

struct LevelButtonsPath: View {
    let levels: [String]
    let treeImages: [String]
    @Binding var selectedLevel: Int?
    @Binding var navigationPath: NavigationPath
    @Binding var completedLevels: Set<Int>
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let verticalSegment = height / CGFloat(levels.count + 1)
            ZStack {
                ForEach(0..<levels.count, id: \.self) { index in
                    let y = verticalSegment * CGFloat(index + 0)
                    let x = index % 2 == 0 ? width * 0.3 : width * 0.7
                    VStack(spacing: 0) {
                        Image(treeImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 0, height: 130)
                            .shadow(color: .gray.opacity(0.6), radius: 3, x: 0, y: 2)
                            .offset(x: 20, y: -10)
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedLevel = index
                                completedLevels.insert(index)
                                print("Nivel \(levels[index]) seleccionado")
                                if index == 0 {
                                    print("Nivel 1 presionado, navegando a cuenta")
                                    navigationPath.append("cuenta")
                                } else if index == 1 {
                                    print("Nivel 2 presionado, navegando a tutorial")
                                    navigationPath.append("guided_tutorial")
                                } else if index == 2 {
                                    print("Nivel 3 presionado, navegando a paso3")
                                    navigationPath.append("paso3")
                                } else if index == 3 {
                                    print("Nivel 4 presionado, navegando a paso4")
                                    navigationPath.append("paso4")
                                } else if index == 4 {
                                    print("Nivel 5 presionado, navegando a paso5")
                                    navigationPath.append("paso5")
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 90, height: 90)
                                    .offset(y: 4)
                                    .blur(radius: 2)
                                Circle()
                                    .fill(marino.opacity(0.4))
                                    .frame(width: 90, height: 90)
                                    .shadow(color: Color.blue.opacity(0.5), radius: 2, x: 0, y: 1)
                                Circle()
                                    .fill(isAccessible(index) ? marino.opacity(0.9) : .gray.opacity(1))
                                    .frame(width: 80, height: 90)
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .center
                                    ))
                                    .frame(width: 80, height: 90)
                                Text(levels[index])
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedLevel == index ? marino : .clear, lineWidth: 3)
                                    .frame(width: 90, height: 90)
                            )
                            .scaleEffect(selectedLevel == index ? 1.1 : 1.0)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(!isAccessible(index))
                        if selectedLevel != nil && index <= (selectedLevel ?? -1) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 30))
                                .offset(x: 0, y: 10)
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        }
                    }
                    .position(x: x, y: y)
                }
            }
        }
    }
    
    private func isAccessible(_ level: Int) -> Bool {
        return level == 0 || level <= (selectedLevel ?? -1) + 1
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
