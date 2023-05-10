//
//  MyCodesViewController.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Feature
import CodeService
import Room

public protocol MyCodesControllerDelegate: AnyObject {
    func back()
}

public protocol MyCodesControllable: UIViewControllable {
    var delegate: (any MyCodesControllerDelegate)? { get set }
}

final class MyCodesViewController: ComposableController, MyCodesControllable {
    final private class Environment: ObservableObject {
        
    }

    // MARK: - Property
    private let router: any MyCodesRoutable
    weak var delegate: (any MyCodesControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any MyCodesRoutable,
        reducer: Reducer<MyCodesViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                codes: reducer.state.codes,
                isLoading: reducer.state.isLoading,
                onBackTap: {
                    self?.delegate?.back()
                },
                onCodeTap: { code in
                    self?.presentRoom(animated: true, code: code)
                }
            )
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
                .onAppear {
                    reducer.action(.load)
                }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    private func presentRoom(
        animated: Bool,
        force: Bool = true,
        code: Code,
        completion: ((RoomControllable) -> Void)? = nil
    ) {
        let room = router.routeToRoom(with: .init(
            code: code
        ))
        
        room.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(room, animated: animated)
        }
    }
}

extension MyCodesViewController: RoomControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    codes: [Code]?,
    isLoading: Bool,
    onBackTap: @escaping () -> Void,
    onCodeTap: @escaping (Code) -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: TR.Localization.myCodesTitle,
            onBackTap: onBackTap
        )
        
        if !isLoading {
            if let codes, !codes.isEmpty {
                Menus {
                    MenuSection {
                        codes.map { code in
                            Menu(
                                code.code,
                                description: code.createdAt.formatted("yy.MM.dd")
                            ) {
                                onCodeTap(code)
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
        } else {
            LoadingView()
        }
    }
        .background(
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
        )
}

@ViewBuilder
private func NavigationBar(
    title: String?,
    onBackTap: @escaping () -> Void
) -> some View {
    CSUNavigationBar(title ?? "", alignment: .leading)
        .csuNavigationBar(\.style, .tcNavigationBar)
        .csuNavigationBar(
            \.leftAccessories,
             [
                CSUButton(image: Image(uiImage: CR.Icon.ic24Back)) {
                    onBackTap()
                }
                    .csuButton(\.style, .tcPlain)
                    .fixedSize()
             ]
        )
        .fixedSize(horizontal: false, vertical: true)
}

@ViewBuilder
private func LoadingView() -> some View {
    VStack {
        HStack {
            CodeDecryptionView()
                .font(Font(TR.Font.font(ofSize: 18)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
            Spacer()
        }
            .padding(20)
        
        Spacer()
    }
}

@ViewBuilder
private func EmptyView() -> some View {
    GeometryReader { reader in
        VStack {
            TCUIKit.EmptyView()
                .offset(y: -reader.size.height * 0.1)
        }
            .frame(
                width: reader.size.width,
                height: reader.size.height
            )
    }
}

#if DEBUG
class MyCodesMockRouter: MyCodesRoutable {
    final private class Room: ComposableController, RoomControllable {
        weak var delegate: (RoomControllerDelegate)?
    }
    
    func routeToRoom(with parameter: RoomParameter) -> RoomControllable {
        Room {
            Text("Room")
        }
    }
}

struct MyCodes_Preview: View {
    var body: some View {
        MyCodesViewController(
            router: MyCodesMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(
                    isLoading: false
                )
            ))
        )
            .rootView
    }
}

struct MyCodes_Previews: PreviewProvider {
    static var previews: some View {
        MyCodes_Preview()
    }
}
#endif
