class NetworkService: BaseNetworkService<TasksRouter>, NetworkServiceProtocol {
    
    func fetchTasks() async throws -> TasksResponse {
        return try await request(TasksResponse.self, router: .fetch)
    }
}
