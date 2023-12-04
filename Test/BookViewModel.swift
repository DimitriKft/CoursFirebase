//
//  BookViewModel.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//

import SwiftUI
import Firebase

class BooksViewModel: ObservableObject {
    @Published var books = [Book]()
    @Published var types = [String]()
    private var listener: ListenerRegistration?

    func fetchBooks() {
        let db = Firestore.firestore()
        
       
        if listener != nil { return }
        
        listener = db.collection("books").addSnapshotListener { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Erreur lors de l'écoute des changements: \(err?.localizedDescription ?? "Unknown error")")
                return
            }

            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    let typeRef = data["typeId"] as? DocumentReference
                    let documentId = diff.document.documentID
              
                    guard !self.books.contains(where: { $0.id == documentId }) else { return }
                    
                    typeRef?.getDocument { (typeSnapshot, typeErr) in
                        if let typeData = typeSnapshot?.data() {
                            let typeTitle = typeData["title"] as? String ?? ""
                            let newBook = Book(id: documentId,
                                               title: data["title"] as? String ?? "No Title",
                                               typeTitle: typeTitle)
                            DispatchQueue.main.async {
                                self.books.append(newBook)
                            }
                        }
                    }
                }
                if (diff.type == .removed) {
                    if let index = self.books.firstIndex(where: { $0.id == diff.document.documentID }) {
                        DispatchQueue.main.async {
                            self.books.remove(at: index)
                        }
                    }
                }
   
            }
        }
    }

    func fetchTypes() {
        let db = Firestore.firestore()
        db.collection("types").getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Erreur lors de la récupération des types: \(err)")
            } else {
                var newTypes = [String]()
                for document in querySnapshot!.documents {
                    if let typeTitle = document.data()["title"] as? String {
                        newTypes.append(typeTitle)
                    }
                }
                DispatchQueue.main.async {
                    self?.types = newTypes
                }
            }
        }
    }


    func detachListener() {
        listener?.remove()
        listener = nil
    }
}
