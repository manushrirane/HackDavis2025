import SwiftUI

struct ContentView: View {
    @State var navigateToTimeline = false
    @State private var currentStep = 0
    @State private var name = ""
    @State private var country = ""
    @State private var visaType = ""
    @State private var help = ""

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
            LinearGradient(gradient: Gradient(colors: [Color(.systemTeal), Color(.lightGray)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()

                Text(questions[currentStep])
                    .font(.headline)
                    .padding()

                if currentStep == 4 {
                    Picker("Select process", selection: $help) {
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
                Button(action: {
                    if currentStep < 4 {
                        currentStep += 1
                    } else {
                        print("All responses collected!")
                        print("Name: \(name)")
                        print("Country: \(country)")
                        print("Visa Type: \(visaType)")
                        print("Process Help: \(help)")
                    }
//                    if currentStep > 4 {
//                        navigateToTimeline = true
//                            
//                        }
                }
                
                )
                {
                    Text(currentStep < 4 ? "Next" : "Submit")
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
        case 0: return $name
        case 2: return $country
        case 3: return $visaType
        case 4: return $help
        default: return .constant("")
        }
    }
}

#Preview {
    ContentView()
}
