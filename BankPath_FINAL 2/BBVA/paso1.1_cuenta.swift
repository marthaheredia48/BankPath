import SwiftUI

struct cuenta: View {
    @State private var nombre = ""
    @State private var apellidos = ""
    @State private var correo = ""
    @State private var direccion = ""
    @Binding var navigationPath: NavigationPath
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)

            VStack(spacing: 45) {
                Text("Crea tu cuenta")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(marino)
                    .padding(.top, 220)

                VStack(spacing: 25) {
                    RoundedTextField(placeholder: "Nombre", text: $nombre)
                    RoundedTextField(placeholder: "Apellidos", text: $apellidos)
                    RoundedTextField(placeholder: "Correo electrónico", text: $correo, keyboard: .emailAddress)
                    RoundedTextField(placeholder: "Dirección", text: $direccion)
                }
                .padding(.horizontal, 30)

                Spacer()

                Button(action: {
                    print("Continuar presionado")
                    navigationPath.append("empresa")
                }) {
                    HStack {
                        Text("Continuar")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: 180)
                    .background(marino.opacity(0.7))
                    .cornerRadius(80)
                    .shadow(color: marino.opacity(0.4), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 150)
            }
        }
    }
}

struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboard)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 2)
    }
}

struct CuentaView_Previews: PreviewProvider {
    static var previews: some View {
        cuenta(navigationPath: .constant(NavigationPath()))
    }
}
