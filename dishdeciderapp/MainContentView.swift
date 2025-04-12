import SwiftUI
import Foundation // Import Foundation to access loadDishes

// MARK: - Dish Card View

struct DishCardView: View {
    @Binding var dish: Dish? // Make dish optional and use Binding
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var didSwipe = false
    let onSwipe: (Bool) -> Void // Closure to notify about swipe (true for right, false for left)

    var body: some View {
        GeometryReader { geometry in
            if let dish = dish {
                VStack {
                    Image(dish.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Text(dish.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    Text(dish.restaurantName) // Display the restaurant name
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(x: offset)
                .opacity(opacity)
                .rotationEffect(.degrees(Double(offset / 40))) // Slight rotation on swipe
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation.width
                            opacity = 1 - abs(offset / 200) // Fade out on swipe
                        }
                        .onEnded { gesture in
                            if offset > 100 {
                                // Swiped right (liked)
                                swipeAction(direction: true, geometry: geometry)
                            } else if offset < -100 {
                                // Swiped left (disliked)
                                swipeAction(direction: false, geometry: geometry)
                            } else {
                                // Reset position
                                withAnimation(.spring()) {
                                    offset = 0
                                    opacity = 1
                                }
                            }
                        }
                )
            } else {
                EmptyView() // Show nothing if dish is nil
            }
        }
        .opacity(dish == nil ? 0 : 1) // Hide the card if dish is nil
        .frame(height: dish == nil ? 0 : 500) // Adjust frame when dish is nil
    }

    private func swipeAction(direction: Bool, geometry: GeometryProxy) {
        HapticFeedback.play(direction ? .success : .error)
        withAnimation {
            offset = direction ? geometry.size.width * 2 : -geometry.size.width * 2
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSwipe(direction) // Notify parent view about the swipe
        }
    }
}

// MARK: - Dish Detail View (Placeholder)

struct DishDetailView: View {
    let dish: Dish

    var body: some View {
        VStack {
            Image(dish.imageName)
                .resizable()
                .scaledToFit()
                .padding()
            Text(dish.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            Text(dish.restaurantName) // Show restaurant name in details
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom)
            Text(dish.description)
                .font(.body)
                .padding(.bottom)
            Text("Price: \(dish.price)") // Show the price
                .font(.subheadline)
                .foregroundColor(.green)
                .padding(.bottom)
            Spacer()
        }
        .navigationTitle("Dish Details")
    }
}

// MARK: - Main Content View

struct MainContentView: View {
    @State private var dishes: [Dish] = loadDishes() // Load dishes using the function from DishData
    @State private var currentDish: Dish?
    @State private var showDetailView: Bool = false
    @State private var selectedDish: Dish?
    @State private var likedRestaurants: [String: Int] = [:] // Dictionary to track liked restaurants
    @State private var mostLikedRestaurant: String? = nil

    init() {
        _currentDish = State(initialValue: dishes.first)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let currentDish = currentDish {
                    DishCardView(dish: $currentDish) { liked in
                        // Handle swipe action here
                        if liked {
                            print("Liked: \(currentDish.name) from \(currentDish.restaurantName)")
                            likedRestaurants[currentDish.restaurantName, default: 0] += 1
                        } else {
                            print("Disliked: \(currentDish.name) from \(currentDish.restaurantName)")
                            // In a real app, you might record a "dislike" action here
                        }
                        navigateToNextDish()
                    }
                    .frame(height: 500) // Adjust height as needed
                    .padding()
                    .transition(.slide)
                    .onTapGesture {
                        selectedDish = currentDish
                        showDetailView = true
                    }
                } else {
                    VStack {
                        Text("No more dishes!")
                            .font(.title2)
                            .foregroundColor(.gray)
                        if let mostLiked = mostLikedRestaurant {
                            Text("The restaurant with the most liked dishes is:")
                                .font(.headline)
                                .padding(.top)
                            Text(mostLiked)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top)
                        }
                    }
                }

                Spacer()

                if currentDish != nil {
                    HStack {
                        Button {
                            swipeLeft()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        }
                        .padding()

                        Spacer()

                        Button {
                            swipeRight()
                        } label: {
                            Image(systemName: "heart.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Restaurant Tinder")
            .navigationDestination(isPresented: $showDetailView) {
                if let dish = selectedDish {
                    DishDetailView(dish: dish)
                }
            }
            .onChange(of: currentDish) { _ in
                if currentDish == nil {
                    // Determine the most liked restaurant
                    mostLikedRestaurant = likedRestaurants.max { a, b in a.value < b.value }?.key
                }
            }
        }
    }

    func navigateToNextDish() {
        if let currentIndex = dishes.firstIndex(where: { $0.id == currentDish?.id }) {
            if currentIndex < dishes.count - 1 {
                currentDish = dishes[currentIndex + 1]
            } else {
                currentDish = nil // No more dishes
            }
        }
    }

    func swipeLeft() {
        if let currentDish = currentDish {
            print("Manually disliked: \(currentDish.name) from \(currentDish.restaurantName)")
            navigateToNextDish()
        }
    }

    func swipeRight() {
        if let currentDish = currentDish {
            print("Manually liked: \(currentDish.name) from \(currentDish.restaurantName)")
            likedRestaurants[currentDish.restaurantName, default: 0] += 1
            navigateToNextDish()
        }
    }
}

// MARK: - Haptic Feedback (Optional)

enum HapticFeedback {
    static func play(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}

// MARK: - Preview

#Preview {
    MainContentView()
}
