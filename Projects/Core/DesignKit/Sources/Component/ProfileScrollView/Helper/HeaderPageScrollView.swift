//
//  HeaderPageScrollView.swift
//  MyPageFeature
//
//  Created by 조용인 on 7/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct PageLabel {
  public var title: String
  public var symbolImage: String
}

public struct HeaderPageScrollView<Header: View, Page: View>: View {
  
  public var displaysSymbols: Bool = false
  /// Header에 해당하는 View
  public var header: Header
  /// Tab별로 가지게 될 Label들 (image도 가능)
  public var pageLabels: [PageLabel]
  /// 각 Tab에 해당하는 View
  public var pages: [Page]
  public var onRefresh: () async -> Void
  
  // MARK: - View 관련 Properties
  @State private var activeTab: String?
  @State private var headerHeight: CGFloat = 0
  @State private var scrollPosition: [ScrollPosition] = []
  @State private var scrollGeometry: [ScrollGeometry] = []
  @State private var tabLabelWidths: [String?: CGFloat] = [:]
  
  @State private var mainScrollDisabled: Bool = false
  @State private var mainScrollPhase: ScrollPhase = .idle
  @State private var mainScrollGeometry: ScrollGeometry = .init()
  
  public init(
    displaysSymbols: Bool,
    @ViewBuilder header: @escaping () -> Header,
    @PageLabelBuilder pageLabels: @escaping () -> [PageLabel],
    pages: [Page],
    onRefresh: @escaping () async -> Void = {}
  ) {
    self.displaysSymbols = displaysSymbols
    self.header = header()
    self.pageLabels = pageLabels()
    self.pages = pages
    self.onRefresh = onRefresh
    
    let count = pageLabels().count
    
    self._scrollGeometry = .init(initialValue: .init(repeating: .init(), count: count))
    self._scrollPosition = .init(initialValue: .init(repeating: .init(), count: count))
    self._tabLabelWidths = .init(initialValue: .init(uniqueKeysWithValues: pageLabels().map { ($0.title, 0) }))
    
  }
  
  public var body: some View {
    GeometryReader {
      let size = $0.size
      
      ScrollView(.horizontal) {
        HStack(spacing: 0) {
          Group {
            if pages.count != pageLabels.count {
              Text("Tabviews and labels does not match")
                .frame(width: size.width, height: size.height)
            } else {
              ForEach(pageLabels, id: \.title){ label in
                PageScrollView(label: label, size: size, subViews: pages)
                  .frame(width: size.width)
                  .id(label.title)
              }
            }
          }
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.paging)
      .scrollPosition(id: $activeTab)
      .scrollIndicators(.hidden)
      .scrollDisabled(mainScrollDisabled) /// 메인 스크롤뷰가 비활성화되면 스크롤 불가
      .allowsHitTesting(mainScrollPhase == .idle) /// scrollView가 idle 상태일 때만 탭 허용
      .onScrollPhaseChange({ oldPhase, newPhase in
        mainScrollPhase = newPhase
      })
      .onScrollGeometryChange(
        for: ScrollGeometry.self,
        of: { $0},
        action: { oldValue, newValue in
          mainScrollGeometry = newValue
        }
      )
      .mask {
        Rectangle()
          .ignoresSafeArea(.all, edges: .bottom)
      }
      .onAppear {
        guard activeTab == nil else { return }
        activeTab = pageLabels.first?.title
      }
    }
  }
  
  @ViewBuilder
  func PageScrollView(label: PageLabel, size: CGSize, subViews: [Page]) -> some View {
    let index = pageLabels.firstIndex(where: { $0.title == label.title }) ?? 0
    
    ScrollView(.vertical) {
      LazyVStack(spacing: .Number0, pinnedViews: [.sectionHeaders]) {
        ZStack {
          if activeTab == label.title {
            header
              .visualEffect({ content, proxy in
                content.offset(x: -proxy.frame(in: .scrollView(axis: .horizontal)).minX)
              })
              .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height
              } action: { newValue in
                headerHeight = newValue
              }
              .transition(.identity)
          } else {
            Rectangle()
              .foregroundStyle(.clear)
              .frame(height: headerHeight)
              .transition(.identity)
          }
        }
        .simultaneousGesture(horizontalScrollDisableGesture)

        Section {
          subViews[index]
            .frame(minHeight: size.height - .Number48, alignment: .top)
            
        } header: {
          VStack(spacing: .Number0) {
            if activeTab == label.title {
              CustomTabBar()
                .visualEffect({ content, proxy in
                  content.offset(x: -proxy.frame(in: .scrollView(axis: .horizontal)).minX)
                })
                .transition(.identity)
            } else {
              Rectangle()
                .foregroundStyle(.clear)
                .frame(height: .Number48)
                .transition(.identity)
            }
            BorderView(size: .long)
              .foregroundStyle(ColorSet.Background.Tertiary)
              
          }
          .simultaneousGesture(horizontalScrollDisableGesture)
          
        }
      }
    }
    .onScrollGeometryChange(for: ScrollGeometry.self, of: {
      $0
    }, action: { oldValue, newValue in
      scrollGeometry[index] = newValue
      if newValue.offsetY < 0 { resetScroll(label) }
    })
    .scrollPosition($scrollPosition[index])
    .onScrollPhaseChange({ oldPhase, newPhase in
      let geometry = scrollGeometry[index]
      let maxOffset = min(geometry.offsetY, headerHeight)
      
      if newPhase == .idle && maxOffset <= headerHeight {
        updateOtherScrollViews(label, to: maxOffset )
      }
      
      if newPhase == .idle && mainScrollDisabled {
        mainScrollDisabled = false
      }
    })
    .scrollClipDisabled()
    .refreshable {
      await onRefresh()
    }
  }
  
