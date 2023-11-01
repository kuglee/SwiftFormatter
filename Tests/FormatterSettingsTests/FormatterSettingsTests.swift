import ComposableArchitecture
import SwiftFormat
import XCTest

@testable import FormatterSettings

@MainActor final class FormatterSettingsTests: XCTestCase {
  func testSetBindings() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(.set(\.$shouldTrimTrailingWhitespace, true)) {
      $0.shouldTrimTrailingWhitespace = true
    }
    await store.send(.set(\.$maximumBlankLines, 1)) { $0.maximumBlankLines = 1 }
    await store.send(.set(\.$lineLength, 1)) { $0.lineLength = 1 }
    await store.send(.set(\.$tabWidth, 1)) { $0.tabWidth = 1 }
    await store.send(.set(\.$indentation, .spaces(1))) { $0.indentation = .spaces(1) }
    await store.send(.set(\.$indentation, .spaces(2))) { $0.indentation = .spaces(2) }
    await store.send(.set(\.$indentation, .tabs(2))) { $0.indentation = .tabs(2) }
    await store.send(.set(\.$respectsExistingLineBreaks, true)) {
      $0.respectsExistingLineBreaks = true
    }
    await store.send(.set(\.$lineBreakBeforeControlFlowKeywords, true)) {
      $0.lineBreakBeforeControlFlowKeywords = true
    }
    await store.send(.set(\.$lineBreakBeforeEachArgument, true)) {
      $0.lineBreakBeforeEachArgument = true
    }
    await store.send(.set(\.$lineBreakBeforeEachGenericRequirement, true)) {
      $0.lineBreakBeforeEachGenericRequirement = true
    }
    await store.send(.set(\.$prioritizeKeepingFunctionOutputTogether, true)) {
      $0.prioritizeKeepingFunctionOutputTogether = true
    }
    await store.send(.set(\.$indentConditionalCompilationBlocks, true)) {
      $0.indentConditionalCompilationBlocks = true
    }
    await store.send(.set(\.$lineBreakAroundMultilineExpressionChainComponents, true)) {
      $0.lineBreakAroundMultilineExpressionChainComponents = true
    }
    await store.send(.set(\.$indentSwitchCaseLabels, true)) { $0.indentSwitchCaseLabels = true }
    await store.send(
      .set(
        \.$fileScopedDeclarationPrivacy,
        {
          var fileScopedDeclarationPrivacyConfiguration =
            FileScopedDeclarationPrivacyConfiguration()
          fileScopedDeclarationPrivacyConfiguration.accessLevel = .fileprivate

          return fileScopedDeclarationPrivacyConfiguration
        }()
      )
    ) {
      $0.fileScopedDeclarationPrivacy = {
        var fileScopedDeclarationPrivacyConfiguration = FileScopedDeclarationPrivacyConfiguration()
        fileScopedDeclarationPrivacyConfiguration.accessLevel = .fileprivate

        return fileScopedDeclarationPrivacyConfiguration
      }()
    }
    await store.send(.set(\.$spacesAroundRangeFormationOperators, true)) {
      $0.spacesAroundRangeFormationOperators = true
    }
    await store.send(.set(\.$multiElementCollectionTrailingCommas, true)) {
      $0.multiElementCollectionTrailingCommas = true
    }
  }

  func testWholeViewTapped() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
            ],
            selectedItemIds: [UUID(uuidString: "00000000-0000-0000-0000-000000000000")!]
          ),
          editingState: .popover
        ),
        focusedField: .indentationLength
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(.wholeViewTapped) {
      $0.noAssignmentInExpressionsState.editingState = nil
      $0.focusedField = nil
    }
  }

  func testGearIconTapped() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(.noAssignmentInExpressionsAction(action: .gearIconTapped)) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState = .init(
        noAssignmentInExpressionsItems: [])
      $0.noAssignmentInExpressionsState.editingState = nil
    }

    await store.receive(.noAssignmentInExpressionsAction(action: .popoverOpened)) {
      $0.noAssignmentInExpressionsState.editingState = .popover
      $0.focusedField = .noAssignmentInExpressions(.popover)
    }
  }

  func testNoAssignmentInExpressionsTextFieldTapped() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(.noAssignmentInExpressionsAction(action: .textFieldTapped)) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState = nil
      $0.noAssignmentInExpressionsState.editingState = .textField
      $0.focusedField = .noAssignmentInExpressions(.textField)
    }
  }

  func testNoAssignmentInExpressionsTextChangedSingleItem() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .incrementing }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsTextChanged(newValue: "test")
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            text: "test"
          )
        ])

    }
  }

  func testNoAssignmentInExpressionsTextChangedMultipleItemsSingleSpace() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .incrementing }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsTextChanged(newValue: "test1 test2")
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            text: "test1"
          ),
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            text: "test2"
          )
        ])
    }
  }

  func testNoAssignmentInExpressionsTextChangedMultipleItemsMultipleSpaces() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          editingState: nil
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .incrementing }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsTextChanged(newValue: "test1  test2")
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            text: "test1"
          ),
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            text: ""
          ),
          NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            text: "test2"
          )
        ])
    }
  }

  func testNoAssignmentInExpressionsListAddButtonTappedEmptyList() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: []),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .incrementing }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.addButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = UUID(
        uuidString: "00000000-0000-0000-0000-000000000000"
      )!
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "")
        ])
    }
  }

  func
    testNoAssignmentInExpressionsListAddButtonTappedNonEmptyListEmptySelectionNewItemInsertedAtTheEnd()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ]),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .constant(UUID(uuidString: "00000000-0000-0000-0000-000000000001")!) }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.addButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = UUID(
        uuidString: "00000000-0000-0000-0000-000000000001"
      )!
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "")
        ])
    }
  }

  func
    testNoAssignmentInExpressionsListAddButtonTappedNonEmptyListSingleSelectionNewItemInsertedBeforeSelected()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
            ],
            selectedItemIds: [UUID(uuidString: "00000000-0000-0000-0000-000000000000")!]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .constant(UUID(uuidString: "00000000-0000-0000-0000-000000000001")!) }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.addButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: ""),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = UUID(
        uuidString: "00000000-0000-0000-0000-000000000001"
      )!
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: ""),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
        ])
    }
  }

  func testNoAssignmentInExpressionsListAddButtonTappedNonEmptyList() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ]),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    ) { $0.uuid = .constant(UUID(uuidString: "00000000-0000-0000-0000-000000000001")!) }

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.addButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = UUID(
        uuidString: "00000000-0000-0000-0000-000000000001"
      )!
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "")
        ])
    }
  }

  func testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListEmptySelection() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ]),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    )
  }

  func testNoAssignmentInExpressionsListRemoveButtonTappedSingleElementListSingleSelection() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
            ],
            selectedItemIds: [UUID(uuidString: "00000000-0000-0000-0000-000000000000")!]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = []
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = []
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = []
    }
  }

  func
    testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListSingleSelectionNextElementIsSelected()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
            ],
            selectedItemIds: [UUID(uuidString: "00000000-0000-0000-0000-000000000001")!]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
      ]
    }
  }

  func
    testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListContiguousMultipleSelectionsNextElementIsSelected()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
            ],
            selectedItemIds: [
              UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
              UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
            ]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
      ]
    }
  }

  func
    testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListNonContiguousMultipleSelectionsFirstElementAfterSelectionIsSelectedSingleElementGap()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
            ],
            selectedItemIds: [
              UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
              UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
            ]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
      ]
    }
  }

  func
    testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListNonContiguousMultipleSelectionsFirstElementAfterSelectionIsSelectedMultiElementGap()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, text: "test4")
            ],
            selectedItemIds: [
              UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
              UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
            ]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
      ]
    }
  }

  func
    testNoAssignmentInExpressionsListRemoveButtonTappedNonEmptyListLastSingleSelectionPreviousElementIsSelected()
    async
  {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
          ],
          noAssignmentInExpressionsListState: .init(
            noAssignmentInExpressionsItems: [
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
              .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, text: "test3")
            ],
            selectedItemIds: [UUID(uuidString: "00000000-0000-0000-0000-000000000002")!]
          ),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.removeButtonTapped))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.focusedItemId = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?.selectedItemIds = [
        UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
      ]
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = [
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
        .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2")
      ]
    }
  }

  func testNoAssignmentInExpressionsListMove() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2")
          ],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1"),
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2")
          ]),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(
        action: .noAssignmentInExpressionsItemsAction(.presented(.move([1], 0)))
      )
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState?
        .noAssignmentInExpressionsItems = IdentifiedArray(uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
        ])
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, text: "test2"),
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test1")
        ])
    }
  }

  func testNoAssignmentInExpressionsListTextWithSpacesDismiss() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        multiElementCollectionTrailingCommas: false,
        noAssignmentInExpressionsState: NoAssignmentInExpressions.State(
          noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test test")
          ],
          noAssignmentInExpressionsListState: .init(noAssignmentInExpressionsItems: [
            .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test test")
          ]),
          editingState: .popover
        )
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(
      .noAssignmentInExpressionsAction(action: .noAssignmentInExpressionsItemsAction(.dismiss))
    ) {
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsListState = nil
      $0.noAssignmentInExpressionsState.editingState = nil
      $0.noAssignmentInExpressionsState.noAssignmentInExpressionsItems = IdentifiedArray(
        uniqueElements: [
          .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, text: "test_test")
        ])
    }
  }
}
