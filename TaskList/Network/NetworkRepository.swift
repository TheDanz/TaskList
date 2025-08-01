class NetworkRepository: NetworkRepositoryProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchTasks() async throws -> TasksResponse {
        return try await networkService.fetchTasks()
    }
}
