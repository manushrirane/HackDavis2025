import SwiftUI

struct ContentView: View {
    @State var navigateToTimeline = false
    @EnvironmentObject var userData: UserData
    @State private var currentStep = 0

    let questions = ["What is your name?",
                     "What country are you from?",
                     "What type of visa do you have?",
                     "What processes do you need help with?"]

    let processOptions = [
        "OPT/CPT Application",
        "Visa Renewal",
        "SEVIS Fee Payment",
        "SSN Application",
        "Bank Account Setup",
        "Driver’s License Process",
        "Health Insurance Enrollment",
        "On-Campus Job Paperwork",
        "Housing/Lease Guidance",
        "Tax Filing (Form 8843/1040NR)"
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(.systemBlue), Color(.lightGray)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()

                if currentStep < questions.count {
                    Text(questions[currentStep])
                        .font(.headline)
//                        .padding()
                }

                if currentStep == 3 {
                    Picker("Select process", selection: $userData.help) {
                        ForEach(processOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                } else {
                    TextField("Enter your answer", text: bindingForCurrentStep())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }

//                NavigationLink(destination: MultiTimelineView(), isActive: $navigateToTimeline) {
//                    EmptyView()
//                }

                Button(action: {
                    if currentStep < questions.count - 1 {
                        currentStep += 1
                    } else {
                        print("All responses collected!")
                        navigateToTimeline = true
                    }
                }) {
                    Text(currentStep < questions.count - 1 ? "Next" : "Submit")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }

    private func bindingForCurrentStep() -> Binding<String> {
        switch currentStep {
        case 0: return $userData.name
        case 1: return $userData.country
        case 2: return $userData.visaType
        case 3: return $userData.help
        default: return .constant("")
        }
    }
}

#Preview {
    ContentView().environmentObject(UserData())
}
