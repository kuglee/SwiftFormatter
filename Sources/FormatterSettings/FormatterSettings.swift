import ComposableArchitecture
import StyleGuide
import SwiftFormat
import SwiftUI

@Reducer public struct FormatterSettings {
  public init() {}

  public struct State: Equatable {
    @BindingState public var shouldTrimTrailingWhitespace: Bool
    @BindingState public var maximumBlankLines: Int
    @BindingState public var lineLength: Int
    @BindingState public var tabWidth: Int
    @BindingState public var indentation: Indent
    @BindingState public var respectsExistingLineBreaks: Bool
    @BindingState public var lineBreakBeforeControlFlowKeywords: Bool
    @BindingState public var lineBreakBeforeEachArgument: Bool
    @BindingState public var lineBreakBeforeEachGenericRequirement: Bool
    @BindingState public var prioritizeKeepingFunctionOutputTogether: Bool
    @BindingState public var indentConditionalCompilationBlocks: Bool
    @BindingState public var lineBreakAroundMultilineExpressionChainComponents: Bool
    @BindingState public var indentSwitchCaseLabels: Bool
    @BindingState public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration
    @BindingState public var spacesAroundRangeFormationOperators: Bool
    @BindingState public var multiElementCollectionTrailingCommas: Bool

    public var noAssignmentInExpressionsState: NoAssignmentInExpressions.State

    public enum Field: Equatable, Hashable {
      case noAssignmentInExpressions(NoAssignmentInExpressions.State.EditingState)
      case indentationLength
      case lineLength
      case tabWidth
      case maximumBlankLines
    }

    @BindingState public var focusedField: Field?

    public init(
      shouldTrimTrailingWhitespace: Bool,
      maximumBlankLines: Int,
      lineLength: Int,
      tabWidth: Int,
      indentation: Indent,
      respectsExistingLineBreaks: Bool,
      lineBreakBeforeControlFlowKeywords: Bool,
      lineBreakBeforeEachArgument: Bool,
      lineBreakBeforeEachGenericRequirement: Bool,
      prioritizeKeepingFunctionOutputTogether: Bool,
      indentConditionalCompilationBlocks: Bool,
      lineBreakAroundMultilineExpressionChainComponents: Bool,
      indentSwitchCaseLabels: Bool,
      fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration,
      spacesAroundRangeFormationOperators: Bool,
      multiElementCollectionTrailingCommas: Bool,
      noAssignmentInExpressionsState: NoAssignmentInExpressions.State,
      focusedField: Field? = nil
    ) {
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.maximumBlankLines = maximumBlankLines
      self.lineLength = lineLength
      self.tabWidth = tabWidth
      self.indentation = indentation
      self.respectsExistingLineBreaks = respectsExistingLineBreaks
      self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
      self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
      self.lineBreakBeforeEachGenericRequirement = lineBreakBeforeEachGenericRequirement
      self.prioritizeKeepingFunctionOutputTogether = prioritizeKeepingFunctionOutputTogether
      self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
      self.lineBreakAroundMultilineExpressionChainComponents =
        lineBreakAroundMultilineExpressionChainComponents
      self.fileScopedDeclarationPrivacy = fileScopedDeclarationPrivacy
      self.indentSwitchCaseLabels = indentSwitchCaseLabels
      self.spacesAroundRangeFormationOperators = spacesAroundRangeFormationOperators
      self.multiElementCollectionTrailingCommas = multiElementCollectionTrailingCommas
      self.noAssignmentInExpressionsState = noAssignmentInExpressionsState
      self.focusedField = focusedField

      if self.focusedField == .noAssignmentInExpressions(.textField) {
        self.noAssignmentInExpressionsState.editingState = .textField
      } else if self.focusedField == .noAssignmentInExpressions(.popover) {
        self.noAssignmentInExpressionsState.editingState = .popover
      }
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case noAssignmentInExpressionsAction(NoAssignmentInExpressions.Action)
    case wholeViewTapped
  }

  public var body: some ReducerOf<Self> {
    CombineReducers {
      BindingReducer()
      Scope(state: \.noAssignmentInExpressionsState, action: \.noAssignmentInExpressionsAction) {
        NoAssignmentInExpressions()
      }

      Reduce { state, action in
        switch action {
        case .binding: return .none
        case .noAssignmentInExpressionsAction: return .none
        case .wholeViewTapped:
          state.focusedField = nil
          state.noAssignmentInExpressionsState.editingState = nil

          return .none
        }
      }
    }
    .onChange(of: \.noAssignmentInExpressionsState.editingState) { oldValue, newValue in
      Reduce { state, action in
        guard let newValue else { return .none }

        state.focusedField = .noAssignmentInExpressions(newValue)

        return .none
      }
    }
  }
}

public struct FormatterSettingsView: View {
  let store: StoreOf<FormatterSettings>

