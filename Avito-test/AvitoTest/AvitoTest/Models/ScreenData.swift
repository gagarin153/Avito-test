import Foundation

struct List: Codable {
    
    struct Icon: Codable {
        let iconURL: String
        
        private  enum CodingKeys: String, CodingKey {
            case iconURL  = "52x52"
        }
    }
    
    let title: String
    let description: String?
    let icon: Icon
    let price: String
}

struct ScreenDataResult: Codable {
    
    let title: String
    let selectedActionTitle: String
    let list: [List]
}

struct ScreenData: Codable {
    let result: ScreenDataResult
}
