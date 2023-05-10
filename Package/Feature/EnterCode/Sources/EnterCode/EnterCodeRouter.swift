//
//  EnterCodeRouter.swift
//  
//
//  Created by JSilver on 2023/01/29.
//

import RVB
import Room

protocol EnterCodeRoutable: Routable {
    func routeToRoom(with paramter: RoomParameter) -> any RoomControllable
}

final class EnterCodeRouter: EnterCodeRoutable {
    // MARK: - Property
    private let roomBuilder: any RoomBuildable
    
    // MARK: - Initializer
    init(roomBuilder: any RoomBuildable) {
        self.roomBuilder = roomBuilder
    }
    
    // MARK: - Public
    func routeToRoom(with paramter: RoomParameter) -> any RoomControllable {
        roomBuilder.build(with: paramter)
    }
    
    // MARK: - Private
}