  public init(store: StoreOf<FormatterSettings>) { self.store = store }

  @FocusState var focusedField: FormatterSettings.State.Field?

  @MainActor public var indentationView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .centerNonSiblings) {
        Text("Indentation:").alignmentGuide(.trailingLabel) { $0[.trailing] }
          .alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          HStack(spacing: 0) {
            Text("Length:").alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
            Stepper(
              value: viewStore.$indentation.count,
              in: 0...1000,
              step: 1,
              label: {
                StepperTextField(value: viewStore.$indentation.count.removeDuplicates())
                  .focused(self.$focusedField, equals: .indentationLength)
              }
            )
            .help("The amount of whitespace that should be added when indenting one level")
            Picker("", selection: viewStore.$indentation) {
              Text(Indent.spaces(Int()).rawValue).tag(Indent.spaces(viewStore.indentation.count))
              Text(Indent.tabs(Int()).rawValue).tag(Indent.tabs(viewStore.indentation.count))
            }
            .help("The type of whitespace that should be added when indenting").fixedSize()
          }
          Toggle(isOn: viewStore.$indentConditionalCompilationBlocks) {
            Text("Indent conditional compilation blocks")
          }
          .help(
            "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
          )
          Toggle(isOn: viewStore.$indentSwitchCaseLabels) { Text("Indent switch case labels") }
            .help(
              "Determines if case statements should be indented compared to the containing switch block"
            )
        }
      }
    }
  }

  @MainActor public var tabWidthView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 0) {
        Text("Tab Width:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        Stepper(
          value: viewStore.$tabWidth,
          in: 0...1000,
          step: 1,
          label: {
            StepperTextField(value: viewStore.$tabWidth.removeDuplicates())
              .focused(self.$focusedField, equals: .tabWidth)
          }
        )
        .help(
          "The number of spaces that should be considered equivalent to one tab character. This is used during line length calculations when tabs are used for indentation."
        )
        Text("spaces").padding(.grid(2))
      }
    }
  }

  @MainActor public var lineLengthView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 0) {
        Text("Line Length:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        Stepper(
          value: viewStore.$lineLength,
          in: 0...1000,
          step: 1,
          label: {
            StepperTextField(value: viewStore.$lineLength.removeDuplicates())
              .focused(self.$focusedField, equals: .lineLength)
          }
        )
        .help("The maximum allowed length of a line, in characters")
      }
    }
  }

  @MainActor public var lineBreaksView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Line Breaks:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          Toggle(isOn: viewStore.$respectsExistingLineBreaks) {
            Text("Respects existing line breaks")
          }
          .help(
            "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeControlFlowKeywords) {
            Text("Line break before control flow keywords")
          }
          .help(
            "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeEachArgument) {
            Text("Line break before each argument")
          }
          .help(
            "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeEachGenericRequirement) {
            Text("Line break before each generic requirement")
          }
          .help(
            "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.$lineBreakAroundMultilineExpressionChainComponents) {
            Text("Line break around multiline expression chain components")
          }
          .help(
            "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
          )
          Toggle(isOn: viewStore.$prioritizeKeepingFunctionOutputTogether) {
            Text("Prioritize keeping function output together")
          }
          .help(
            "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
          )
          Toggle(isOn: viewStore.$shouldTrimTrailingWhitespace) {
            Text("Trim trailing whitespace before formatting")
          }
          .help(
            "The formatter trims trailing whitespace before formatting, so whitespace only lines won't get joined with the subsequent line."
          )
          HStack(spacing: 0) {
            Text("Maximum blank lines")
            Stepper(
              value: viewStore.$maximumBlankLines,
              in: 0...1000,
              step: 1,
              label: {
                StepperTextField(value: viewStore.$maximumBlankLines.removeDuplicates())
                  .focused(self.$focusedField, equals: .maximumBlankLines)
              }
            )
            .help(
              "The maximum number of consecutive blank lines that are allowed to be present in a source file. Any number larger than this will be collapsed down to the maximum."
            )
          }
        }
      }
    }
  }

  @MainActor public var spacingView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Spacing:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          Toggle(isOn: viewStore.$spacesAroundRangeFormationOperators) {
            Text("Spaces around range formation operators")
          }
          .help(
            "Determines whether whitespace should be forced before and after the range formation operators ... and ..<."
          )
        }
      }
    }
  }

  @MainActor public var trailingCommaView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Trailing Comma:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          Toggle(isOn: viewStore.$multiElementCollectionTrailingCommas) {
            Text("Multi-element collection trailing commas")
          }
          .help("Determines whether multi-element collection literals should have trailing commas.")
        }
      }
    }
  }

  @MainActor public var noAssignmentInExpressionsView: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("No Assignment In Expressions:").alignmentGuide(.trailingLabel) { $0[.trailing] }
      VStack(alignment: .leading, spacing: .grid(1)) {
        NoAssignmentInExpressionsView(
          store: self.store.scope(
            state: \.noAssignmentInExpressionsState,
            action: { .noAssignmentInExpressionsAction($0) }
          )
        )
        .help("Contains exceptions for the NoAssignmentInExpressions rule.").frame(maxWidth: 350)
      }
    }
  }

  @MainActor public var fileScopedDeclarationPrivacyView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .centerNonSiblings, spacing: 0) {
        Text("File-scoped Declaration Privacy:").alignmentGuide(.trailingLabel) { $0[.trailing] }
          .alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
        Picker("", selection: viewStore.$fileScopedDeclarationPrivacy.accessLevel) {
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private)
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate)
        }
        .help(
          "Determines the formal access level (i.e., the level specified in source code) for file-scoped declarations whose effective access level is private to the containing file."
        )
        .fixedSize()
      }
    }
  }

  @State var shouldUnsetFocus: Bool = false

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .trailingLabel, spacing: .grid(2)) {
        self.indentationView
        self.tabWidthView
        self.lineLengthView
        self.lineBreaksView
        self.spacingView
        self.trailingCommaView
        self.fileScopedDeclarationPrivacyView
        self.noAssignmentInExpressionsView
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).contentShape(Rectangle())
      .onTapGesture {
        // WORKAROUND: SwiftUI automatically sets the focus to the last focused text field
        // The task delays the action just enought that the action is sent after the focus change
        Task { viewStore.send(.wholeViewTapped) }
      }
      .bind(viewStore.$focusedField, to: self.$focusedField)

      // disable autofocus when the inital focusedField value is nil
      .onAppear { if viewStore.focusedField == nil { self.shouldUnsetFocus = true } }
      .task { if self.shouldUnsetFocus { self.focusedField = nil } }
    }
  }
}

