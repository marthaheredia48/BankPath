
import SwiftUI

struct ScoringReviewView: View {
    @State private var scoringInProgress: Bool = true
    @State private var score: Int? = nil
    @State private var status: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showingDefinition: String? = nil
    @Binding var navigationPath: NavigationPath


    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                HStack {
                    Text(scoringInProgress ? "Estamos revisando tu solicitud..." : "Revisión completa")
                        .font(.title2)
                        .foregroundColor(.navy)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: { showingDefinition = "scoring" }) {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.navy)
                            .font(.title2)
                    }
                }

                if scoringInProgress {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .navy))
                            .scaleEffect(1.8)
                        Text("Procesando...")
                            .foregroundColor(.navyLight)
                    }
                    .padding(.top, 20)
                } else {
                    VStack(spacing: 20) {
                        iconForStatus()
                            .font(.system(size: 50))
                            .foregroundColor(iconColor())
                        
                        Text("Tu puntaje: \(score ?? 0)/100")
                            .font(.headline)
                            .foregroundColor(.navy)

                        Text("Estado: \(status)")
                            .font(.subheadline)
                            .foregroundColor(.navyLight)

                        Button(action: {
                            alertMessage = resultMessage()
                            showAlert = true

                        }) {
                            Text("Ver detalles")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.navy)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            navigationPath.append("paso5.2")


                        }) {
                            Text("CONTINUAR")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.navy)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.navyLighter.opacity(0.15))
                    .cornerRadius(15)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: score)
                    
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Revisando tu solicitud")
            .sheet(item: $showingDefinition) { definition in
                Definition2View(term: definition)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Resultado"), message: Text(alertMessage), dismissButton: .default(Text("Entendido")))
            }
            .onAppear {
                startScoring()
            }
        }
    }

    func startScoring() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let newScore = 99
            score = newScore

           
            withAnimation {
                
                
                if  newScore >= 80 {
                    status = "Aprobado"
                    alertMessage = "¡Felicidades! Tu solicitud ha sido aprobada. Obtuviste un puntaje de \(newScore)/100. ¡Ya casi terminas y pronto podrás disfrutar de los beneficios de ser parte de la familia BBVA!"
                } else if newScore >= 60 {
                    status = "Necesita más información"
                    alertMessage = "Tu puntaje es \(newScore)/100. Necesitamos más documentos para aprobar tu solicitud. Revisa tu correo para más detalles."
                } else {
                    status = "Rechazado"
                    alertMessage = "Lo sentimos, tu solicitud no fue aprobada. Tu puntaje es \(newScore)/100. Puedes intentarlo de nuevo más adelante."
                }
                scoringInProgress = false
                showAlert = true
            }
        }
    }

    func resultMessage() -> String {
        switch status {
        case "Aprobado":
            return "¡Todo listo! Tu negocio pasó la revisión con un puntaje de \(score ?? 0)/100. Pronto te mandaremos los detalles para seguir adelante."
        case "Necesita más información":
            return "Estás cerca, pero necesitamos un poco más de info. Tu puntaje es \(score ?? 0)/100. Checa tu correo para saber qué falta."
        case "Rechazado":
            return "Tu puntaje es \(score ?? 0)/100, y esta vez no pasaste. No te preocupes, puedes intentar de nuevo más adelante."
        default:
            return ""
        }
    }

    func iconForStatus() -> Image {
        switch status {
        case "Aprobado":
            return Image(systemName: "checkmark.seal.fill")
        case "Necesita más información":
            return Image(systemName: "exclamationmark.triangle.fill")
        case "Rechazado":
            return Image(systemName: "xmark.octagon.fill")
        default:
            return Image(systemName: "questionmark.circle")
        }
    }

    func iconColor() -> Color {
        switch status {
        case "Aprobado": return .green
        case "Necesita más información": return .orange
        case "Rechazado": return .red
        default: return .gray
        }
    }
}


struct Definition2View: View {
    @Environment(\.dismiss) var dismiss
    let term: String

    var body: some View {
        VStack(spacing: 24) {
            Text(definitionTitle(for: term))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.navy)

            Text(definitionText(for: term))
                .foregroundColor(.navyLight)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { dismiss() }) {
                Text("Entendido")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.navy)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }

    func definitionTitle(for term: String) -> String {
        term == "scoring" ? "¿Qué es el Scoring?" : "¿Qué es \(term)?"
    }

    func definitionText(for term: String) -> String {
        term == "scoring" ?
            "Es como una calificación que le damos a tu negocio para ver si cumple con lo que necesitamos. Revisamos tus documentos, fotos y videos, y te damos un puntaje. Es como cuando te ponían una nota en la escuela, pero para tu negocio." :
            "Este término no tiene una definición específica, pero estamos aquí para ayudarte."
    }
}


struct ScoringReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringReviewView(navigationPath: .constant(NavigationPath()))
    }
}
