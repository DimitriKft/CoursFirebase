//
//  ContentView.swift
//  Test
//
//  Created by dimitri on 29/11/2023.
//

import SwiftUI
import Firebase

struct Book: Identifiable {
  var id: String
  var title: String
}

class BooksViewModel: ObservableObject {
  @Published var book: Book?

  func fetchBook() {
    let db = Firestore.firestore()
    db.collection("books").document("harryPotter").getDocument { (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        let title = data?["title"] as? String ?? ""
        self.book = Book(id: document.documentID, title: title)
      } else {
        print("Document does not exist")
      }
    }
  }
}

struct ContentView: View {
  @ObservedObject var viewModel = BooksViewModel()

  var body: some View {
    VStack {
      if let book = viewModel.book {
          Text(book.title)
      }
    }
    .onAppear {
      viewModel.fetchBook()
    }
  }
}


#Preview {
    ContentView()
}