extension Indent: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { nil }

  public var rawValue: RawValue {
    switch self {
    case .spaces: return "Spaces"
    case .tabs: return "Tabs"
    }
  }

  public var count: Int {
    get {
      switch self {
      case .spaces(let count): return count
      case .tabs(let count): return count
      }
    }
    set {
      switch self {
      case .spaces: self = .spaces(newValue)
      case .tabs: self = .tabs(newValue)
      }
    }
  }
}

@Reducer public struct NoAssignmentInExpressions {
  @Dependency(\.uuid) var uuid

  public init() {}

  public struct State: Equatable {
    public var noAssignmentInExpressionsItems:
      IdentifiedArrayOf<NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem>
    @PresentationState public var noAssignmentInExpressionsListState:
      NoAssignmentInExpressionsList.State?

    public enum EditingState: Equatable {
      case textField
      case popover
    }

    @BindingState public var editingState: EditingState?

    public init(
      noAssignmentInExpressionsItems: IdentifiedArrayOf<
        NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem
      >,
      noAssignmentInExpressionsListState: NoAssignmentInExpressionsList.State? = nil,
      editingState: EditingState?
    ) {
      self.noAssignmentInExpressionsItems = noAssignmentInExpressionsItems
      self.noAssignmentInExpressionsListState = noAssignmentInExpressionsListState
      self.editingState = editingState
    }

    public var noAssignmentInExpressionsItemsText: String {
      self.noAssignmentInExpressionsItems.map(\.text).joined(separator: " ")
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case noAssignmentInExpressionsItemsAction(
      PresentationAction<NoAssignmentInExpressionsList.Action>
    )
    case noAssignmentInExpressionsTextChanged(newValue: String)
    case gearIconTapped
    case textFieldTapped
    case popoverOpened
  }

