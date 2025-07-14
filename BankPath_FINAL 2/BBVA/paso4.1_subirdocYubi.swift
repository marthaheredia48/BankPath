import SwiftUI
import VisionKit


struct DocumentScannerView: UIViewControllerRepresentable {
    var documentKey: String
    @Binding var documentImages: [String: UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            defer { parent.presentationMode.wrappedValue.dismiss() }
            guard scan.pageCount > 0 else { return }
            let image = scan.imageOfPage(at: 0)
            parent.documentImages[parent.documentKey] = image
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct segundo: View {
    @Binding var navigationPath: NavigationPath


    enum PersonType: String, CaseIterable, Identifiable {
        case physical = "Persona Física"
        case moral = "Persona Moral"
        var id: String { rawValue }
    }
    
    @State private var selectedType: PersonType = .physical
    @State private var documentStates: [String: Bool] = [:]
    @State private var documentImages: [String: UIImage] = [:]
    @State private var scanningDoc: String? = nil
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
               
                Section(header: Text("¿Qué tipo de negocio eres?")) {
                    Picker("Tipo de persona", selection: $selectedType) {
                        ForEach(PersonType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
      
                Section(header: Text("Documentos necesarios")) {
                    ForEach(requiredDocuments(for: selectedType), id: \.self) { doc in
                        HStack {
                            Text(doc)
                            Spacer()
                            Image(systemName: documentStates[doc] == true ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(documentStates[doc] == true ? .green : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            scanningDoc = doc
                        }
                        .padding(.vertical, 4)
                    }
                }
                
 
                Button(action: uploadDocuments) {
                    Text("Subir documentos")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.navy)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical)
            }
            .navigationTitle("Verifica tu negocio")
            .sheet(item: $scanningDoc) { doc in
                DocumentScannerView(documentKey: doc, documentImages: $documentImages)
                    .onDisappear {
                        documentStates[doc] = documentImages[doc] != nil
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("¡Espera!"), message: Text(alertMessage), dismissButton: .default(Text("Entendido")))
            }
        }
    }
    
  
    func requiredDocuments(for type: PersonType) -> [String] {
        switch type {
        case .physical:
            return [
                "Credencial de elector o pasaporte vigente",
                "Comprobante de domicilio fiscal y operativo ≤ 3 meses",
                "Constancia de situación fiscal (SAT)",
                "Número de celular vigente",
                "Constancia de Firma Electrónica Avanzada (e.firma)"
            ]
        case .moral:
            return [
                "Formato de Autodeclaratoria",
                "Acta constitutiva con sello RPP y C (o contrato social SAS firmado por Secretaría de Economía)",
                "Poder de representantes legales con sello notarial",
                "Constancia de situación fiscal (SAT)",
                "Número de celular vigente",
                "Credencial de elector o pasaporte vigente de apoderados",
                "Constancia de Firma Electrónica Avanzada (e.firma)",
                "Comprobante de domicilio fiscal y operativo ≤ 3 meses"
            ]
        }
    }
    
    func uploadDocuments() {
        let missing = requiredDocuments(for: selectedType).filter { documentStates[$0] != true }
        if !missing.isEmpty {
            alertMessage = "Por favor, escanea todos los documentos requeridos."
            showAlert = true
        } else {
            alertMessage = "Documentos subidos con éxito. ¡Estamos revisándolos!"
            showAlert = true
            navigationPath.append("paso4.2")

        }
    }
}


struct segundoView_Previews: PreviewProvider {
    static var previews: some View {
        segundo(navigationPath: .constant(NavigationPath()))
    }
}
