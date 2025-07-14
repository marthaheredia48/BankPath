

import SwiftUI
import CoreLocation
import AVKit
import PhotosUI
import AVFoundation


extension Color {
    static let navy = Color(red: 0/255, green: 51/255, blue: 102/255)
    static let navyLight = Color(red: 0/255, green: 51/255, blue: 102/255).opacity(0.8)
    static let navyLighter = Color(red: 0/255, green: 51/255, blue: 102/255).opacity(0.6)
}


struct tercero: View {
    @StateObject private var locationManager = LocationManager()
    @State private var locationOK = false
    @State private var addressString: String = "..."
    @State private var photos: [UIImage] = []
    @State private var videoKYC: URL?
    @State private var showingDefinition: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var pickerType: PickerType?
    @State private var photoIndex = 0
    @Binding var navigationPath: NavigationPath


    enum PickerType: Identifiable {
        case image, video
        var id: Int { hashValue }
    }

    var body: some View {
        NavigationView {
            Form {
         
                Section(header: Text("Confirma tu ubicación").foregroundColor(.navy).font(.headline)) {
                    HStack {
                        Toggle("¿Estás en el lugar correcto?", isOn: $locationOK)
                            .foregroundColor(.navyLight)
                        Button { showingDefinition = "geolocalizacion" } label: {
                            Image(systemName: "info.circle").foregroundColor(.navy)
                        }
                    }
                    if locationManager.isLocationAuthorized {
                        Text("Ubicación detectada: \(locationManager.formattedLocation)")
                            .foregroundColor(.navyLight)
                        Text("Dirección: \(addressString)")
                            .foregroundColor(.navyLight)
                    } else {
                        Button("Permitir acceso a ubicación") {
                            locationManager.requestLocationPermission()
                        }
                        .foregroundColor(.navy)
                    }
                }

     
                Section(header: Text("Toma 3 fotos del lugar").foregroundColor(.navy).font(.headline)) {
                    ForEach(0..<3, id: \.self) { idx in
                        HStack {
                            Text("Foto \(idx+1)").foregroundColor(.navyLight)
                            Spacer()
                            if idx < photos.count {
                                Image(uiImage: photos[idx])
                                    .resizable().scaledToFit().frame(width: 50, height: 50)
                            }
                            Button(idx < photos.count ? "Reemplazar" : "Tomar") {
                                photoIndex = idx
                                checkCameraPermission { granted in
                                    if granted { pickerType = .image }
                                    else { showPermissionAlert("cámara") }
                                }
                            }
                            .foregroundColor(.navy)
                        }
                    }
                }

         
                Section(header: Text("Video del lugar").foregroundColor(.navy).font(.headline)) {
                    HStack {
                        Text(videoKYC == nil ? "Grabar video" : "Regrabar video").foregroundColor(.navyLight)
                        Spacer()
                        if videoKYC != nil {
                            Text("Video listo").foregroundColor(.navyLight)
                        }
                        Button { showingDefinition = "video_kyc" } label: {
                            Image(systemName: "info.circle").foregroundColor(.navy)
                        }
                        Button(videoKYC == nil ? "Grabar" : "Regrabar") {
                            checkCameraPermission { camGranted in
                                checkMicrophonePermission { micGranted in
                                    if camGranted && micGranted { pickerType = .video }
                                    else { showPermissionAlert("cámara y micrófono") }
                                }
                            }
                        }
                        .foregroundColor(.navy)
                    }
                }

             
                Button("Enviar verificación") {
                    submitVerification()
                }
                .frame(maxWidth: .infinity).padding()
                .background(Color.navy).foregroundColor(.white)
                .cornerRadius(8).padding(.vertical)
            }
            .navigationTitle("Confirma tu dirección")
            .sheet(item: $pickerType) { type in
                if type == .image {
                    PhotoPicker(
                        sourceType: .camera,
                        mediaType: .image,
                        selectedImage: Binding(
                            get: { photoIndex < photos.count ? photos[photoIndex] : nil },
                            set: { img in
                                if let img = img {
                                    if photoIndex < photos.count { photos[photoIndex] = img }
                                    else { photos.append(img) }
                                }
                            }
                        ),
                        selectedVideo: .constant(nil)
                    )
                } else {
                    PhotoPicker(
                        sourceType: .camera,
                        mediaType: .video,
                        selectedImage: .constant(nil),
                        selectedVideo: $videoKYC
                    )
                }
            }
            .sheet(item: $showingDefinition) { DefinitionView(term: $0) }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("¡Espera!"), message: Text(alertMessage), dismissButton: .default(Text("Entendido")))
            }
            .onReceive(locationManager.$lastLocation) { loc in
                if let coord = loc?.coordinate { reverseGeocode(coord) }
            }
            .onAppear { locationManager.requestLocationPermission() }
        }
    }


    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        CLGeocoder().reverseGeocodeLocation(
            CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        ) { places, _ in
            if let place = places?.first {
                addressString = [place.thoroughfare, place.locality, place.administrativeArea]
                    .compactMap { $0 }.joined(separator: ", ")
            }
        }
    }



    private func checkCameraPermission(_ completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    private func checkMicrophonePermission(_ completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    private func showPermissionAlert(_ svc: String) {
        alertMessage = "Necesitamos permiso para acceder a la \(svc). Ve a Configuración > Privacidad para habilitarlo."
        showAlert = true
    }

    private func submitVerification() {
        guard locationOK else { showSimpleAlert("Confirma tu ubicación."); return }
        guard photos.count == 3 else { showSimpleAlert("Toma las 3 fotos requeridas."); return }
        guard videoKYC != nil else { showSimpleAlert("Graba el video de 30s."); return }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            showSimpleAlert("¡Verificación enviada! Revisaremos tus archivos.")
            locationOK = false; photos.removeAll(); videoKYC = nil
        navigationPath = NavigationPath()

        }
    }
    private func showSimpleAlert(_ msg: String) { alertMessage = msg; showAlert = true }
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var isLocationAuthorized = false
    @Published var formattedLocation = "Buscando..."
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        lastLocation = loc
        formattedLocation = String(format: "%.4f, %.4f", loc.coordinate.latitude, loc.coordinate.longitude)
        isLocationAuthorized = true
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isLocationAuthorized = [.authorizedWhenInUse, .authorizedAlways].contains(status)
        if !isLocationAuthorized { formattedLocation = "No tenemos permiso de ubicación." }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        formattedLocation = "Error: \(error.localizedDescription)"
        isLocationAuthorized = false
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    enum MediaType { case image, video }
    let sourceType: UIImagePickerController.SourceType
    let mediaType: MediaType
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideo: URL?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        if mediaType == .video { picker.mediaTypes = ["public.movie"]; picker.videoMaximumDuration = 30 }
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ ui: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoPicker
        init(_ parent: PhotoPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if parent.mediaType == .image, let img = info[.originalImage] as? UIImage {
                parent.selectedImage = img
            } else if parent.mediaType == .video, let url = info[.mediaURL] as? URL {
                parent.selectedVideo = url
            }
            picker.dismiss(animated: true)
        }
    }
}


