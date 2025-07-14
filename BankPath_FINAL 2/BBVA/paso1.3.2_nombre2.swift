

import SwiftUI

struct nombre2: View {
    @State private var companyName: String = ""
    @Binding var navigationPath: NavigationPath
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Nombre de la")
                .font(.system(size: 40, weight: .regular))
                .foregroundColor(.black)

            Text("empresa")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(marino)
            
            TextField("Ingresa el nombre de la empresa", text: $companyName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(marino.opacity(0.6), lineWidth: 1))
                .padding(.horizontal, 40)
                .padding(.top, 40)
            
            Button(action: {
                print("Empresa ingresada: \(companyName)")
                navigationPath.append("emprendimiento")
            }) {
                Text("Continuar")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .frame(maxWidth: 170)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(marino.opacity(0.8))
                            .shadow(color: marino.opacity(0.3), radius: 5, x: 0, y: 4)
                    )
            }
            .padding(.horizontal, 60)
            .padding(.top, 80)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, -130)
    }
}

struct EmpresaInputView2_Previews: PreviewProvider {
    static var previews: some View {
        nombre2(navigationPath: .constant(NavigationPath()))
    }
}
