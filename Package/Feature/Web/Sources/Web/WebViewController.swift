//
//  WebViewController.swift
//  
//
//  Created by JSilver on 2023/03/24.
//

import Feature
import WebKit

public protocol WebControllerDelegate: AnyObject {
    func back()
}

public protocol WebControllable: UIViewControllable {
    var delegate: (any WebControllerDelegate)? { get set }
}

final class WebViewController: ComposableController, WebControllable {
    final private class Environment: ObservableObject {
        @Published
        var url: URL?
        @Published
        var progress: Double = 0
        @Published
        var isLoading: Bool = true
        
        init(
            url: URL
        ) {
            self.url = url
        }
    }

    // MARK: - Property
    private let router: any WebRoutable
    weak var delegate: (any WebControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any WebRoutable,
        reducer: Reducer<WebViewReduce>,
        url: URL
    ) {
        self.router = router
        let env = Environment(url: url)
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                url: .object(env, path: \.url),
                progress: .object(env, path: \.progress),
                isLoading: .object(env, path: \.isLoading),
                onCreateWebView: { url in
                    guard let url else { return }
                    self?.presentWeb(animated: true, url: url)
                },
                onBackTap: {
                    self?.delegate?.back()
                }
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    @MainActor
    private func presentWeb(
        animated: Bool,
        force: Bool = true,
        url: URL,
        completion: ((any WebControllable) -> Void)? = nil
    ) {
        let web = router.routeToWeb(with: .init(
            url: url
        ))
        
        web.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(web, animated: true)
        }
    }
}

extension WebViewController: WebControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    url: Binding<URL?>,
    progress: Binding<Double>,
    isLoading: Binding<Bool>,
    onCreateWebView: @escaping (URL?) -> Void,
    onBackTap: @escaping () -> Void
) -> some View {
    VStack(spacing: 0) {
        SUWebViewReader { reader in
            ZStack {
                NavigationBar(
                    title: isLoading.wrappedValue
                        ? TR.Localization.webLoadingTitle
                        : reader.title,
                    onBackTap: {
                        guard reader.canGoBack else {
                            onBackTap()
                            return
                        }
                        
                        reader.goBack()
                    }
                )
                
                ProgressBar(
                    progress: progress.wrappedValue,
                    isLoading: isLoading.wrappedValue
                )
            }
            .fixedSize(horizontal: false, vertical: true)
            
            WebContent(
                url: url,
                progress: progress,
                isLoading: isLoading,
                onCreateWeb: onCreateWebView
            )
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
private func ProgressBar(
    progress: Double,
    isLoading: Bool
) -> some View {
    VStack {
        Spacer()
        
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color(uiColor: CR.Color.gray02))
            
            Rectangle()
                .foregroundColor(Color(uiColor: CR.Color.gray05))
                .frame(height: 2)
                .scaleEffect(x: progress, anchor: .leading)
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
        .opacity(isLoading ? 1 : 0)
        .animation(.easeInOut, value: isLoading)
}

@ViewBuilder
private func WebContent(
    url: Binding<URL?>,
    progress: Binding<Double>,
    isLoading: Binding<Bool>,
    onCreateWeb: @escaping (URL?) -> Void
) -> some View {
    SUWebView(url: url)
        .onProgressChange { progress.wrappedValue = $0 }
        .onCreateWebView { _, action, _ in
            onCreateWeb(action.request.url)
            return true
        }
        .onCommit { _ in
            Logger.info("""
                
                🕸️ Web view has started to receive content.
                   URL: \(url.wrappedValue?.absoluteString ?? "nil")
                """,
                userInfo: [
                    .category: "WEBVIEW"
                ]
            )
            
            isLoading.wrappedValue = true
        }
        .onFinish { _ in
            Logger.info("""
                
                🕸️ Navigation is completed.
                   URL: \(url.wrappedValue?.absoluteString ?? "nil")
                """,
                userInfo: [
                    .category: "WEBVIEW"
                ]
            )
            
            isLoading.wrappedValue = false
        }
        .onFail { _, error in
            Logger.error("""
                
                🕸️ Navigation is failed.
                   URL: \(url.wrappedValue?.absoluteString ?? "nil")
                   ERROR: \(String(describing: error))
                """,
                userInfo: [
                    .category: "WEBVIEW"
                ]
            )
            
            isLoading.wrappedValue = false
        }
        .onNavigationAction { action, preferences in
            Logger.info("""
                
                🕸️ Web view try to navigate with action.
                   URL: \(action.request.url?.absoluteString as Any)
                   HEADERS: \(printPretty(action.request.allHTTPHeaderFields ?? [:], start: 3, indent: 2))
                   MAIN FRAME: \(action.sourceFrame.isMainFrame)
                """,
                userInfo: [
                    .category: "WEBVIEW"
                ]
            )
            
            return (.allow, preferences)
        }
        .onNavigationResponse { response in
            Logger.info("""
                
                🕸️ Web view try to navigate with response.
                   URL: \(response.response.url?.absoluteString as Any)
                   CONTENT LENGTH: \(response.response.expectedContentLength)
                   MAIN FRAME: \(response.isForMainFrame)
                """,
                userInfo: [
                    .category: "WEBVIEW"
                ]
            )
            
            return .allow
        }
            .ignoresSafeArea()
}

private func printPretty(_ dictionary: [AnyHashable: Any], start: Int, indent: Int) -> String {
    let string = dictionary.map { key, value -> String in
        var value = value
        if let dictionary = value as? [AnyHashable: Any] {
            value = printPretty(dictionary, start: start + indent, indent: indent)
        }
        
        let indent = String(repeating: " ", count: indent)
        return "\(indent)\(key): \(value)"
    }
        .map { "\(String(repeating: " ", count: start))\($0)" }
        .joined(separator: "\n")
    
    return "\n\(string)"
}

#if DEBUG
private class WebMockRouter: WebRoutable {
    final private class Web: ComposableController, WebControllable {
        weak var delegate: (WebControllerDelegate)?
    }
    
    func routeToWeb(with parameter: WebParameter) -> WebControllable {
        Web {
            Text("Web")
        }
    }
}

private struct Web_Preview: View {
    var body: some View {
        WebViewController(
            router: WebMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init()
            )),
            url: URL(string: "https://www.google.com")!
        )
            .rootView
    }
}

struct Web_Previews: PreviewProvider {
    static var previews: some View {
        Web_Preview()
    }
}
#endif