  public var body: some ReducerOf<Self> {
    CombineReducers {
      BindingReducer()

      Reduce { state, action in
        switch action {
        case .binding: return .none
        case .noAssignmentInExpressionsItemsAction(action: .dismiss):
          state.editingState = nil

          return .none

        case .popoverOpened:
          state.editingState = .popover

          return .none
        case .noAssignmentInExpressionsItemsAction: return .none
        case let .noAssignmentInExpressionsTextChanged(newValue):
          state.noAssignmentInExpressionsItems = IdentifiedArray(
            uniqueElements: newValue.split(separator: " ", omittingEmptySubsequences: false)
              .map {
                NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
                  id: self.uuid(),
                  text: String($0)
                )
              }
          )

          return .none
        case .textFieldTapped:
          state.editingState = .textField

          return .none
        case .gearIconTapped:
          state.noAssignmentInExpressionsItems = state.noAssignmentInExpressionsItems.filter {
            !$0.text.isEmpty
          }
          state.noAssignmentInExpressionsListState = .init(
            noAssignmentInExpressionsItems: state.noAssignmentInExpressionsItems
          )

          // WORKAROUND: SwiftUI automatically sets the focus to the last focused text field
          return .run { send in await send(.popoverOpened) }
        }
      }
      .ifLet(\.$noAssignmentInExpressionsListState, action: \.noAssignmentInExpressionsItemsAction)
      { NoAssignmentInExpressionsList() }
      .onChange(of: \.noAssignmentInExpressionsListState?.noAssignmentInExpressionsItems) {
        _,
        newValue in
        Reduce { state, action in
          guard let newValue else { return .none }

          state.noAssignmentInExpressionsItems = newValue

          return .none
        }
      }
    }
    .onChange(of: \.editingState) { oldValue, newValue in
      Reduce { state, action in
        for i in state.noAssignmentInExpressionsItems.indices {
          let item = state.noAssignmentInExpressionsItems.elements[i]

          state.noAssignmentInExpressionsItems.update(
            .init(
              id: item.id,
              text: item.text.trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: " ", with: "_")
            ),
            at: i
          )
        }

        return .none
      }
    }
  }
}

public struct NoAssignmentInExpressionsView: View {
  let store: StoreOf<NoAssignmentInExpressions>

  public init(store: StoreOf<NoAssignmentInExpressions>) { self.store = store }

  @FocusState var focusedField: NoAssignmentInExpressions.State.EditingState?

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: .grid(2)) {
        TextField(
          "",
          text:
            viewStore.binding(
              get: { $0.noAssignmentInExpressionsItemsText },
              send: { .noAssignmentInExpressionsTextChanged(newValue: $0) }
            )
            .removeDuplicates()
        )
        .focused(self.$focusedField, equals: .textField)
        .help("Contains exceptions for the NoAssignmentInExpressions rule.")
        .frame(maxWidth: .infinity, alignment: .leading)
        self.popupButton
      }
      .bind(viewStore.$editingState, to: self.$focusedField)
    }
  }

  // WORKAROUND: dismissing the popover by clicking on the gear button doesn't trigger the
  // wholeViewTapped action so can't disable focus after that.
  // And we can't always set the focusedField to nil after dismissing since it's possible to dismiss
  // the popover by clicking into a TextField
  var popupButton: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        VStack {
          if viewStore.noAssignmentInExpressionsListState == nil {
            Button(action: { viewStore.send(.gearIconTapped) }) {
              Image(systemName: "gearshape.fill")
            }
          }
        }
        .popover(
          store: self.store.scope(
            state: \.$noAssignmentInExpressionsListState,
            action: { .noAssignmentInExpressionsItemsAction($0) }
          ),
          arrowEdge: .trailing
        ) {
          NoAssignmentInExpressionsListView(store: $0).frame(width: 400, height: 200)
            .padding(.grid(2)).focused(self.$focusedField, equals: .popover)
        }
        if viewStore.noAssignmentInExpressionsListState != nil {
          Button(action: {}) { Image(systemName: "gearshape.fill") }.allowsHitTesting(false)
        }
      }
    }
  }
}

@Reducer public struct NoAssignmentInExpressionsList {
  @Dependency(\.uuid) var uuid

  public init() {}

  public struct State: Equatable {
    public struct NoAssignmentInExpressionsListItem: Equatable, Identifiable {
      public let id: UUID
      public var text: String

      public init(id: UUID, text: String) {
        self.id = id
        self.text = text
      }
    }

    @BindingState public var noAssignmentInExpressionsItems:
      IdentifiedArrayOf<NoAssignmentInExpressionsListItem>
    @BindingState public var selectedItemIds: Set<UUID>
    @BindingState var focusedItemId: UUID? = nil

    public init(
      noAssignmentInExpressionsItems: IdentifiedArrayOf<NoAssignmentInExpressionsListItem>,
      selectedItemIds: Set<UUID> = []
    ) {
      self.noAssignmentInExpressionsItems = noAssignmentInExpressionsItems
      self.selectedItemIds = selectedItemIds
    }

