//
//  AddBookView.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//
import SwiftUI
import Firebase

struct AddBookView: View {
    @ObservedObject var booksViewModel = BooksViewModel() // Utiliser le ViewModel pour les types
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var selectedType: String?
    @State private var showAlert = false

    var body: some View {
        Form {
            Section(header: Text("Informations sur le livre")) {
                TextField("Titre", text: $title)
                TextField("Auteur", text: $author)
                Picker("Type", selection: $selectedType) {
                    ForEach(booksViewModel.types, id: \.self) { type in
                        Text(type).tag(type as String?)
                    }
                }
            }
            Button("Ajouter le livre") {
                addBookToFirestore(title: title, author: author, type: selectedType)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Succès"),
                message: Text("Le livre a été ajouté avec succès."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear() {
            booksViewModel.fetchTypes() // Charger les types lors de l'apparition de la vue
        }
    }
    
    func addBookToFirestore(title: String, author: String, type: String?) {
        let db = Firestore.firestore()
        let typeRef = db.collection("types").document(type ?? "defaultType") // Assurez-vous que "defaultType" existe ou gérez le cas où il n'y a pas de type sélectionné

        db.collection("books").addDocument(data: [
            "title": title,
            "author": author,
            "typeId": typeRef  // Utiliser une référence au document du type
        ]) { err in
            if let err = err {
                print("Erreur lors de l'ajout du document: \(err)")
            } else {
                print("Document ajouté avec succès")
                self.showAlert = true
            }
        }
    }
}

#Preview {
    AddBookView()
}
