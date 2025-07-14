

import SwiftUI
import MapKit


struct Zona: Identifiable {
    let id = UUID()
    let nombre: String
    let coordenada: CLLocationCoordinate2D
    let poblacion: Int
    let ingresosPromedio: Double
    let tiendasMascotas: Int
    let mascotas: Int
    let traficoComercial: Int
    
 
    var potencialMercado: Double {
     
        let demandaPoblacion = Double(poblacion) * 0.3
        let demandaIngresos = ingresosPromedio * 0.25
        let competencia = 10000.0 / Double(tiendasMascotas + 1) * 0.2
        let densidadMascotas = Double(mascotas) / Double(poblacion) * 100000 * 0.15
        let factorTrafico = Double(traficoComercial) * 0.1
        
        return demandaPoblacion + demandaIngresos + competencia + densidadMascotas + factorTrafico
    }
    

    var color: Color {
        switch potencialMercado {
        case let x where x > 50000: return Color(red: 0.8, green: 0, blue: 0)
        case let x where x > 40000: return Color(red: 1, green: 0.2, blue: 0.2)
        case let x where x > 30000: return Color(red: 1, green: 0.5, blue: 0)
        case let x where x > 20000: return Color(red: 1, green: 0.8, blue: 0)
        case let x where x > 10000: return Color(red: 0.5, green: 0.8, blue: 0)
        default: return Color(red: 0, green: 0.6, blue: 0.3)
        }
    }
    
    
    var tamanoCirculo: CGFloat {
        let base: CGFloat = 30
        let factor = min(sqrt(CGFloat(poblacion) / 10000), 3.0)
        return base * factor
    }
    

    var descripcion: String {
        """
        Población: \(formatNumber(poblacion)) habitantes
        Ingresos promedio: $\(formatNumber(Int(ingresosPromedio))) MXN
        Tiendas de mascotas: \(tiendasMascotas)
        Mascotas estimadas: \(formatNumber(mascotas))
        Tráfico comercial: \(traficoComercial > 80 ? "Alto" : traficoComercial > 50 ? "Medio" : "Bajo")
        """
    }
    

