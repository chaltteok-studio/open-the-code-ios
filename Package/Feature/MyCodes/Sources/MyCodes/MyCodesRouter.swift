//
//  MyCodesRouter.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import RVB
import Room

protocol MyCodesRoutable: Routable {
    func routeToRoom(with parameter: RoomParameter) -> any RoomControllable
}

final class MyCodesRouter: MyCodesRoutable {
    // MARK: - Property
    private let roomBuilder: any RoomBuildable
    
    // MARK: - Initializer
    init(roomBuilder: any RoomBuildable) {
        self.roomBuilder = roomBuilder
    }
    
    // MARK: - Public
    func routeToRoom(with parameter: RoomParameter) -> any RoomControllable {
        roomBuilder.build(with: parameter)
    }

    // MARK: - Private
}
