import SwiftUI

struct empresa: View {
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    @Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 60) {
                Spacer()

                VStack(spacing: 10) {
                    Text("¿Ya tienes una")
                        .font(.system(size: 40, weight: .regular))
                        .foregroundColor(.black)

                    Text("empresa?")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(marino)
                }

                VStack(spacing: 25) {
                    Button(action: {
                        print("Usuario seleccionó: Sí")
                        navigationPath.append("nombre")
                    }) {
                        Text("Sí")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: 120)
                            .frame(height: 60)
                    }
                    .buttonStyle(ExtraRoundedButtonStyle(color: marino))

                    Button(action: {
                        print("Usuario seleccionó: No")
                        navigationPath.append("nombre2") 
                    }) {
                        Text("No")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: 120)
                            .frame(height: 60)
                    }
                    .buttonStyle(ExtraRoundedButtonStyle(color: marino.opacity(0.8)))
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}

struct ExtraRoundedButtonStyle: ButtonStyle {
    var color: Color
    var cornerRadius: CGFloat = 35

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .shadow(color: .gray.opacity(configuration.isPressed ? 0.1 : 0.3),
                            radius: configuration.isPressed ? 2 : 8,
                            x: configuration.isPressed ? 1 : 4,
                            y: configuration.isPressed ? 1 : 4)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}

struct EmpresaView_Previews: PreviewProvider {
    static var previews: some View {
        empresa(navigationPath: .constant(NavigationPath()))
    }
}
