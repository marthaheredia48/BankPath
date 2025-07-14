

import SwiftUI
import VisionKit
import AVFoundation



enum Contribuyente1: String, CaseIterable, Identifiable {
    case fisica = "Persona Física"
    case moral  = "Persona Moral"
    var id: String { rawValue }
}

struct Documento1: Identifiable {
    let id = UUID()
    let nombre: String
}



struct DocumentScannerView1: UIViewControllerRepresentable {
    @Binding var scanned: [String: UIImage]
    let key: String
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView1
        init(_ parent: DocumentScannerView1) { self.parent = parent }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            parent.scanned[parent.key] = scan.imageOfPage(at: 0)
            parent.presentationMode.wrappedValue.dismiss()
        }
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



struct VideoPickerView1: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.videoMaximumDuration = 5
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: VideoPickerView1
        init(_ parent: VideoPickerView1) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



struct RFCRegistrationView1: View {
    private let marino = Color(red: 0/255, green: 51/255, blue: 102/255)
    @Binding var navigationPath: NavigationPath
    @State private var tipo: Contribuyente1 = .fisica
    @State private var documentosFisica: [Documento1] = [
        Documento1(nombre: "CURP o Cédula de Identidad Personal"),
        Documento1(nombre: "Identificación oficial vigente"),
        Documento1(nombre: "Comprobante de domicilio fiscal"),
        Documento1(nombre: "Acuse de preinscripción en el RFC"),
        Documento1(nombre: "Acta de nacimiento"),
        Documento1(nombre: "Documento migratorio vigente"),
        Documento1(nombre: "Poder notarial o carta poder")
    ]
    @State private var documentosMoral: [Documento1] = [
        Documento1(nombre: "Acta constitutiva"),
        Documento1(nombre: "Comprobante de domicilio fiscal de empresa"),
        Documento1(nombre: "Poder notarial representante"),
        Documento1(nombre: "ID representante legal"),
        Documento1(nombre: "Acuse preinscripción RFC"),
        Documento1(nombre: "RFC socios/accionistas")
    ]

    @State private var scannedDocs: [String: UIImage] = [:]
    @State private var scanKey: String? = nil
    @State private var videoURL: URL? = nil
    @State private var showVideoPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de contribuyente").foregroundColor(marino)) {
                    Picker("Tipo", selection: $tipo) {
                        ForEach(Contribuyente1.allCases) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accentColor(marino)
                }

                Section(header: Text("Escanea tus documentos").foregroundColor(marino)) {
                    let docs = tipo == .fisica ? documentosFisica : documentosMoral
                    ForEach(docs) { doc in
                        HStack {
                            Text(doc.nombre)
                                .font(.system(size: 16))
                            Spacer()
                            Image(systemName: scannedDocs[doc.nombre] != nil ? "checkmark.circle.fill" : "doc.text.viewfinder")
                                .foregroundColor(scannedDocs[doc.nombre] != nil ? .green : marino)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { scanKey = doc.nombre }
                    }
                }

                Section(header: Text("Video verificación").foregroundColor(marino)) {
                    Button(action: { showVideoPicker = true }) {
                        Text(videoURL == nil ? "Grabar video" : "Regrabar video")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(marino)
                            .cornerRadius(8)
                    }
                }

                Section {
                    Button(action: {                             navigationPath.append("SAT2")
 }) {
                        Text("Continuar")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(canContinue ? marino : Color.gray.opacity(0.4))
                            .cornerRadius(8)
                    }
                    .disabled(!canContinue)
                }
            }
            .navigationTitle(Text("Inscripción RFC").foregroundColor(marino))
            .accentColor(marino)
            .sheet(item: $scanKey) { key in
                DocumentScannerView1(scanned: $scannedDocs, key: key)
            }
            .sheet(isPresented: $showVideoPicker) {
                VideoPickerView1(videoURL: $videoURL)
            }
        }
    }

    private var canContinue: Bool {
        let names = (tipo == .fisica ? documentosFisica : documentosMoral).map { $0.nombre }
        return names.allSatisfy { scannedDocs[$0] != nil } && videoURL != nil
    }
}

struct RFCRegistrationView1_Previews: PreviewProvider {
    static var previews: some View {
        RFCRegistrationView1(navigationPath: .constant(NavigationPath()))
    }
}
