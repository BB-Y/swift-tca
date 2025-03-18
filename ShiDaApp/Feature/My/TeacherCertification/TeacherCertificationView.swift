import SwiftUI
import ComposableArchitecture
import PhotosUI

struct TeacherCertificationView: View {
    let store: StoreOf<TeacherCertificationFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color(.systemBackground).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Content
                    ScrollView {
                        VStack(spacing: 16) {
                            // Green tip banner
                            InfoBanner(text: "通过认证后您将享有我们为教师提供的各项服务。")
                            
                            // Form section
                            FormSection {
                                // User info fields
                                FormRow(title: "姓名", content: {
                                    Text(viewStore.name)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                })
                                
                                FormRow(title: "手机号", content: {
                                    Text(viewStore.phoneNumber)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                })
                                
                                FormRow(title: "邮箱", content: {
                                    TextField("请输入邮箱（选填）", text: viewStore.binding(
                                        get: \.email,
                                        send: TeacherCertificationFeature.Action.emailChanged
                                    ))
                                })
                                
                                FormRow(title: "学校", content: {
                                    TextField("请输入学校", text: viewStore.binding(
                                        get: \.school,
                                        send: TeacherCertificationFeature.Action.schoolChanged
                                    ))
                                })
                                
                                FormRow(title: "院系", content: {
                                    TextField("请输入院系", text: viewStore.binding(
                                        get: \.department,
                                        send: TeacherCertificationFeature.Action.departmentChanged
                                    ))
                                })
                                
                                FormRow(title: "专业", content: {
                                    TextField("请输入专业（选填）", text: viewStore.binding(
                                        get: \.major,
                                        send: TeacherCertificationFeature.Action.majorChanged
                                    ))
                                })
                                
                                FormRow(title: "职位", content: {
                                    TextField("请输入职位（选填）", text: viewStore.binding(
                                        get: \.position,
                                        send: TeacherCertificationFeature.Action.positionChanged
                                    ))
                                })
                                
                                FormRow(title: "职称", content: {
                                    TextField("请输入职称（选填）", text: viewStore.binding(
                                        get: \.title,
                                        send: TeacherCertificationFeature.Action.titleChanged
                                    ))
                                })
                            }
                            
                            // Work ID document upload section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("工作证件")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                if viewStore.workIdImages.isEmpty {
                                    // Upload button when no images
                                    Button {
                                        viewStore.send(.addWorkIdImagesTapped)
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 32))
                                            Text("上传工作证照片")
                                                .font(.subheadline)
                                        }
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 160)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                    .padding(.horizontal)
                                } else {
                                    // Image grid and re-upload button when has images
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(viewStore.workIdImages.indices, id: \.self) { index in
                                                if let uiImage = UIImage(data: viewStore.workIdImages[index]) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 160)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    Button {
                                        viewStore.send(.reuploadWorkIdImagesTapped)
                                    } label: {
                                        Text("重新上传")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                    }
                                    .padding(.horizontal)
                                }
                                
                                Text("请上传您的工作证照片，照片上需体现您的工作院系、姓名等信息，或者其他能证明您教师身份的证件。")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            // Address information section
                            FormSection {
                                FormRow(title: "地址", content: {
                                    Button {
                                        // Address selector would be implemented here
                                    } label: {
                                        HStack {
                                            Text(viewStore.address.isEmpty ? "请选择地址（选填）" : viewStore.address)
                                                .foregroundColor(viewStore.address.isEmpty ? .gray : .primary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                })
                                
                                FormRow(title: "详细地址", content: {
                                    TextField("请输入详细地址（选填）", text: viewStore.binding(
                                        get: \.detailedAddress,
                                        send: TeacherCertificationFeature.Action.detailedAddressChanged
                                    ))
                                })
                                
                                FormRow(title: "邮编", content: {
                                    TextField("请输入邮编（选填）", text: viewStore.binding(
                                        get: \.postalCode,
                                        send: TeacherCertificationFeature.Action.postalCodeChanged
                                    ))
                                    .keyboardType(.numberPad)
                                })
                            }
                            
                            // Agreement and submit section
                            VStack(spacing: 16) {
                                // Agreement checkbox
                                Button {
                                    viewStore.send(.agreementToggled)
                                } label: {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: viewStore.isAgreementChecked ? "checkmark.square.fill" : "square")
                                            .foregroundColor(viewStore.isAgreementChecked ? .green : .gray)
                                        
                                        Text("勾选即代表您并同意接受")
                                            .foregroundColor(.gray) +
                                        Text("《独秀云教师认证服务协议》")
                                            .foregroundColor(.green)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal)
                                
                                // Submit button
                                Button {
                                    viewStore.send(.submitTapped)
                                } label: {
                                    Text("提交")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.green)
                                        )
                                }
                                .padding(.horizontal)
                                .disabled(viewStore.isSubmitting)
                                
                                // Spacer for bottom tab bar
                                Spacer(minLength: 80)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("教师认证（未认证）")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewStore.send(.backButtonTapped)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            .alert(
                viewStore.alertMessage ?? "",
                isPresented: viewStore.binding(
                    get: { $0.alertMessage != nil },
                    send: .dismissAlert
                )
            ) {
                Button("确定") {
                    viewStore.send(.dismissAlert)
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.showImagePicker,
                send: { _ in .workIdImagesSelected([]) }
            )) {
                ImagePicker { imageData in
                    if !imageData.isEmpty {
                        viewStore.send(.workIdImagesSelected(imageData))
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

// Info banner with green background
struct InfoBanner: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.1))
            .foregroundColor(.green)
            .padding(.horizontal)
    }
}

// Form section container
struct FormSection<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// Individual form row with title and content
struct FormRow<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .frame(width: 70, alignment: .leading)
                
                content
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            
            Divider()
                .padding(.leading, 16)
        }
    }
}

// Image picker for document upload
struct ImagePicker: UIViewControllerRepresentable {
    var completion: ([Data]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var imageDataArray: [Data] = []
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage, let imageData = image.jpegData(compressionQuality: 0.7) {
                        imageDataArray.append(imageData)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.completion(imageDataArray)
                picker.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Preview
struct TeacherCertificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TeacherCertificationView(
                store: Store(
                    initialState: TeacherCertificationFeature.State(),
                    reducer: { TeacherCertificationFeature() }
                )
            )
        }
    }
}
