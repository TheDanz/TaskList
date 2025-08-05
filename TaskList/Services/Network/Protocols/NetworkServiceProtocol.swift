protocol NetworkServiceProtocol {
    func fetchTasks() async throws -> TasksResponse
}
