
import SwiftUI
import Charts


struct HolaChris: View {
    var body: some View {
        TabView {
            MainBusinessView(
                companyName: "MyDoggy",
                userName: "Juan Pérez"
            )
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }

            TapToPayView()
            .tabItem {
                Label("Recibir Pago", systemImage: "creditcard.fill")
            }

            ChatAssistantView()
            .tabItem {
                Label("Asistente Virtual", systemImage: "message.fill")
            }
        }
        .accentColor(Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255))
    }
}

struct CreditGrowthData: Identifiable {
    let id = UUID()
    let month: String
    let creditAmount: Double
}

struct CreditGrowthChartView: View {
    private let data: [CreditGrowthData] = [
        CreditGrowthData(month: "Ene", creditAmount: 50000),
        CreditGrowthData(month: "Feb", creditAmount: 58000),
        CreditGrowthData(month: "Mar", creditAmount: 62000),
        CreditGrowthData(month: "Abr", creditAmount: 71000),
        CreditGrowthData(month: "May", creditAmount: 76000),
        CreditGrowthData(month: "Jun", creditAmount: 83000)
    ]

    private let bbvaBlue = Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255)

    var body: some View {
        VStack(alignment: .leading) {
            Text("Crecimiento Crediticio")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(bbvaBlue)
                .padding(.bottom, 8)

            Chart(data) { item in
                BarMark(
                    x: .value("Mes", item.month),
                    y: .value("Crédito", item.creditAmount)
                )
                .foregroundStyle(bbvaBlue)
            }
            .frame(height: 200)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}



struct MainBusinessView: View {
    let companyName: String
    let userName: String

   
    let gastos: Double = 1_250.75
    let ganancias: Double = 3_800.20


    private let bbvaBlue = Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255)

    var body: some View {
        VStack(spacing: 0) {
           
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(bbvaBlue)
                    .frame(height: 100)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(companyName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text("Hola, \(userName)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.leading, 24)
                .padding(.bottom, 24)

                HStack {
                    Spacer()
                    Button(action: {
                 
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(bbvaBlue.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 24)
                }
            }



            ScrollView {
                VStack(spacing: 24) {
                
                    HStack(spacing: 16) {
                        financialCard(title: "Gastos", amount: gastos, color: .red)
                        financialCard(title: "Ganancias", amount: ganancias, color: .green)
                    }
                    .padding(.horizontal, 16)

         
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Crecimiento y Mejoras")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(bbvaBlue)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                AdviceCard(icon: "chart.bar.fill",
                                           title: "Ventas +28.4%",
                                           subtitle: "Reducir gastos en agua 30%")
                                AdviceCard(icon: "bolt.fill",
                                           title: "Ganancias +15%",
                                           subtitle: "Optimizar electricidad 10%")
                                AdviceCard(icon: "cube.box.fill",
                                           title: "Inventario +8%",
                                           subtitle: "Mejorar gestión diaria")
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 120)
                    }
                    .padding(.vertical, 8)
                    CreditGrowthChartView()
                }
                .padding(.top, 24)
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

 
    @ViewBuilder
    private func financialCard(title: String, amount: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
            Text(amount, format: .currency(code: "MXN"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


struct AdviceCard: View {
    let icon: String
    let title: String
    let subtitle: String

    private let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(red: 245/255, green: 247/255, blue: 250/255)]),
        startPoint: .top,
        endPoint: .bottom
    )
    private let bbvaBlue = Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255)

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(bbvaBlue.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(bbvaBlue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .frame(width: 220, height: 100)
        .background(cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}


struct TapToPayView: View {
    @State private var paymentSuccess = false
    private let bbvaBlue = Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255)

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                Text("BBVA Tap to Pay")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(bbvaBlue)
                    .padding(.top, 40)

                Spacer()

                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(paymentSuccess ? Color.green : bbvaBlue, lineWidth: 4)
                    .frame(width: 300, height: 200)
                    .overlay(
                        Text(paymentSuccess ? "✓ Pago exitoso" : "Acerca aquí tu tarjeta")
                            .font(.system(size: 18, weight: paymentSuccess ? .bold : .medium))
                            .foregroundColor(paymentSuccess ? .green : bbvaBlue)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            paymentSuccess = true
                        }
                    }

                if !paymentSuccess {
                    Text("Coloca la tarjeta del cliente sobre el dispositivo para iniciar el pago.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: {
                   
                }) {
                    Text("Continuar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(paymentSuccess ? bbvaBlue : Color.gray.opacity(0.4))
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)
                .disabled(!paymentSuccess)

                Spacer()
            }
        }
    }
}


struct ChatAssistantView: View {
    @State private var messages: [String] = ["¡Hola! ¿En qué puedo ayudarte hoy?"]
    @State private var inputText: String = ""
    private let bbvaBlue = Color(red: 0.0/255, green: 51.0/255, blue: 153.0/255)

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages.indices, id: \.self) { idx in
                            Text(messages[idx])
                                .padding()
                                .background(idx % 2 == 0 ? Color(red: 245/255, green: 247/255, blue: 250/255) : bbvaBlue.opacity(0.1))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, alignment: idx % 2 == 0 ? .leading : .trailing)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _ in
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }

     
            HStack {
                TextField("Escribe un mensaje...", text: $inputText)
                    .padding(12)
                    .background(Color(red: 245/255, green: 247/255, blue: 250/255))
                    .cornerRadius(20)
                Button(action: {
                    guard !inputText.isEmpty else { return }
                    
                    let userMessage = inputText
                    messages.append(userMessage)
                    
           
                    let lowercasedInput = userMessage.lowercased()
                    var botResponse = "Lo siento, aún estoy aprendiendo. ¿Puedes reformular tu pregunta?"

                    if lowercasedInput.contains("qué es un crédito") || lowercasedInput.contains("que es un credito") {
                        botResponse = "Es un préstamo que puedes usar y devolver después."
                    } else if lowercasedInput.contains("mes con mayor venta") || lowercasedInput.contains("mayor ventas") {
                        botResponse = "Junio fue el mes con mayores ventas."
                    } else if lowercasedInput.contains("maestro") {
                        botResponse = "Maestro, maestro!"
                    }

   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        messages.append(botResponse)
                    }

                    inputText = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(bbvaBlue)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct HolaChris_Previews: PreviewProvider {
    static var previews: some View {
        HolaChris()
    }
}
