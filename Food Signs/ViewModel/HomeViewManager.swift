import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewManager: ObservableObject {
    @Published var screens: [Screen] = []
    @Published var screen: String = "Austin"
    private var changes: [String: Any] = [:]
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var user: String = "rfx14"
    
    func uploadChanges() {
        db.collection("users").document(user).updateData([
            "screens.\(screen)": screens
        ])
    }
    
    func fetchAvailableScreens(completion: @escaping(() -> Void)) {
        print("Fetching!!")
        db.collection("users").document(user).getDocument { [self] docSnapshot, err in
            guard let doc = docSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            
            guard let data = doc.data() else {
                print("Error fetching data: \(err!)")
                return
            }
            
            let screens = data["screens"] as? [String: Any] ?? [:]
            
            for (name, item) in screens {
                let item = item as? [String: Any] ?? [:]
                var items: [BasicItem] = []
                for (title, details) in item {
                    let details = details as? [String: Any] ?? [:]
                    let price = details["price"] as? String ?? ""
                    let description = details["description"] as? String ?? ""
                    let position = details["position"] as? Int ?? 0
                    
                    items.append(.init(title: title, price: price, description: description, position: position))
                }
                
                self.screens.append(Screen(name: name, items: items))
            }
            completion()
        }
    }
}
