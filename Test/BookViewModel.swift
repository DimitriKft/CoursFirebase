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
    private var isDataFetched = false

    func fetchBooks() {
        guard !isDataFetched else { return }
        
        isDataFetched = true
        let db = Firestore.firestore()
        
        db.collection("books").getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self?.isDataFetched = false
            } else {
                var newBooks = [Book]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let typeRef = data["typeId"] as? DocumentReference
                    
                    typeRef?.getDocument { (typeSnapshot, typeErr) in
                        if let typeData = typeSnapshot?.data() {
                            let typeTitle = typeData["title"] as? String ?? ""
                            let newBook = Book(id: document.documentID,
                                               title: data["title"] as? String ?? "pas de cat",
                                               typeTitle: typeTitle)
                            newBooks.append(newBook)
                        }
                        
                        DispatchQueue.main.async {
                            self?.books = newBooks
                        }
                    }
                }
            }
        }
    }
}


