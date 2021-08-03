//
//  BaseViewModel.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import SwiftUI

class BaseViewModel<State, Event>: ObservableObject {
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    @Published private(set) var state: State

    init(
        state: State
    ) {
        self.state = state
        Publishers.system(
            initial: state,
            reduce: self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.whenLoading(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }

    deinit {
        bag.removeAll()
    }

    func reduce(
        _ state: State,
        _ event: Event
    ) -> State {
        fatalError("func should be override")
    }

    func userInput(
        input: AnyPublisher<Event, Never>
    ) -> Feedback<State, Event> {
        Feedback { _ in input }
    }

    func whenLoading() -> Feedback<State, Event> {
        fatalError("func should be override")
    }

    func send(event: Event) {
        input.send(event)
    }
}

