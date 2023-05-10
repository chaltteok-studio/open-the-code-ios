//
//  CreateCodeViewController.swift
//  
//
//  Created by JSilver on 2023/03/14.
//

import Feature

public protocol CreateCodeDelegate: AnyObject {
    func codeCreated()
}

public protocol CreateCodeControllable: UIViewControllable {
    var delegate: (any CreateCodeDelegate)? { get set }
}

final class CreateCodeViewController: ComposableController, CreateCodeControllable {
    final private class Environment: ObservableObject {
        @Published
        var code: String = ""
        @Published
        var codeFocused: Bool = false
        @Published
        var description: String = ""
        @Published
        var descriptionFocused: Bool = false
        @Published
        var agreesTerm: Bool = false
    }
    
    // MARK: - Property
    private let router: any CreateCodeRoutable
    var delegate: (any CreateCodeDelegate)?

    // MARK: - Initializer
    init(router: any CreateCodeRoutable, reducer: Reducer<CreateCodeViewReduce>) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                code: .object(env, path: \.code),
                codeFocused: .object(env, path: \.codeFocused),
                maxCodeCount: 30,
                description: .object(env, path: \.description),
                descriptionFocused: .object(env, path: \.descriptionFocused),
                maxDescriptionCount: 500,
                agreesTerm: .object(env, path: \.agreesTerm),
                isLoading: reducer.state.isLoading,
                onRandomCode: {
                    env.code = self?.generateCode() ?? ""
                },
                onCreateTap: {
                    reducer.action(.createCode(env.code, description: env.description))
                }
            )
                .alert(
                    reducer.$state.map(\.$codeCreated)
                        .removeDuplicates()
                        .compactMap(\.value)
                ) { _, dismiss in
                    TCAlert(
                        TR.Localization.createCodeCreatedAlertTitle,
                        description: TR.Localization.createCodeCreatedAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.errorAlertActionConfirmTitle) {
                            dismiss {
                                // Reset input fields.
                                env.code = ""
                                env.description = ""
                                env.agreesTerm = false
                                
                                // Send signal about the new code created.
                                self?.delegate?.codeCreated()
                            }
                        }
                    }
                }
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    private func generateCode() -> String {
        (0 ..< 30).compactMap { _ in Env.Constant.generateCodeSet.randomElement() }
            .joined()
    }
}

@ViewBuilder
private func Root(
    code: Binding<String>,
    codeFocused: Binding<Bool>,
    maxCodeCount: Int,
    description: Binding<String>,
    descriptionFocused: Binding<Bool>,
    maxDescriptionCount: Int,
    agreesTerm: Binding<Bool>,
    isLoading: Bool,
    onRandomCode: @escaping () -> Void,
    onCreateTap: @escaping () -> Void
) -> some View {
    KeyboardAvoidancingView {
        ScrollView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        codeFocused.wrappedValue = false
                        descriptionFocused.wrappedValue = false
                    }
                
                VStack(spacing: 24) {
                    Spacer(minLength: 24)
                    
                    CodeField(
                        code: code,
                        codeFocused: codeFocused,
                        maxCodeCount: maxCodeCount,
                        onRandomCode: onRandomCode
                    ) {
                        descriptionFocused.wrappedValue = true
                    }
                    
                    DescriptionField(
                        description: description,
                        descriptionFocused: descriptionFocused,
                        maxDescriptionCount: maxDescriptionCount
                    )
                    
                    TermView(
                        agreesTerm: agreesTerm
                    )
                    
                    CSUButton(title: TR.Localization.createCodeCreateButtonTitle) {
                        onCreateTap()
                    }
                        .csuButton(\.style, .tcFill)
                        .csuButton(\.isLoading, isLoading)
                        .disabled(code.wrappedValue.isEmpty || description.wrappedValue.isEmpty || !agreesTerm.wrappedValue)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 80)
                }
                    .padding(.horizontal, 20)
            }
        }
            .background(
                Color(uiColor: CR.Color.gray01)
                    .ignoresSafeArea()
            )
    }
        .ignoresSafeArea(.keyboard)
}

