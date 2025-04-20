import SwiftUI

struct MultiTimelineView: View {
    @State private var timelines: [Timeline] = []

    var body: some View {
        NavigationView {
            ScrollView {
               
                Text("Dashboard")
                    .font(.system(size: 50, weight: .bold))

                    .padding(.vertical,20)
                    .padding(.horizontal,10)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("PNG image")
                    .resizable()
                    .frame(width: 400, height: 100)
                Text("Ongoing Processes")
                    .padding()
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
              
                 

//                Divider()
//                    .frame(height: 1)
//                    .background(Color.blue)
//                    .font(.title)
//                    .bold()
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 0)
//                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 30) {
                    ForEach(timelines) { timeline in
                        VStack(alignment: .leading, spacing: 20) {
                            NavigationLink(destination: TimelineChecklistView(timeline: timeline)) {
                                Text(timeline.name)
                                    .font(.title2)
                                    .bold()
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                ZStack(alignment: .center) {
                                    GeometryReader { geometry in
                                        Path { path in
                                            let y = geometry.size.height / 2
                                            let stepCount = timeline.steps.count
                                            let spacing: CGFloat = 200
                                            let totalWidth = CGFloat(stepCount) * spacing
                                            path.move(to: CGPoint(x: 0, y: y))
                                            path.addLine(to: CGPoint(x: totalWidth, y: y))
                                        }
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)

                                        Path { path in
                                            let y = geometry.size.height / 2
                                            let stepCount = timeline.steps.count
                                            let spacing: CGFloat = 90
                                            let totalWidth = CGFloat(stepCount - 1) * spacing
                                            let progressWidth = totalWidth * timeline.overallProgress
                                            path.move(to: CGPoint(x: 0, y: y))
                                            path.addLine(to: CGPoint(x: progressWidth, y: y))
                                        }
                                        .stroke(Color.blue, lineWidth: 4)
                                    }
                                    .frame(height: 60)

                                    HStack(spacing: 90) {
                                        ForEach(timeline.steps) { step in
                                            NavigationLink(destination: TimelineStepDetail(step: step)) {
                                                VStack(spacing: 10) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(.systemBackground))
                                                            .frame(width: 60, height: 60)
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                                                            )
                                                        Circle()
                                                            .trim(from: 0.0, to: CGFloat(step.progress))
                                                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                                            .rotationEffect(.degrees(-90))
                                                            .frame(width: 60, height: 60)
                                                        Image(systemName: step.type.iconName)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .opacity(0.8)
                                                    }
                                                    Text(step.title)
                                                        .font(.caption)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 70)
                                                }
                                            }
                                        
                                        }
                                        .padding(.horizontal, 0)
                                       
                                    }
                                    
                                }
                                .padding(.vertical, 10)
                                .frame(height: 100)
                            }
                        }
                       
                    }

                    // Your Records Section
                    VStack(alignment: .leading, spacing: 10) {
                        
                        
        
        
                        Text("Recent Records")
                            .font(.title)
                            .bold()

                        HStack(spacing: 16) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(["I-20.pdf", "Passport Photo.jpg", "SEVIS Receipt.pdf"], id: \.self) { filename in
                                        VStack(spacing: 6) {
                                            Image(systemName: "doc.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 50)
                                                .foregroundColor(.blue)

                                            Text(filename)
                                                .font(.caption2)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 80)
                                        }
                                    }
                                }
                            }

                            Spacer()
                            NavigationLink(destination: RecordsView()) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            
