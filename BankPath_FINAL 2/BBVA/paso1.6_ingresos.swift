import SwiftUI

struct IngresosView: View {
    @State private var ingresos: Double = 5.0
    @Binding var navigationPath: NavigationPath
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)

    var body: some View {
        VStack(spacing: 40) {
            Text("Selecciona el rango de ingresos anuales ")
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(marino)
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .padding(.horizontal, 30)
            
            Text("\(String(format: "%.1f", ingresos)) MDP")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.black)

            Slider(value: $ingresos, in: 0...100, step: 0.5)
                .padding(.horizontal, 40)
            
            Button(action: {
                print("Ingresos seleccionados: \(ingresos) millones de pesos")
                navigationPath.append("formalizar")
            }) {
                Text("Continuar")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .frame(maxWidth: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(marino.opacity(0.8))
                            .shadow(color: marino.opacity(0.3), radius: 5, x: 0, y: 4)
                    )
            }
            .padding(.horizontal, 60)
            .padding(.top, 0)
            .padding(.bottom, 90)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct IngresosView_Previews: PreviewProvider {
    static var previews: some View {
        IngresosView(navigationPath: .constant(NavigationPath()))
    }
}
