
import SwiftUI


struct SignaturePad: View {
    @Binding var signaturePoints: [CGPoint]
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                Path { path in
                    guard !signaturePoints.isEmpty else { return }
                    path.move(to: signaturePoints[0])
                    for pt in signaturePoints.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
                .stroke(Color.black, lineWidth: 2)
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let point = value.location
                    signaturePoints.append(point)
                }
            )
            .border(Color.gray, width: 1)
        }
        .frame(height: 200)
    }
}


struct ContractSigningView: View {
    @State private var efirmaOK = false
    @State private var signaturePoints: [CGPoint] = []
    @State private var otp = ""
    @State private var generatedOTP: String? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingDefinition: DefinitionTerm?
    @Binding var navigationPath: NavigationPath


    enum DefinitionTerm: String, Identifiable {
        case eFirma = "e_firma"
        case otp = "otp"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tu firma (dibuja abajo)")
                            .foregroundColor(.navy)
                            .font(.headline)) {
                    SignaturePad(signaturePoints: $signaturePoints)
                    HStack {
                        Spacer()
                        Button("Limpiar firma") {
                            signaturePoints.removeAll()
                        }
                        .foregroundColor(.red)
                        Spacer()
                    }
                }

                Section(header: Text("Confirma tu e.firma")
                            .foregroundColor(.navy)
                            .font(.headline)) {
                    Toggle("e.firma lista", isOn: $efirmaOK)
                        .foregroundColor(.navyLight)
                    Button(action: { showingDefinition = .eFirma }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.navy)
                            .accessibilityLabel("¿Qué es la e.firma?")
                    }
                }

                Section(header: Text("Código de verificación")
                            .foregroundColor(.navy)
                            .font(.headline)) {
                    HStack {
                        TextField("Ingresa el código OTP", text: $otp)
                            .keyboardType(.numberPad)
                            .foregroundColor(.navyLight)
                        Button(action: { generateOTP() }) {
                            Text(generatedOTP == nil ? "Enviar OTP" : "Reenviar OTP")
                        }
                    }
                    Text("OTP enviado por " + (generatedOTP != nil ? "Gmail" : ""))
                        .font(.caption)
                        .foregroundColor(.navyLighter)
                }

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        print("continuar")
                        navigationPath.append("candado")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        }
                    }
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.prepare()
                    impact.impactOccurred()
                })   {
                    Text("Firmar contrato")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isReadyToSign ? Color.navy : Color.navyLighter)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isReadyToSign)
                .padding(.vertical)
            }
            .navigationTitle("Firma tu contrato")
            .sheet(item: $showingDefinition) { term in
                Definition4View(term: term)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notificación de Gmail"), message: Text(alertMessage), dismissButton: .default(Text("Entendido")))
            }
        }
    }

    private var isReadyToSign: Bool {
        !signaturePoints.isEmpty && efirmaOK && otp == generatedOTP
    }

    private func generateOTP() {
        let code = String(format: "%06d", Int.random(in: 0...999999))
        generatedOTP = code
        alertMessage = "Código OTP: \(code)"
        showAlert = true
    }

    private func signContract() {
        guard !signaturePoints.isEmpty else {
            alertMessage = "Por favor, firma en el área de arriba."
            showAlert = true; return
        }
        guard efirmaOK else {
            alertMessage = "Por favor, activa tu e.firma."
            showAlert = true; return
        }
        guard let gen = generatedOTP, otp == gen else {
            alertMessage = "OTP inválido. Revisa el código que simulamos."
            showAlert = true; return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertMessage = "¡Contrato firmado digitalmente!"
            showAlert = true
   
            signaturePoints.removeAll()
            efirmaOK = false
            otp = ""
            generatedOTP = nil
        }
    }
}


struct Definition4View: View {
    @Environment(\.dismiss) private var dismiss
    let term: ContractSigningView.DefinitionTerm

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.navy)

            Text(description)
                .foregroundColor(.navyLight)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            Button("Entendido") { dismiss() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.navyLighter)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    private var title: String {
        switch term {
        case .eFirma: return "¿Qué es la e.firma?"
        case .otp: return "¿Qué es el Código OTP?"
        }
    }
    private var description: String {
        switch term {
        case .eFirma:
            return "La e.firma es la firma electrónica avanzada que otorga el SAT (Servicio de Administración Tributaria). Funciona como tu firma manuscrita en digital y es requerida para realizar trámites y firmar documentos oficiales electrónicamente, incluyendo contratos bancarios ante BBVA."
        case .otp:
            return "Es un código de 6 dígitos que te enviamos a tu celular o correo para verificar tu identidad. Solo funciona una vez."
        }
    }
}


struct ContractSigningView_Previews: PreviewProvider {
    static var previews: some View {
        ContractSigningView(navigationPath: .constant(NavigationPath()))
    }
}
