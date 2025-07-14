import SwiftUI

struct candado: View {
    @State private var isLocked = true
    @State private var animationInProgress = false
    @Binding var navigationPath: NavigationPath

    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    
    var body: some View {
        VStack(spacing: 5) {
            Text("¡Listo! Ya eres parte del mundo")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.black)
              
            Text("BBVA Empresas 🚀")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(marino)
                .padding(.bottom, 20)
                
            ZStack {
                Circle()
                    .fill(isLocked ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .font(.system(size: 50))
                    .foregroundColor(isLocked ? .red : .green)
                    .rotationEffect(.degrees(animationInProgress ? 10 : 0))
                    .scaleEffect(animationInProgress ? 1.2 : 1.0)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animationInProgress)
        }
        .padding()
        .onAppear {
            toggleLock()
        }
    }

    func toggleLock() {
        withAnimation {
            animationInProgress = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isLocked.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation {
                    animationInProgress = false
                }

                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("Regresando a ContentView")
                    navigationPath = NavigationPath()
                }
            }
        }
    }
}

struct CandadoView_Previews: PreviewProvider {
    static var previews: some View {
        candado(navigationPath: .constant(NavigationPath()))
    }
}
