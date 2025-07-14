import SwiftUI

struct FormalizarNegocioView: View {
    @State private var ingresosAnuales: Double = 0
    @Binding var navigationPath: NavigationPath
    private let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    
    private var categoria: String {
        switch ingresosAnuales {
        case ..<5:
            return "Microempresa"
        case 5..<60:
            return "Pequeña empresa"
        case 60..<140:
            return "Mediana empresa"
        default:
            return "Gran empresa"
        }
    }

    private var creditoDisponible: String {
        switch categoria {
        case "Microempresa":
            return "$50,000 hasta $25,000,000 MXN"
        case "Pequeña empresa":
            return "$50,000 hasta $25,000,000 MXN"
        case "Mediana empresa":
            return "$50,000 hasta $25,000,000 MXN"
        default:
            return "Consultar con BBVA para más detalles"
        }
    }

    private var beneficios: [String] {
        switch categoria {
        case "Microempresa":
            return [
                "Sin saldo mínimo ni comisión de manejo",
                "Tarjeta débito de negocios sin costo",
                "Protección de cheques sin costo",
                "Acceso a la banca digital"
            ]
        case "Pequeña empresa":
            return [
                "Sin saldo mínimo ni comisión de manejo",
                "Tarjeta débito de negocios sin costo",
                "Protección de cheques sin costo",
                "Consultoría financiera para crecer"
            ]
        case "Mediana empresa":
            return [
                "Sin saldo mínimo ni comisión de manejo",
                "Tarjeta débito de negocios sin costo",
                "Protección de cheques sin costo",
                "Consultoría personalizada y acceso a líneas de crédito",
                "Tasas competitivas y descuentos exclusivos"
            ]
        default:
            return [
                "Consultar con BBVA para más detalles"
            ]
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Formaliza tu negocio con BBVA")
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(marino)
                .padding(.top, 40)

            VStack {
                Text("Ingresa tus ingresos anuales:")
                    .font(.title3)
                    .foregroundColor(marino)
                
                HStack {
                    Text("0")
                        .foregroundColor(marino)
                    Slider(value: $ingresosAnuales, in: 0...150, step: 1)
                        .accentColor(marino)
                    Text("\(String(format: "%.0f", ingresosAnuales)) millones de pesos")
                        .foregroundColor(marino)
                }
                .padding(.horizontal, 40)
            }

            VStack(spacing: 20) {
                Text("Categoría: \(categoria)")
                    .font(.title2)
                    .foregroundColor(marino)
                
                Text("Crédito disponible para tu empresa:")
                    .font(.headline)
                    .foregroundColor(marino)

                Text(creditoDisponible)
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(marino, lineWidth: 2))
            }
            .padding()

            VStack(alignment: .leading, spacing: 15) {
                Text("Beneficios de abrir tu Cuenta Maestra Pyme en BBVA:")
                    .font(.headline)
                    .foregroundColor(marino)

                ForEach(beneficios, id: \.self) { beneficio in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(beneficio)
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 5))
            .padding(.horizontal, 30)

            Button(action: {
                print("Continuar con el registro de la Pyme")
                navigationPath = NavigationPath()
            }) {
                Text("Continuar")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 180)
                    .background(marino)
                    .cornerRadius(40)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .background(Color(white: 0.95).ignoresSafeArea())
    }
}

struct FormalizarNegocioView_Previews: PreviewProvider {
    static var previews: some View {
        FormalizarNegocioView(navigationPath: .constant(NavigationPath()))
    }
}
