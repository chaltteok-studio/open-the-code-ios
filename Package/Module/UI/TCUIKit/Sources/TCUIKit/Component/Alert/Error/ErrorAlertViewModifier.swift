//
//  ErrorAlertViewModifier.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import SwiftUI
import Combine
import API
import ChapssalKit

struct ErrorAlertViewModifier: ViewModifier {
    // MARK: - Property
    private let publisher: AnyPublisher<any Error, Never>

    // MARK: - Initializer
    init<P: Publisher>(_ publisher: P) where P.Output == any Error, P.Failure == Never {
        self.publisher = publisher.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle
    func body(content: Content) -> some View {
        content.alert(publisher) { error, dismiss in
            handle(error, dismiss: dismiss)
        }
    }

    // MARK: - Public

    // MARK: - Private
    private func handle(_ error: any Error, dismiss: @escaping ((() -> Void)?) -> Void) -> some View {
        switch error {
        case let error as CSError where error.code == .CS99999:
            return TCAlert(
                TR.Localization.errorLimitAPICallTitle,
                description: TR.Localization.errorLimitAPICallDescription
            ) {
                TCAlertAction(
                    TR.Localization.errorAlertActionConfirmTitle
                ) {
                    dismiss(nil)
                }
            }
            
        case let error as ErrorAlertRepresentable:
            return TCAlert(
                error.title ?? TR.Localization.errorAlertTitle,
                description: error.description ?? TR.Localization.errorAlertDescription
            ) {
                TCAlertAction(
                    TR.Localization.errorAlertActionConfirmTitle
                ) {
                    dismiss(nil)
                }
            }
            
        default:
            return TCAlert(
                TR.Localization.errorAlertTitle,
                description: TR.Localization.errorAlertDescription
            ) {
                TCAlertAction(
                    TR.Localization.errorAlertActionConfirmTitle
                ) {
                    dismiss(nil)
                }
            }
        }
    }
}

public extension View {
    func error<P: Publisher>(_ publisher: P) -> some View where P.Output == any Error, P.Failure == Never {
        modifier(ErrorAlertViewModifier(publisher))
    }
}

#if DEBUG
struct TestError: Error { }

struct ErrorAlertViewModifier_Preview: View {
    var body: some View {
        ZStack {
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
            
            Button("Show Alert") {
                isTest.toggle()
                error.send(isTest ? TestError() : NSError(domain: "NSError", code: 0))
            }
                .buttonStyle(.borderedProminent)
        }
            .error(error)
    }
    
    @State
    var isTest = false
    
    let error = PassthroughSubject<any Error, Never>()
}

struct ErrorAlertViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        ErrorAlertViewModifier_Preview()
    }
}
#endif
