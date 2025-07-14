
import SwiftUI



struct primer: View {
    @State private var companyName: String = ""
    @State private var rfc: String = ""
    @State private var businessLine: String = ""
    @State private var showingDefinition: String? = nil
    @Binding var navigationPath: NavigationPath


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información de tu negocio")
                    .foregroundColor(.navyLight)
                    .font(.headline)) {
                    
                        HStack {
                            TextField("Nombre del negocio", text: $companyName)
                            Button(action: { showingDefinition = "razon_social" }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.navy)
                                    .accessibilityLabel("¿Qué es la razón social?")
                            }
                        }

                    
              
                        HStack {
                            TextField("RFC", text: $rfc)
                            Button(action: { showingDefinition = "rfc" }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.navy)
                                    .accessibilityLabel("¿Qué es el RFC?")
                            }
                        }

                    
                    TextField("¿A qué se dedica tu negocio?", text: $businessLine)
                        .foregroundColor(.navyLight)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        print("continuar")
                        navigationPath = NavigationPath()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        }
                    }
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.prepare()
                    impact.impactOccurred()
                })  {
                    Text("Enviar solicitud")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.navy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)
            }
            .navigationTitle("Solicitud")
            
        }
    }

    func submitInitialRequest() {
    
        print("Submitted: \(companyName), \(rfc), \(businessLine)")
    }
}


struct Definition1View: View {
    let term: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(term == "razon_social" ? "¿Qué es la razón social?" : "¿Qué es el RFC?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.navy)
            
            Text(term == "razon_social" ?
                "Es el nombre oficial de tu negocio, como se registra en los papeles legales. Por ejemplo, si tu tienda se llama 'Panadería Juan', la razón social podría ser 'Panadería Juan S.A. de C.V.'. ¡Es como el nombre de pila de tu empresa!" :
                "El RFC es un código que te da el gobierno (el SAT) para identificar tu negocio en temas de impuestos. Es como la 'CURP' de tu empresa, algo así como su ID oficial para pagar impuestos y hacer trámites.")
                .foregroundColor(.navyLight)
                .padding(.horizontal)
            
            Button(action: { /* Dismiss */ }) {
                Text("Entendido")
                    .frame(maxWidth: 180)
                    .padding()
                    .background(Color.navyLighter)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


struct primerView_Previews: PreviewProvider {
    static var previews: some View {
        primer(navigationPath: .constant(NavigationPath()))
    }
}