@ViewBuilder
private func CodeField(
    code: Binding<String>,
    codeFocused: Binding<Bool>,
    maxCodeCount: Int,
    onRandomCode: @escaping () -> Void,
    onCodeReturn: @escaping () -> Void
) -> some View {
    VStack(spacing: 10) {
        HStack(spacing: 4) {
            Image(uiImage: CR.Icon.ic16Password)
            
            Text(TR.Localization.createCodeCodeInputTitle)
                .font(Font(TR.Font.font(ofSize: 16)))
            
            Spacer()
            
            Text("\(code.wrappedValue.count)/\(maxCodeCount)")
                .font(Font(TR.Font.font(ofSize: 16)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
        }
            .foregroundColor(Color(uiColor: CR.Color.gray05))
        
        CSUTextField(
            TR.Localization.createCodeCodeInputPlaceholder,
            text: code
        )
            .csuTextField(\.style, .tcBoxInput())
            .csuTextField(\.validator, .init(.regex(Env.Constant.codeRegex(count: maxCodeCount))))
            .csuTextField(\.isEditing, codeFocused)
            .csuTextField(\.onReturn) {
                codeFocused.wrappedValue = false
                onCodeReturn()
            }
            .fixedSize(horizontal: false, vertical: true)
        
        HStack {
            CSUButton(title: TR.Localization.createCodeGenerateCodeButtonTitle) {
                onRandomCode()
            }
                .csuButton(\.style, .tcLine)
                .csuButton(\.font, Font(TR.Font.font(ofSize: 12)))
                .csuButton(\.contentInsets, .init(top: 7, leading: 14, bottom: 7, trailing: 14))
                .fixedSize()
            
            Spacer()
        }
    }
}

@ViewBuilder
private func DescriptionField(
    description: Binding<String>,
    descriptionFocused: Binding<Bool>,
    maxDescriptionCount: Int
) -> some View {
    VStack(spacing: 10) {
        HStack(spacing: 4) {
            Image(uiImage: CR.Icon.ic16Modify)
            
            Text(TR.Localization.createCodeDescriptionInputTitle)
                .font(Font(TR.Font.font(ofSize: 16)))
            
            Spacer()
            
            Text("\(description.wrappedValue.count)/\(maxDescriptionCount)")
                .font(Font(TR.Font.font(ofSize: 16)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
        }
            .foregroundColor(Color(uiColor: CR.Color.gray05))
        
        CSUTextView(
            TR.Localization.createCodeDescriptionInputPlaceholder,
            text: description
        )
            .csuTextView(\.style, .tcBoxArea)
            .csuTextView(\.validator, .init(.count(maxDescriptionCount, <=)))
            .csuTextView(\.isEditing, descriptionFocused)
            .frame(height: 200)
            .fixedSize(horizontal: false, vertical: true)
    }
}

@ViewBuilder
private func TermView(
    agreesTerm: Binding<Bool>
) -> some View {
    Button {
        agreesTerm.wrappedValue.toggle()
    } label: {
        HStack {
            VStack {
                Image(uiImage: agreesTerm.wrappedValue ? CR.Icon.ic24On : CR.Icon.ic24Off)
                Spacer()
            }
            Text(TR.Localization.createCodeCreateTermTitle)
                .padding(.vertical, 2)
            Spacer()
        }
            .font(Font(TR.Font.font(ofSize: 16)))
            .foregroundColor(Color(uiColor: agreesTerm.wrappedValue ? CR.Color.gray05 : CR.Color.gray03))
    }
        .buttonStyle(.none)
}

#if DEBUG
import SwiftUI

class CreateCodeMockRouter: CreateCodeRoutable {
    
}

struct CreateCode_Preview: View {
    var body: some View {
        CreateCodeViewController(
            router: CreateCodeMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(
                    isLoading: false
                )
            ))
        )
            .rootView
    }
}

struct CreateCode_Previews: PreviewProvider {
    static var previews: some View {
        CreateCode_Preview()
    }
}
#endif
