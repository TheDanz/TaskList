import Foundation

enum TasksRouter: URLRequestConvertible {
    case fetch
    
    var endpoint: String {
        switch self {
        case .fetch:
            return "/todos"
        }
    }
    
    var method: String {
        switch self {
        case .fetch:
            return "GET"
        }
    }
    
    func makeURLRequest() throws -> URLRequest {
                
        switch self {
        case .fetch:
            
            guard let url = URL(string: DummiAPI.baseURL + endpoint) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            return request
        }
    }
}
