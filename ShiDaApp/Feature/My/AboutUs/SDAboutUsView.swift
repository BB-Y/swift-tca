import SwiftUI
import ComposableArchitecture

@Reducer
struct AboutUsFeature {
    @ObservableState
    struct State: Equatable {
        var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    enum Action {
        case onServiceTermsTapped
        case onPrivacyPolicyTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onServiceTermsTapped:
                return .none
            case .onPrivacyPolicyTapped:
                return .none
            }
        }
    }
}

struct SDAboutUsView: View {
    let store: StoreOf<AboutUsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image("logo_large")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.top, 40)
                  
                    
                    Text("V\(store.version)")
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text3)
                    
                    
                    VStack(spacing: 0) {
                        row(title: "服务条款", value: "")
                            .onTapGesture {
                                store.send(.onServiceTermsTapped)
                            }
                        SDLine(SDColor.divider)
                        row(title: "隐私政策", value: "")
                            .onTapGesture {
                                store.send(.onPrivacyPolicyTapped)
                            }
                        SDLine(SDColor.divider1)

                        row(title: "备案号", value: "京ICP备18586554号-5A")
                            .onTapGesture {
                                //store.send(.onPrivacyPolicyTapped)
                            }
                       
                    }
                    .padding(.bottom, 40)
                    Spacer()

                }
                .padding(.horizontal, 24)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationTitle("关于我们")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.sdBody1.weight(.medium))
                .foregroundStyle(SDColor.text1)
            Spacer()
            if value.isEmpty == false {
                Text(value)
                    .font(.sdBody1)
                    .foregroundStyle(SDColor.text3)
            }
            
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(SDColor.text3)
        }
        .frame(height: 54)
    }
}

#Preview {
    NavigationStack {
        SDAboutUsView(
            store: Store(
                initialState: AboutUsFeature.State(),
                reducer: { AboutUsFeature() }
            )
        )
    }
}
