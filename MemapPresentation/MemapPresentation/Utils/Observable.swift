//
//  Observable.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 14/03/2026.
//


public final class Observable<T> {

    private struct Observer {
        weak var owner: AnyObject?
        let block: (T) -> Void
    }

    private var observers: [Observer] = []

    var value: T {
        didSet {
            notify()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func observe(owner: AnyObject, _ block: @escaping (T) -> Void) {
        observers.append(Observer(owner: owner, block: block))
        block(value)
    }

    private func notify() {
        observers = observers.filter { $0.owner != nil }
        observers.forEach { $0.block(value) }
    }
    
}
