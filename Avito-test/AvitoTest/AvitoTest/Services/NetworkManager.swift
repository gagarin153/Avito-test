import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    
    private init() {}
    
    func fetchScreenData(completion: @escaping (Result<ScreenData, Error>) -> ()) {
        let urlString = URLS.resultJsonURL.rawValue
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let screenData = try decoder.decode(ScreenData.self, from: data)
                completion(.success(screenData))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
        
    }
}
