import SwiftUI

struct ContentView: View {
    @State private var currentStep = 0
    @State private var name = ""
    @State private var age = ""
    @State private var country = ""
    @State private var visaType = ""
    @State private var desiredVisa = ""

    let questions = ["What is your name?",
                     "How old are you?",
                     "What country are you from?",
                     "What type of visa do you have?",
                     "What type of visa do you want?"]

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

                TextField("Enter your answer", text: bindingForCurrentStep())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)

                Button(action: {
                    if currentStep < 4 {
                        currentStep += 1
                    } else {
                        print("All responses collected!")
                    }
                }) {
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

    // Binds the TextField to the correct property
    private func bindingForCurrentStep() -> Binding<String> {
        switch currentStep {
        case 0: return $name
        case 1: return $age
        case 2: return $country
        case 3: return $visaType
        case 4: return $desiredVisa
        default: return .constant("")
        }
    }
}
#Preview
{
    ContentView()
    
}
