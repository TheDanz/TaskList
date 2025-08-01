import UIKit

protocol TaskListInteractor: AnyObject {
    init(_ presenter: TaskListPresenter)
    
    func fetchTasks() async
}

final class TaskListInteractorImpl: TaskListInteractor {
    
    weak var presenter: TaskListPresenter?
    
    private var networkRepository = NetworkRepository(networkService: NetworkService())
        
    required init(_ presenter: TaskListPresenter) {
        self.presenter = presenter
    }
    
    func fetchTasks() async {
        do {
            let response = try await networkRepository.fetchTasks()
            let entities = response.todos.map {
                TaskListEntityImpl(
                    title: String($0.id),
                    description: $0.todo,
                    creationDate: Date(),
                    isDone: $0.completed
                )
            }
            presenter?.didFetchTasks(entities)
        } catch {
            presenter?.didFetchTasks([])
        }
    }
}
