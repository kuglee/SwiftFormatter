import ComposableArchitecture
import ConfigurationWrapper
import StyleGuide
import SwiftUI

public struct FormatterRules: Reducer {
  public init() {}

  public struct State: Equatable {
    @BindingState public var alwaysUseLiteralForEmptyCollectionInit: Bool
    @BindingState public var doNotUseSemicolons: Bool
    @BindingState public var fileScopedDeclarationPrivacy: Bool
    @BindingState public var fullyIndirectEnum: Bool
    @BindingState public var groupNumericLiterals: Bool
    @BindingState public var noAccessLevelOnExtensionDeclaration: Bool
    @BindingState public var noAssignmentInExpressions: Bool
    @BindingState public var noCasesWithOnlyFallthrough: Bool
    @BindingState public var noEmptyTrailingClosureParentheses: Bool
    @BindingState public var noLabelsInCasePatterns: Bool
    @BindingState public var noParensAroundConditions: Bool
    @BindingState public var noVoidReturnOnFunctionSignature: Bool
    @BindingState public var omitExplicitReturns: Bool
    @BindingState public var oneCasePerLine: Bool
    @BindingState public var oneVariableDeclarationPerLine: Bool
    @BindingState public var orderedImports: Bool
    @BindingState public var returnVoidInsteadOfEmptyTuple: Bool
    @BindingState public var useEarlyExits: Bool
    @BindingState public var useExplicitNilCheckInConditions: Bool
    @BindingState public var useShorthandTypeNames: Bool
    @BindingState public var useSingleLinePropertyGetter: Bool
    @BindingState public var useTripleSlashForDocumentationComments: Bool
    @BindingState public var useWhereClausesInForLoops: Bool

    public init(
      alwaysUseLiteralForEmptyCollectionInit: Bool,
      doNotUseSemicolons: Bool,
      fileScopedDeclarationPrivacy: Bool,
      fullyIndirectEnum: Bool,
      groupNumericLiterals: Bool,
      noAccessLevelOnExtensionDeclaration: Bool,
      noAssignmentInExpressions: Bool,
      noCasesWithOnlyFallthrough: Bool,
      noEmptyTrailingClosureParentheses: Bool,
      noLabelsInCasePatterns: Bool,
      noParensAroundConditions: Bool,
      noVoidReturnOnFunctionSignature: Bool,
      omitExplicitReturns: Bool,
      oneCasePerLine: Bool,
      oneVariableDeclarationPerLine: Bool,
      orderedImports: Bool,
      returnVoidInsteadOfEmptyTuple: Bool,
      useEarlyExits: Bool,
      useExplicitNilCheckInConditions: Bool,
      useShorthandTypeNames: Bool,
      useSingleLinePropertyGetter: Bool,
      useTripleSlashForDocumentationComments: Bool,
      useWhereClausesInForLoops: Bool
    ) {
      self.alwaysUseLiteralForEmptyCollectionInit = alwaysUseLiteralForEmptyCollectionInit
      self.doNotUseSemicolons = doNotUseSemicolons
      self.fileScopedDeclarationPrivacy = fileScopedDeclarationPrivacy
      self.fullyIndirectEnum = fullyIndirectEnum
      self.groupNumericLiterals = groupNumericLiterals
      self.noAccessLevelOnExtensionDeclaration = noAccessLevelOnExtensionDeclaration
      self.noAssignmentInExpressions = noAssignmentInExpressions
      self.noCasesWithOnlyFallthrough = noCasesWithOnlyFallthrough
      self.noEmptyTrailingClosureParentheses = noEmptyTrailingClosureParentheses
      self.noLabelsInCasePatterns = noLabelsInCasePatterns
      self.noParensAroundConditions = noParensAroundConditions
      self.noVoidReturnOnFunctionSignature = noVoidReturnOnFunctionSignature
      self.omitExplicitReturns = omitExplicitReturns
      self.oneCasePerLine = oneCasePerLine
      self.oneVariableDeclarationPerLine = oneVariableDeclarationPerLine
      self.orderedImports = orderedImports
      self.returnVoidInsteadOfEmptyTuple = returnVoidInsteadOfEmptyTuple
      self.useEarlyExits = useEarlyExits
      self.useExplicitNilCheckInConditions = useExplicitNilCheckInConditions
      self.useShorthandTypeNames = useShorthandTypeNames
      self.useSingleLinePropertyGetter = useSingleLinePropertyGetter
      self.useTripleSlashForDocumentationComments = useTripleSlashForDocumentationComments
      self.useWhereClausesInForLoops = useWhereClausesInForLoops
    }
  }

  public enum Action: Equatable, BindableAction { case binding(BindingAction<State>) }

  public var body: some ReducerOf<Self> { BindingReducer() }
}

public struct FormatterRulesView: View {
  let store: StoreOf<FormatterRules>