    public var firstSelectedItemIndex: Int? {
      for (index, item) in self.noAssignmentInExpressionsItems.enumerated() {
        if self.selectedItemIds.contains(item.id) { return index }
      }

      return nil
    }
  }

  public enum Action: BindableAction {
    case addButtonTapped
    case binding(BindingAction<State>)
    case move(IndexSet, Int)
    case removeButtonTapped
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.focusedItemId) { oldValue, _ in
        Reduce { state, action in
          guard let oldValue else { return .none }

          guard let previousFocusedItem = state.noAssignmentInExpressionsItems[id: oldValue],
            let itemIndex = state.noAssignmentInExpressionsItems.firstIndex(of: previousFocusedItem)
          else {
            XCTFail("The previously focued item is not found among the items.")

            return .none
          }

          let itemLines = previousFocusedItem.text.split(whereSeparator: \.isNewline)

          guard itemLines.count > 1 else { return .none }

          let newItems: [State.NoAssignmentInExpressionsListItem] = itemLines.dropFirst()
            .map { .init(id: self.uuid(), text: String($0)) }

          state.noAssignmentInExpressionsItems[id: oldValue]?.text = String(itemLines.first!)

          state.noAssignmentInExpressionsItems.insert(
            contentsOf: newItems,
            at: state.noAssignmentInExpressionsItems.index(after: itemIndex)
          )

          return .none
        }
      }

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let newItem: State.NoAssignmentInExpressionsListItem = .init(id: self.uuid(), text: "")

        if state.selectedItemIds.isEmpty {
          state.noAssignmentInExpressionsItems.append(newItem)
        } else {
          guard let firstSelectedIndex = state.firstSelectedItemIndex else {
            XCTFail("The first selected item is not found among the items.")

            return .none
          }

          state.noAssignmentInExpressionsItems.insert(newItem, at: firstSelectedIndex)
        }

        state.focusedItemId = newItem.id
        state.selectedItemIds = [newItem.id]

        return .none
      case .binding: return .none
      case let .move(source, destination):
        state.noAssignmentInExpressionsItems.move(fromOffsets: source, toOffset: destination)

        return .none
      case .removeButtonTapped:
        guard !state.selectedItemIds.isEmpty else { return .none }

        guard let firstSelectedItemIndex = state.firstSelectedItemIndex else {
          XCTFail("The first selected item is not found among the items.")

          return .none
        }

        for id in state.selectedItemIds { state.noAssignmentInExpressionsItems.remove(id: id) }

        state.selectedItemIds = []

        guard !state.noAssignmentInExpressionsItems.isEmpty else { return .none }

        let newItemIndex =
          firstSelectedItemIndex < state.noAssignmentInExpressionsItems.ids.count
          ? firstSelectedItemIndex
          : state.noAssignmentInExpressionsItems.index(before: firstSelectedItemIndex)
        let newItemId = state.noAssignmentInExpressionsItems.ids[newItemIndex]

        state.selectedItemIds.insert(newItemId)

        return .none
      }
    }
  }
}

public struct NoAssignmentInExpressionsListView: View {
  let store: StoreOf<NoAssignmentInExpressionsList>

  public init(store: StoreOf<NoAssignmentInExpressionsList>) { self.store = store }

  @FocusState var focusedField: UUID?

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        List(selection: viewStore.$selectedItemIds) {
          ForEach(viewStore.$noAssignmentInExpressionsItems) { $item in
            TextField("", text: $item.text).focused(self.$focusedField, equals: item.id)
          }
          .onMove { viewStore.send(.move($0, $1)) }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
        .onDeleteCommand { viewStore.send(.removeButtonTapped) }  // doesn't work on ForEach
        HStack(spacing: 0) {
          Button(action: { viewStore.send(.addButtonTapped) }) { Image(systemName: "plus") }
          Button(action: { viewStore.send(.removeButtonTapped) }) { Image(systemName: "minus") }
            .disabled(viewStore.selectedItemIds.isEmpty)
        }
        .buttonStyle(.primary).frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 2).border([.bottom, .leading, .trailing], .borderColor).background()
        .offset(x: 0, y: -1)  // hides the bottom border of the List
      }
      .bind(viewStore.$focusedItemId, to: self.$focusedField)
    }
  }
}

extension Binding where Value: Equatable {
  func removeDuplicates() -> Self {
    .init(
      get: { self.wrappedValue },
      set: { newValue, transaction in
        guard newValue != self.wrappedValue else { return }
        self.transaction(transaction).wrappedValue = newValue
      }
    )
  }
}