//            .navigationTitle("Dashboard")
            .onAppear {
                loadTimelinesFromGPT()
            }
        }
    }
    // Replace this with actual GPT integration logic
           //u want the llm model to decide the icon ".document vs office vs fees prepare", and the title like "get ready for interview", and randomized progress. the number of timelines, and name of the Timeline will be decided by how many tasks they say they want to get done in the questionnarire. also the blue header text leads to checklist. the checklist displays info based off the status attribute.
    

    func loadTimelinesFromGPT() {
        timelines = [
            Timeline(name: "F-1 Visa Application", steps: [
                TimelineStep(
                    type: .document,
                    title: "Form I-20",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Form I-20 is an official U.S. government document issued by a SEVP-certified school that confirms a student's acceptance into a full-time academic program. It is required for F-1 visa applicants and serves as proof of eligibility to study in the U.S. You'll need it to pay the SEVIS fee, apply for your visa, enter the country, and maintain your legal student status."
                ),
                TimelineStep(type: .document, title: "DS-160 confirmation page", progress: 0.0, status: .notStarted, note: "4–6 months before start"),
                TimelineStep(type: .fees, title: "SEVIS fee payment receipt (Form I-901)", progress: 0.0, status: .notStarted, note: "3–5 months before start"),
                TimelineStep(type: .office, title: "Visa appointment confirmation", progress: 0.0, status: .inProgress, note: "Schedule Visa Interview (3–4 months before start)"),
                TimelineStep(type: .document, title: "Passport-style photograph", progress: 0.0, status: .inProgress, note: nil),
                TimelineStep(type: .document, title: "Financial documents", progress: 1.0, status: .submitted, note: nil),
                TimelineStep(type: .document, title: "Academic documents", progress: 1.0, status: .submitted, note: nil)
            ]),
            Timeline(name: "OPT/CPT Application", steps: [
                TimelineStep(
                    type: .prepare,
                    title: "Attend OPT/CPT Workshop",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Attend a mandatory session hosted by your university’s international office"
                ),
                TimelineStep(
                    type: .document,
                    title: "Request I-20 with OPT/CPT Recommendation",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Submit the request form and provide a job/internship offer letter"
                ),
                TimelineStep(
                    type: .document,
                    title: "Obtain Updated I-20",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Wait 3–5 business days for the updated I-20 from your DSO"
                ),
                TimelineStep(
                    type: .fees,
                    title: "Pay USCIS Filing Fee",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Check the current fee on the USCIS website; keep the receipt"
                ),
                TimelineStep(
                    type: .document,
                    title: "Prepare OPT/CPT Application Packet",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Include I-20, I-765, passport photo, and supporting documents"
                ),
                TimelineStep(
                    type: .office,
                    title: "Mail Packet to USCIS",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Use tracking; submit within 30 days of the OPT I-20 issuance date"
                ),
                TimelineStep(
                    type: .document,
                    title: "Receive I-797 Receipt Notice",
                    progress: 0.0,
                    status: .inProgress,
                    note: "Usually arrives 2–3 weeks after submission"
                ),
                TimelineStep(
                    type: .document,
                    title: "Receive EAD Card (OPT only)",
                    progress: 0.0,
                    status: .notStarted,
                    note: "Expect it 1–3 months after the receipt notice, if approved"
                )
            ])

        ]
    }
}


struct TimelineChecklistView: View {
    let timeline: Timeline

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(timeline.name)
                    .font(.title)
                    .bold()
                    .padding(.top)

                Divider()
                    .frame(height: 1)
                    .background(Color.blue)

                ForEach(timeline.steps) { step in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: iconForStatus(step.status))
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(colorForStatus(step.status))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(step.title)
                                .font(.headline)

                            if let note = step.note {
                                Text(note)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Text("Status: \(step.status.rawValue)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Checklist")
    }

    // MARK: - Icon helpers
    func iconForStatus(_ status: StepStatus) -> String {
        switch status {
        case .notStarted: return "circle"
        case .inProgress: return "clock"
        case .submitted: return "checkmark.circle.fill"
        }
    }

    func colorForStatus(_ status: StepStatus) -> Color {
        switch status {
        case .notStarted: return .gray
        case .inProgress: return .blue
        case .submitted: return .green
        }
    }
}

struct RecordsView: View {
    var body: some View {
        Text("Records Detail Page")
            .navigationTitle("Recent Records")
    }
}

struct Timeline: Identifiable {
    let id = UUID()
    let name: String
    var steps: [TimelineStep]

    var overallProgress: Double {
        steps.map { $0.progress }.reduce(0, +) / Double(steps.count)
    }
}


struct TimelineStep: Identifiable {
    let id = UUID()
    let type: TimelineType
    let title: String
    let progress: Double
    let status: StepStatus
    let note: String?
}

enum TimelineType: String, Codable, CaseIterable {
    case document, office, fees, prepare

    var iconName: String {
        switch self {
        case .document: return "doc.text"
        case .office: return "building.2"
        case .fees: return "creditcard"
        case .prepare: return "brain.head.profile"
        }
    }
}

enum StepStatus: String, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "Documents In Progress"
    case submitted = "Documents Submitted"
}

struct TimelineStepDetail: View {
    let step: TimelineStep

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: step.type.iconName)
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .background(Circle().fill(Color(.systemTeal)))

            Text(step.title)
                .font(.title2)
                .bold()

            Text("Progress: \(Int(step.progress * 100))% completed.")
                .padding()

            if let note = step.note {
                Text(note)
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            //manushree
//            if step.title == "Form I-20" {
//                NavigationLink(destination: FormI20InfoView()) {
//                    Text("Learn More About Form I-20")
//                        .fontWeight(.semibold)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                }
//            }
        }
        .navigationTitle(step.title)
    }
}



#Preview {
    MultiTimelineView()
}
