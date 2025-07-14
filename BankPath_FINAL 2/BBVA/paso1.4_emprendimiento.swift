import SwiftUI

struct EmprendimientoView: View {
    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    @Binding var navigationPath: NavigationPath

    struct Categoria: Identifiable {
        let id = UUID()
        let nombre: String
        let icono: String
        let color: Color
    }

    let categorias: [Categoria] = [
        .init(nombre: "Alimentos", icono: "🍔", color: Color(red: 255/255, green: 183/255, blue: 3/255)),
        .init(nombre: "Moda", icono: "👗", color: Color.pink),
        .init(nombre: "Belleza", icono: "💄", color: Color(red: 233/255, green: 30/255, blue: 99/255)),
        .init(nombre: "Decoración", icono: "🏠", color: Color(red: 102/255, green: 187/255, blue: 106/255)),
        .init(nombre: "Salud", icono: "🌿", color: Color(red: 0/255, green: 150/255, blue: 136/255)),
        .init(nombre: "Tecnología", icono: "💻", color: Color(red: 33/255, green: 150/255, blue: 243/255)),
        .init(nombre: "Educación", icono: "📚", color: Color.orange),
        .init(nombre: "Mascotas", icono: "🐶", color: Color(red: 255/255, green: 112/255, blue: 67/255)),
        .init(nombre: "Eventos", icono: "🎉", color: Color.purple),
        .init(nombre: "Manualidades", icono: "🧵", color: Color(red: 171/255, green: 71/255, blue: 188/255)),
        .init(nombre: "Sostenibilidad", icono: "🌱", color: Color.green),
        .init(nombre: "Juguetes", icono: "🧸", color: Color(red: 255/255, green: 204/255, blue: 128/255))
    ]

    @State private var seleccion: Categoria?

    var body: some View {
        VStack(spacing: 30) {
            Text("¿Qué te gustaría emprender?")
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(marino)
                .padding(.top, 40)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                    ForEach(categorias) { categoria in
                        Button(action: {
                            withAnimation {
                                seleccion = categoria
                                print("Seleccionada: \(categoria.nombre)")
                            }
                        }) {
                            VStack(spacing: 6) {
                                Text(categoria.icono)
                                    .font(.system(size: 40))
                                Text(categoria.nombre)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(width: 140, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(categoria.color.opacity(seleccion?.id == categoria.id ? 1 : 0.85))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(seleccion?.id == categoria.id ? Color.white : Color.clear, lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            .scaleEffect(seleccion?.id == categoria.id ? 1.05 : 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }

            Button(action: {
                if let seleccion = seleccion {
                    print("Continuar con categoría: \(seleccion.nombre)")
                    navigationPath.append("mapa_oportunidades_\(seleccion.nombre)")
                } else {
                    print("No se ha seleccionado ninguna categoría")
                }
            }) {
                Text("Continuar")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(marino)
                            .shadow(color: marino.opacity(0.5), radius: 5, x: 0, y: 3)
                    )
                    .padding(.horizontal, 50)
            }
            .disabled(seleccion == nil)
            .opacity(seleccion == nil ? 0.5 : 1)
            .padding(.bottom, 40)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            print("EmprendimientoView apareció")
        }
    }
}

struct EmprendimientoView_Previews: PreviewProvider {
    static var previews: some View {
        EmprendimientoView(navigationPath: .constant(NavigationPath()))
    }
}
