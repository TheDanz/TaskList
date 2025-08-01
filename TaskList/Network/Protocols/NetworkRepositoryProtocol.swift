protocol NetworkRepositoryProtocol {
    func fetchTasks() async throws -> TasksResponse
}