  public init(store: StoreOf<FormatterRules>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text("Enable the rules you want to be applied when formatting.")
        List {
          Toggle(isOn: viewStore.$alwaysUseLiteralForEmptyCollectionInit) {
            Text("Always use literal for empty collection init")
          }
          .help(
            "If enabled, all invalid use sites would be replaced with empty literal (with or without explicit type annotation)"
          )
          Toggle(isOn: viewStore.$doNotUseSemicolons) { Text("Do not use semicolons") }
            .help("If enabled, all semicolons will be replaced with line breaks")
          Toggle(isOn: viewStore.$fileScopedDeclarationPrivacy) {
            Text("File-scoped declaration privacy")
          }
          .help(
            "If enabled, file-scoped declarations that have formal access opposite to the desired access level in the formatter's configuration will have their access level changed"
          )
          Toggle(isOn: viewStore.$fullyIndirectEnum) { Text("Fully indirect enum") }
            .help(
              "If enabled, enums where all cases are indirect will be rewritten such that the enum is marked indirect, and each case is not"
            )
          Toggle(isOn: viewStore.$groupNumericLiterals) { Text("Group numeric literals") }
            .help(
              "If enabled, all numeric literals that should be grouped will have _s inserted where appropriate"
            )
          Toggle(isOn: viewStore.$noAccessLevelOnExtensionDeclaration) {
            Text("No access level on extension declaration")
          }
          .help(
            "If enabled, the access level is removed from the extension declaration and is added to each declaration in the extension; declarations with redundant access levels (e.g. internal, as that is the default access level) have the explicit access level removed"
          )
          Toggle(isOn: viewStore.$noAssignmentInExpressions) {
            Text("No assignment in expressions")
          }
          .help(
            "If enabled, a return statement containing an assignment expression is expanded into two separate statements"
          )
          Toggle(isOn: viewStore.$noCasesWithOnlyFallthrough) {
            Text("No cases with only fallthrough")
          }
          .help(
            "If enabled, the fallthrough case is added as a prefix to the next case unless the next case is default; in that case, the fallthrough case is deleted"
          )
          Toggle(isOn: viewStore.$noEmptyTrailingClosureParentheses) {
            Text("No empty trailing closure parentheses")
          }
          .help(
            "If enabled, empty parentheses in function calls with trailing closures will be removed"
          )
          Toggle(isOn: viewStore.$noLabelsInCasePatterns) { Text("No labels in case patterns") }
            .help("If enabled, redundant labels in case patterns are removed")
          Toggle(isOn: viewStore.$noParensAroundConditions) { Text("No parens around conditions") }
            .help(
              "If enabled, parentheses around such expressions are removed, if they do not cause a parse ambiguity. Specifically, parentheses are allowed if and only if the expression contains a function call with a trailing closure"
            )
          Toggle(isOn: viewStore.$noVoidReturnOnFunctionSignature) {
            Text("No Void return on function signature")
          }
          .help(
            "If enabled, function declarations with explicit returns of () or Void will have their return signature stripped"
          )
          Toggle(isOn: viewStore.$omitExplicitReturns) { Text("Omit explicit returns") }
            .help(
              "If enabled, func <name>() { return ... } constructs will be replaced with equivalent func <name>() { ... } constructs"
            )
          Toggle(isOn: viewStore.$oneCasePerLine) { Text("One case per line") }
            .help(
              "If enabled, all case declarations with associated values or raw values will be moved to their own case declarations"
            )
          Toggle(isOn: viewStore.$oneVariableDeclarationPerLine) {
            Text("One variable declaration per line")
          }
          .help(
            "If enabled, if a variable declaration declares multiple variables, it will be split into multiple declarations, each declaring one of the variables, as long as the result would still be syntactically valid"
          )
          Toggle(isOn: viewStore.$orderedImports) { Text("Ordered imports") }
            .help("If enabled, imports will be reordered and grouped at the top of the file")
          Toggle(isOn: viewStore.$returnVoidInsteadOfEmptyTuple) {
            Text("Return Void instead of empty tuple")
          }
          .help("If enabled, -> () is replaced with -> Void")
          Toggle(isOn: viewStore.$useEarlyExits) { Text("Use early exits") }
            .help(
              "If enabled, if ... else { return/throw/break/continue } constructs will be replaced with equivalent guard ... else { return/throw/break/continue } constructs"
            )
          Toggle(isOn: viewStore.$useExplicitNilCheckInConditions) {
            Text("Use explicit nil check in conditions")
          }
          .help(
            "If enabled, let _ = expr inside a condition list will be replaced by expr != nil"
          )
          Toggle(isOn: viewStore.$useShorthandTypeNames) { Text("Use shorthand type names") }
            .help(
              "If enabled, where possible, shorthand types replace long form types; e.g. Array<Element> is converted to [Element]"
            )
          Toggle(isOn: viewStore.$useSingleLinePropertyGetter) {
            Text("Use single line property getter")
          }
          .help("If enabled, explicit get blocks are rendered implicit by removing the get")
          Toggle(isOn: viewStore.$useTripleSlashForDocumentationComments) {
            Text("Use triple slash for documentation comments")
          }
          .help(
            "If enabled, if a doc block comment appears on its own on a line, or if a doc block comment spans multiple lines without appearing on the same line as code, it will be replaced with multiple doc line comments"
          )
          Toggle(isOn: viewStore.$useWhereClausesInForLoops) {
            Text("Use where clauses in for loops")
          }
          .help(
            "If enabled, for loops that consist of a single if statement have the conditional of that statement factored out to a where clause"
          )
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}