struct DefinitionView: View {
    @Environment(\.dismiss) private var dismiss
    let term: String

    var body: some View {
        VStack(spacing: 20) {
            Text(title).font(.title2).fontWeight(.bold).foregroundColor(.navy)
            Text(message).foregroundColor(.navyLight).padding(.horizontal)
            Button("Entendido") { dismiss() }
                .frame(maxWidth: .infinity).padding()
                .background(Color.navyLighter).foregroundColor(.white).cornerRadius(8).padding(.horizontal)
        }
        .padding().background(Color.white).cornerRadius(12).shadow(radius: 5)
    }

    private var title: String {
        switch term {
        case "geolocalizacion": return "¿Qué es la Geolocalización?"
        case "foto_360": return "¿Cómo tomar las fotos?"
        case "video_kyc": return "¿Cómo grabar el video?"
        default: return term
        }
    }
    private var message: String {
        switch term {
        case "geolocalizacion": return "Usamos GPS para confirmar que estás en tu negocio."
        
        case "video_kyc": return "Graba un video de 30s mostrando tu negocio y presentándote."
        default: return ""
        }
    }
}


private func checkCameraPermission(_ completion: @escaping (Bool) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        completion(true)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    default:
        completion(false)
    }
}




struct terceroView_Previews: PreviewProvider {
    static var previews: some View {
        tercero(navigationPath: .constant(NavigationPath()))
    }
}
extension String: Identifiable {
    public var id: String { self }
}
