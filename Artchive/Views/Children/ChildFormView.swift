import SwiftUI

struct ChildFormView: View {
    enum Mode {
        case add
        case edit(Child)

        var title: String {
            switch self {
            case .add:
                "Add Child"
            case .edit:
                "Edit Child"
            }
        }

        var saveTitle: String {
            switch self {
            case .add:
                "Add"
            case .edit:
                "Save"
            }
        }
    }

    let mode: Mode
    let onSave: (ChildFormData) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var formData: ChildFormData

    init(mode: Mode, onSave: @escaping (ChildFormData) -> Void) {
        self.mode = mode
        self.onSave = onSave

        switch mode {
        case .add:
            _formData = State(initialValue: ChildFormData())
        case .edit(let child):
            _formData = State(initialValue: ChildFormData(child: child))
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $formData.name)
                        .textContentType(.givenName)

                    Toggle("Add birthdate", isOn: $formData.hasBirthdate.animation())

                    if formData.hasBirthdate {
                        DatePicker(
                            "Birthdate",
                            selection: $formData.birthdate,
                            displayedComponents: .date
                        )
                    }
                }

                Section("Profile Color") {
                    Picker("Profile Color", selection: $formData.profileColor) {
                        ForEach(ChildProfileColor.allCases) { profileColor in
                            Label(profileColor.name, systemImage: "circle.fill")
                                .foregroundStyle(profileColor.color)
                                .tag(profileColor.rawValue)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(mode.saveTitle) {
                        onSave(formData.normalized())
                        dismiss()
                    }
                    .disabled(!formData.isValid)
                }
            }
        }
    }
}

struct ChildFormData {
    var name = ""
    var birthdate = Date()
    var hasBirthdate = false
    var profileColor = ChildProfileColor.blue.rawValue

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var optionalBirthdate: Date? {
        hasBirthdate ? birthdate : nil
    }

    init() {}

    init(child: Child) {
        name = child.name
        birthdate = child.birthdate ?? Date()
        hasBirthdate = child.birthdate != nil
        profileColor = child.profileColor
    }

    func normalized() -> ChildFormData {
        var copy = self
        copy.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return copy
    }
}

