//
//  AddBookView.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//

import SwiftUI
import Firebase

struct AddBookView: View {
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var showAlert = false  // Variable d'état pour l'alerte

    var body: some View {
        Form {
            Section(header: Text("Informations sur le livre")) {
                TextField("Titre", text: $title)
                TextField("Auteur", text: $author)
            }
            Button("Ajouter le livre") {
                addBookToFirestore(title: title, author: author)
            }
        }
        .alert(isPresented: $showAlert) {  // Affichage de l'alerte
            Alert(
                title: Text("Succès"),
                message: Text("Le livre a été ajouté avec succès."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func addBookToFirestore(title: String, author: String) {
        let db = Firestore.firestore()
        db.collection("books").addDocument(data: [
            "title": title,
            "author": author
        ]) { err in
            if let err = err {
                print("Erreur lors de l'ajout du document: \(err)")
            } else {
                print("Document ajouté avec succès")
                self.showAlert = true  // Mettre à jour la variable pour afficher l'alerte
            }
        }
    }
}


#Preview {
    AddBookView()
}
