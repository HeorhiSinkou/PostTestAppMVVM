//
//  MockedPersistentStore.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import CoreData
import Combine
@testable import PostAppMVVM

final class MockedPersistentStore: Mock, PersistentStore {
    struct ContextSnapshot: Equatable {
        let inserted: Int
        let updated: Int
        let deleted: Int
    }
    enum Action: Equatable {
        case count
        case fetchPost(ContextSnapshot)
        case update(ContextSnapshot)
    }
    var actions = MockActions<Action>(expected: [])

    var countResult: Int = 0

    deinit {
        destroyDatabase()
    }

    // MARK: - count

    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
        register(.count)
        return Just<Int>.withErrorType(countResult, Error.self).publish()
    }

    // MARK: - fetch

    func fetch<T, V>(
        _ fetchRequest: NSFetchRequest<T>,
        map: @escaping (T) throws -> V?
    ) -> AnyPublisher<LazyList<V>, Error> {
        do {
            let context = container.viewContext
            context.reset()
            let result = try context.fetch(fetchRequest)
            if T.self is FullPostMO.Type {
                register(.fetchPost(context.snapshot))
            } else {
                fatalError("Add a case for \(String(describing: T.self))")
            }
            let list = LazyList<V>(count: result.count, useCache: true, { index in
                try map(result[index])
            })
            return Just<LazyList<V>>.withErrorType(list, Error.self).publish()
        } catch {
            return Fail<LazyList<V>, Error>(error: error).publish()
        }
    }

    func fetchSingle<T, V>(
        _ fetchRequest: NSFetchRequest<T>,
        map: @escaping (T) throws -> V?
    ) -> AnyPublisher<V, Error> where T : NSFetchRequestResult {
        do {
            let context = container.viewContext
            context.reset()
            let result = try context.fetch(fetchRequest)
            if T.self is FullPostMO.Type {
                register(.fetchPost(context.snapshot))
            } else {
                fatalError("Add a case for \(String(describing: T.self))")
            }
            let list = LazyList<V>(count: result.count, useCache: true, { index in
                try map(result[index])
            })
            let object = try list.get(at: 0)
            return Just<V>.withErrorType(object, Error.self).publish()
        } catch {
            return Fail<V, Error>(error: error).publish()
        }
    }

    // MARK: - update

    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        do {
            let context = container.viewContext
            context.reset()
            let result = try operation(context)
            register(.update(context.snapshot))
            return Just(result).setFailureType(to: Error.self).publish()
        } catch {
            return Fail<Result, Error>(error: error).publish()
        }
    }

    // MARK: -

    func preloadData(_ preload: (NSManagedObjectContext) throws -> Void) throws {
        try preload(container.viewContext)
        if container.viewContext.hasChanges {
            try container.viewContext.save()
        }
        container.viewContext.reset()
    }

    // MARK: - Database

    private let dbVersion = CoreDataStack.Version(CoreDataStack.Version.actual)

    private var dbURL: URL {
        guard let url = dbVersion.dbFileURL(.cachesDirectory, .userDomainMask)
            else { fatalError() }
        return url
    }

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dbVersion.modelName)
        try? FileManager().removeItem(at: dbURL)
        let store = NSPersistentStoreDescription(url: dbURL)
        container.persistentStoreDescriptions = [store]
        let group = DispatchGroup()
        group.enter()
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("\(error)")
            }
            group.leave()
        }
        group.wait()
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.viewContext.undoManager = nil
        return container
    }()

    private func destroyDatabase() {
        try? container.persistentStoreCoordinator
            .destroyPersistentStore(at: dbURL, ofType: NSSQLiteStoreType, options: nil)
        try? FileManager().removeItem(at: dbURL)
    }
}

extension NSManagedObjectContext {
    var snapshot: MockedPersistentStore.ContextSnapshot {
        .init(inserted: insertedObjects.count,
              updated: updatedObjects.count,
              deleted: deletedObjects.count)
    }
}