    var recomendacion: String {
        switch potencialMercado {
        case let x where x > 40000: return "Excelente ubicación para una tienda de mascotas"
        case let x where x > 30000: return "Muy buena ubicación con alto potencial"
        case let x where x > 20000: return "Buena ubicación con potencial moderado"
        case let x where x > 10000: return "Ubicación con potencial limitado"
        default: return "Ubicación poco recomendable"
        }
    }
    

    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct MapaOportunidadesView: View {

    let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    let fondoClaro = Color(red: 245/255, green: 248/255, blue: 250/255)
    
    @Binding var navigationPath: NavigationPath
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.6597, longitude: -103.3496),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )
    

    @State private var zoomLevel: CGFloat = 1.0
    
    
    @State private var zonaSeleccionada: Zona? = nil
    @State private var mostrarDetalles = false
    @State private var filtroSeleccionado: FiltroTipo = .potencial
    
    enum FiltroTipo: String, CaseIterable {
        case potencial = "Potencial de Mercado"
        case poblacion = "Población"
        case ingresos = "Nivel de Ingresos"
        case competencia = "Competencia"
    }
    
    
    let zonas: [Zona] = [
        Zona(nombre: "Centro", coordenada: CLLocationCoordinate2D(latitude: 20.6767, longitude: -103.3476),
             poblacion: 120000, ingresosPromedio: 22000, tiendasMascotas: 8, mascotas: 35000, traficoComercial: 90),
        Zona(nombre: "Zapopan", coordenada: CLLocationCoordinate2D(latitude: 20.7167, longitude: -103.4000),
             poblacion: 1500000, ingresosPromedio: 28000, tiendasMascotas: 45, mascotas: 480000, traficoComercial: 85),
        Zona(nombre: "Tlaquepaque", coordenada: CLLocationCoordinate2D(latitude: 20.6389, longitude: -103.3110),
             poblacion: 650000, ingresosPromedio: 19000, tiendasMascotas: 18, mascotas: 190000, traficoComercial: 75),
        Zona(nombre: "Tonalá", coordenada: CLLocationCoordinate2D(latitude: 20.6242, longitude: -103.2337),
             poblacion: 540000, ingresosPromedio: 16500, tiendasMascotas: 12, mascotas: 150000, traficoComercial: 60),
        Zona(nombre: "Providencia", coordenada: CLLocationCoordinate2D(latitude: 20.7053, longitude: -103.3900),
             poblacion: 85000, ingresosPromedio: 45000, tiendasMascotas: 7, mascotas: 40000, traficoComercial: 70),
        Zona(nombre: "Chapalita", coordenada: CLLocationCoordinate2D(latitude: 20.6667, longitude: -103.4000),
             poblacion: 70000, ingresosPromedio: 38000, tiendasMascotas: 5, mascotas: 32000, traficoComercial: 65),
        Zona(nombre: "Ciudad del Sol", coordenada: CLLocationCoordinate2D(latitude: 20.6872, longitude: -103.3361),
             poblacion: 110000, ingresosPromedio: 32000, tiendasMascotas: 4, mascotas: 48000, traficoComercial: 55),
        Zona(nombre: "Santa Tere", coordenada: CLLocationCoordinate2D(latitude: 20.6883, longitude: -103.3693),
             poblacion: 95000, ingresosPromedio: 25000, tiendasMascotas: 6, mascotas: 38000, traficoComercial: 80),
        Zona(nombre: "El Bajío", coordenada: CLLocationCoordinate2D(latitude: 20.7428, longitude: -103.4293),
             poblacion: 120000, ingresosPromedio: 35000, tiendasMascotas: 3, mascotas: 52000, traficoComercial: 50),
        Zona(nombre: "Patria", coordenada: CLLocationCoordinate2D(latitude: 20.6914, longitude: -103.4222),
             poblacion: 180000, ingresosPromedio: 29000, tiendasMascotas: 9, mascotas: 72000, traficoComercial: 75)
    ]
    
  
    func colorZona(_ zona: Zona) -> Color {
        switch filtroSeleccionado {
        case .potencial:
            return zona.color
        case .poblacion:
            let poblacionNormalizada = min(Double(zona.poblacion) / 500000, 1.0)
            return Color(red: 0.2 + 0.8 * poblacionNormalizada,
                         green: 0.6 - 0.4 * poblacionNormalizada,
                         blue: 0.8 - 0.8 * poblacionNormalizada)
        case .ingresos:
            let ingresosNormalizados = min(zona.ingresosPromedio / 50000, 1.0)
            return Color(red: 0.2 + 0.6 * ingresosNormalizados,
                         green: 0.2 + 0.8 * ingresosNormalizados,
                         blue: 0.8 - 0.6 * ingresosNormalizados)
        case .competencia:
            let competenciaNormalizada = min(Double(zona.tiendasMascotas) / 20, 1.0)
            return Color(red: 0.2 + 0.8 * competenciaNormalizada,
                         green: 0.8 - 0.6 * competenciaNormalizada,
                         blue: 0.2)
        }
    }
    
  
    func tamanoCirculo(_ zona: Zona) -> CGFloat {
        switch filtroSeleccionado {
        case .potencial:
            return zona.tamanoCirculo
        case .poblacion:
            let base: CGFloat = 30
            let factor = min(sqrt(CGFloat(zona.poblacion) / 10000), 3.0)
            return base * factor
        case .ingresos:
            let base: CGFloat = 30
            let factor = min(CGFloat(zona.ingresosPromedio) / 15000, 3.0)
            return base * factor
        case .competencia:
            let base: CGFloat = 30
            let factor = min(3.0 / (CGFloat(zona.tiendasMascotas) / 5 + 0.5), 3.0)
            return base * factor
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
 
            VStack(spacing: 5) {
                Text("Mapa de Oportunidades")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(marino)
                
                Text("Tiendas de Mascotas en Guadalajara")
                    .font(.system(size: 18))
                    .foregroundColor(marino.opacity(0.8))
            }
            .padding(.top, 15)
            .padding(.bottom, 5)
            
         
            Picker("Filtro", selection: $filtroSeleccionado) {
                ForEach(FiltroTipo.allCases, id: \.self) { filtro in
                    Text(filtro.rawValue).tag(filtro)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom, 5)
            
         
            HStack(spacing: 15) {
                leyendaItem(color: filtroLeyenda(0), texto: filtroTextoLeyenda(0))
                leyendaItem(color: filtroLeyenda(0.33), texto: filtroTextoLeyenda(0.33))
                leyendaItem(color: filtroLeyenda(0.66), texto: filtroTextoLeyenda(0.66))
                leyendaItem(color: filtroLeyenda(1.0), texto: filtroTextoLeyenda(1.0))
            }
            .padding(.vertical, 5)
            .background(fondoClaro)
            
            
            ZStack {
                Map(coordinateRegion: $region, annotationItems: zonas) { zona in
                    MapAnnotation(coordinate: zona.coordenada) {
                        ZStack {
                            Circle()
                                .fill(colorZona(zona))
                                .frame(width: tamanoCirculo(zona), height: tamanoCirculo(zona))
                                .opacity(0.7)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .opacity(zonaSeleccionada?.id == zona.id ? 1 : 0.3)
                                )
                            
                            Text(zona.nombre)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                        }
                        .onTapGesture {
                            zonaSeleccionada = zona
                            mostrarDetalles = true
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
               
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 15) {
                            Button(action: {
                                zoomIn()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(marino)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            }
                            
                            Button(action: {
                                zoomOut()
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(marino)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            }
                        }
                        .padding()
                    }
                }
            }
            
    
            Button(action: {
                navigationPath = NavigationPath()
            }) {
                Text("Continuar")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(marino)
                    .cornerRadius(40)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
            }
        }
        .background(fondoClaro)
        .sheet(isPresented: $mostrarDetalles) {
            if let zona = zonaSeleccionada {
                detalleZonaView(zona)
            }
        }
    }
    
    
    func detalleZonaView(_ zona: Zona) -> some View {
        VStack(alignment: .leading, spacing: 15) {
     
            HStack {
                VStack(alignment: .leading) {
                    Text(zona.nombre)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(marino)
                    
                    Text(zona.recomendacion)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(zona.color)
                }
                Spacer()
                
               
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(zona.potencialMercado) / 50000, 1.0))
                        .stroke(zona.color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(Int(min(zona.potencialMercado / 500, 100)))%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(zona.color)
                    }
                }
                .padding(.leading)
            }
            .padding(.bottom, 5)
            
            Divider()
            
         
            VStack(alignment: .leading, spacing: 12) {
                estadisticaRow(titulo: "Población", valor: "\(formatNumber(zona.poblacion)) habitantes", icono: "person.2.fill")
                estadisticaRow(titulo: "Ingresos promedio", valor: "$\(formatNumber(Int(zona.ingresosPromedio))) MXN", icono: "dollarsign.circle.fill")
                estadisticaRow(titulo: "Tiendas de mascotas", valor: "\(zona.tiendasMascotas)", icono: "storefront.fill")
                estadisticaRow(titulo: "Mascotas estimadas", valor: "\(formatNumber(zona.mascotas))", icono: "pawprint.fill")
                estadisticaRow(titulo: "Densidad de mascotas", valor: "\(String(format: "%.1f", Double(zona.mascotas) / Double(zona.poblacion) * 100))%", icono: "chart.bar.fill")
                estadisticaRow(titulo: "Tráfico comercial", valor: "\(zona.traficoComercial)/100", icono: "figure.walk")
            }
            
            Divider()
            

            Text("Análisis de mercado")
                .font(.headline)
                .foregroundColor(marino)
                .padding(.top, 5)
            
            Text(analisisMercado(zona))
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
        
            Button(action: {
                mostrarDetalles = false
            }) {
                Text("Cerrar")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(marino)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(fondoClaro)
    }
    

    func estadisticaRow(titulo: String, valor: String, icono: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icono)
                .font(.system(size: 18))
                .foregroundColor(marino)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(titulo)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                Text(valor)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
    }
    
    
    func leyendaItem(color: Color, texto: String) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(texto)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
    

    func filtroLeyenda(_ nivel: Double) -> Color {
        switch filtroSeleccionado {
        case .potencial:
            return Color(red: 0.8 * nivel + 0.2 * (1-nivel),
                         green: 0.8 * (1-nivel),
                         blue: 0.1 * (1-nivel))
        case .poblacion:
            return Color(red: 0.2 + 0.8 * nivel,
                         green: 0.6 - 0.4 * nivel,
                         blue: 0.8 - 0.8 * nivel)
        case .ingresos:
            return Color(red: 0.2 + 0.6 * nivel,
                         green: 0.2 + 0.8 * nivel,
                         blue: 0.8 - 0.6 * nivel)
        case .competencia:
            return Color(red: 0.2 + 0.8 * nivel,
                         green: 0.8 - 0.6 * nivel,
                         blue: 0.2)
        }
    }
    
   
    func filtroTextoLeyenda(_ nivel: Double) -> String {
        switch filtroSeleccionado {
        case .potencial:
            if nivel < 0.25 { return "Bajo" }
            else if nivel < 0.5 { return "Medio" }
            else if nivel < 0.75 { return "Alto" }
            else { return "Excelente" }
        case .poblacion:
            if nivel < 0.25 { return "< 200K" }
            else if nivel < 0.5 { return "200K-500K" }
            else if nivel < 0.75 { return "500K-1M" }
            else { return "> 1M" }
        case .ingresos:
            if nivel < 0.25 { return "< 20K" }
            else if nivel < 0.5 { return "20K-30K" }
            else if nivel < 0.75 { return "30K-40K" }
            else { return "> 40K" }
        case .competencia:
            if nivel < 0.25 { return "Baja" }
            else if nivel < 0.5 { return "Media" }
            else if nivel < 0.75 { return "Alta" }
            else { return "Saturada" }
        }
    }

    func analisisMercado(_ zona: Zona) -> String {
        var analisis = ""
        
        if zona.potencialMercado > 40000 {
            analisis = "Esta zona representa una excelente oportunidad para una tienda de mascotas. Cuenta con una alta densidad poblacional, buen nivel adquisitivo y una demanda significativa no cubierta por la competencia actual."
        } else if zona.potencialMercado > 30000 {
            analisis = "Esta zona muestra un potencial muy bueno para una tienda de mascotas. La relación entre población, ingresos y competencia actual crea un ambiente favorable para un nuevo negocio."
        } else if zona.potencialMercado > 20000 {
            analisis = "Esta zona presenta un potencial moderado para una tienda de mascotas. Se recomienda analizar ubicaciones específicas dentro de la zona para maximizar el alcance."
        } else if zona.potencialMercado > 10000 {
            analisis = "Esta zona tiene un potencial limitado. Podría funcionar con un modelo de negocio especializado o diferenciado, pero el mercado general no es tan atractivo."
        } else {
            analisis = "Esta zona presenta desafíos significativos para un negocio de mascotas. Los indicadores clave no son favorables, y se recomienda buscar otras ubicaciones."
        }
        

        if zona.ingresosPromedio > 35000 {
            analisis += " El alto nivel adquisitivo sugiere oportunidad para productos premium y servicios especializados."
        }
        
        if zona.mascotas > 100000 {
            analisis += " La gran cantidad de mascotas en la zona garantiza una base de clientes sólida."
        }
        
        if zona.tiendasMascotas < 5 {
            analisis += " La baja competencia actual representa una ventaja competitiva importante."
        } else if zona.tiendasMascotas > 20 {
            analisis += " Considere la alta densidad de competidores y busque diferenciación clara."
        }
        
        return analisis
    }
    

    func zoomIn() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: region.span.latitudeDelta * 0.7,
            longitudeDelta: region.span.longitudeDelta * 0.7
        )
        region.span = newSpan
    }
    
    func zoomOut() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: region.span.latitudeDelta * 1.3,
            longitudeDelta: region.span.longitudeDelta * 1.3
        )
        region.span = newSpan
    }
    

    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct MapaOportunidadesView_Previews: PreviewProvider {
    static var previews: some View {
        MapaOportunidadesView(navigationPath: .constant(NavigationPath()))
    }
}