  @ViewBuilder
  func CustomTabBar() -> some View {
    let progress = mainScrollGeometry.offsetX / mainScrollGeometry.containerSize.width
    ZStack(alignment: .leading) {
      HStack(spacing: .Number0) {
        ForEach(pageLabels, id: \.title) { label in
          Group {
            if displaysSymbols {
              Image(systemName: label.symbolImage)
            } else {
              Text(label.title)
                .font(FontSet.Title.title3)
                .measureTextWidth(for: label.title)
            }
          }
          .frame(maxWidth: .infinity)
          .foregroundStyle(activeTab == label.title ? ColorSet.Text.Primary : ColorSet.Text.Tertiary)
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
              activeTab = label.title
            }
          }
          .onPreferenceChange(TextWidthPreferenceKey.self) {
            if activeTab == label.title { tabLabelWidths = $0 }
          }
        }
      }
      VStack {
        Spacer()
        RoundedRectangle(cornerRadius: .Number0)
          .foregroundStyle(ColorSet.Component.Primary)
          .frame(width: tabLabelWidths[activeTab], height: .Number4)
          .containerRelativeFrame(.horizontal) { value, _ in
            return value / CGFloat(pageLabels.count)
          }
          .visualEffect { content, proxy in
            content
              .offset(x: proxy.size.width * progress)
          }
      }
    }
    .frame(height: .Number48)
    .background(ColorSet.Background.Primary)
  }
  
  private var horizontalScrollDisableGesture: some Gesture {
    DragGesture(minimumDistance: .Number0)
      .onChanged { _ in
        mainScrollDisabled = true
      }
      .onEnded { _ in
        mainScrollDisabled = false
      }
  }
  
  private func resetScroll(_ from: PageLabel) {
    for index in pageLabels.indices {
      let label = pageLabels[index]
      
      if label.title != from.title { scrollPosition[index].scrollTo(y: 0) }
        
    }
  }
  
  private func updateOtherScrollViews(_ from: PageLabel, to: CGFloat) {
    for index in pageLabels.indices {
      let label = pageLabels[index]
      let offset = scrollGeometry[index].offsetY
      
      let wantsUpdate = offset < headerHeight || to < headerHeight
      
      if wantsUpdate && label.title != from.title {
        scrollPosition[index].scrollTo(y: to)
      }
    }
  }
}
    
@resultBuilder
public struct PageLabelBuilder {
  public static func buildBlock(_ components: PageLabel...) -> [PageLabel] {
    return components.compactMap { $0 }
  }
}

#Preview {
  ContentView()
}

extension ScrollGeometry {
  init() {
    self.init(contentOffset: .zero, contentSize: .zero, contentInsets: .init(.zero), containerSize: .zero)
  }
  
  var offsetY: CGFloat {
    return contentOffset.y + contentInsets.top
  }
  
  var offsetX: CGFloat {
    return contentOffset.x + contentInsets.leading
  }
}
