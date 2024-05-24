//
//  PracticeScreen.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import SwiftUI
import GRDBQuery

struct PracticeScreen: View {
    @EnvironmentStateObject var presenter: FlashCardPracticePresenter
    
    init(for deckID: Deck.ID) {
        _presenter = EnvironmentStateObject { env in
            FlashCardPracticePresenter(
                flashCardService: env.flashcardService,
                deckID: deckID,
                dismiss: env.dismiss
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            PracticeView(presenter: presenter)
                .task { await presenter.firstLoad() }
                .navigationTitle("Practice")
                .withDefaultRouter(viewModel: presenter.viewModel)
        }
    }
    
    struct PracticeView: View {
        let presenter: FlashCardPracticePresenter
        @ObservedObject var viewModel: PracticeListViewModel
        
        init(presenter: FlashCardPracticePresenter) {
            self.presenter = presenter
            self.viewModel = presenter.viewModel
        }
        
        var body: some View {
            if let currentItem = viewModel.currentItem {
                PracticeItem(
                    viewModel: currentItem,
                    onFlip: { presenter.onFlipTapped(for: $0) },
                    onRemembered: { presenter.onRemembered(item: $0) },
                    onForgotten: { presenter.onForgotten(item: $0) }
                )
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                VStack {
                    Text("Practice Completed!")
                    Button("Dismiss") {
                        presenter.completed()
                    }
                }
            }
        }
    }
}


extension PracticeScreen {
    struct PracticeItem: View {
        @ObservedObject var viewModel: PracticeItemViewModel
        let onFlip: (PracticeItemViewModel) -> Void
        let onRemembered: (PracticeItemViewModel) -> Void
        let onForgotten: (PracticeItemViewModel) -> Void
        
        @State var drag: DragGesture.Value?
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    if viewModel.flipped {
                        HStack {
                            Button(
                                action: {
                                    guard drag == nil else { return }
                                    withAnimation {
                                        self.onForgotten(viewModel)
                                        self.drag = nil
                                    }
                                },
                                label: { Label("Forgotten", systemImage: "xmark.circle") }
                            ).tint(Color.red)
                            .pushBottom()
                            .pushCenterHorizontally()
                            .padding()
                            .background {
                                if let drag {
                                    Color.red.opacity(forgottenOpacity(for: drag.location, in: geometry))
                                        .edgesIgnoringSafeArea([.horizontal, .bottom])
                                }
                            }
                            .zIndex(2)
                            .transition(.move(edge: .leading))
                            
                            Color.primary.opacity(0.0)
                            
                            Button(
                                action: {
                                    guard drag == nil else { return }
                                    withAnimation {
                                        self.onRemembered(viewModel)
                                        self.drag = nil
                                    }
                                },
                                label: { Label("Remembered", systemImage: "checkmark.circle") }
                            ).tint(Color.green)
                            .pushBottom()
                            .pushCenterHorizontally()
                            .padding()
                            .background {
                                if let drag {
                                    Color.green.opacity(rememberedOpacity(for: drag.location, in: geometry))
                                        .edgesIgnoringSafeArea([.horizontal, .bottom])
                                }
                            }
                            .zIndex(2)
                            .transition(.move(edge: .trailing))
                        }.labelStyle(.iconOnly)

                    }
                    
                    VStack {
                        FlashCardGridCell(flashCard: viewModel.card, flipped: $viewModel.flipped)
                            .id(viewModel.card.id)
                            .frame(width: 300, height: 300)
                            .offset(drag?.translation ?? .zero)
                            .gesture(
                                DragGesture()
                                    .onChanged { drag in
                                        update(drag, in: geometry)
                                    }.onEnded { drag in
                                        finish(drag, in: geometry)
                                    }
                            ).zIndex(4)
                            .transition(.opacity)
                            
                        
                        Spacer()
                        
                        if !viewModel.flipped {
                            Button("Flip") {
                                withAnimation {
                                    self.onFlip(viewModel)
                                }
                            }.zIndex(4)
                            .transition(.move(edge: .bottom))
                        }
                    }.pushCenterHorizontally()
                }
                
            }.buttonStyle(.borderedProminent)
            .animation(.default, value: viewModel.flipped)
            .animation(.default, value: viewModel.card.id)
        }
    }
}

extension PracticeScreen.PracticeItem {
    // MARK: Gesture handlers
    private func update(_ drag: DragGesture.Value, in geometry: GeometryProxy) {
        guard viewModel.flipped else { return }
        withAnimation {
            self.drag = drag
        }
    }
    
    private func finish(_ drag: DragGesture.Value, in geometry: GeometryProxy) {
        guard viewModel.flipped else { return }
        
        let location = drag.location
        let frame = geometry.frame(in: .global)
        
        if location.x > minXOfRememberedArea(in: frame) {
            self.onRemembered(viewModel)
        } else if location.x < maxXOfForgottenArea(in: frame) {
            self.onForgotten(viewModel)
        }

        withAnimation(.spring()) {
            self.drag = nil
        }
    }
    
    // MARK: Area helpers
    private func forgottenOpacity(for location: CGPoint, in geometry: GeometryProxy) -> Double {
        let frame = geometry.frame(in: .global)
        if location.x < maxXOfForgottenArea(in: frame) {
            return 0.8
        } else {
            return 0.3
        }
    }
    
    private func rememberedOpacity(for location: CGPoint, in geometry: GeometryProxy) -> Double {
        let frame = geometry.frame(in: .global)
        if location.x > minXOfRememberedArea(in: frame) {
            return 0.8
        } else {
            return 0.3
        }
    }
    
    private func maxXOfForgottenArea(in frame: CGRect) -> Double {
        frame.minX + frame.width / 3
    }
    
    private func minXOfRememberedArea(in frame: CGRect) -> Double {
        frame.minX + (2 * frame.width) / 3
    }
}
