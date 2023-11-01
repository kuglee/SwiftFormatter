import SwiftFormat

public struct ConfigurationWrapper: Equatable {
  private var configuration: Configuration

  public func toConfiguration() -> Configuration { self.configuration }

  public init(configuration: Configuration = Configuration()) { self.configuration = configuration }

  public var maximumBlankLines: Int {
    get { self.configuration.maximumBlankLines }
    set { self.configuration.maximumBlankLines = newValue }
  }
  public var lineLength: Int {
    get { self.configuration.lineLength }
    set { self.configuration.lineLength = newValue }
  }
  public var tabWidth: Int {
    get { self.configuration.tabWidth }
    set { self.configuration.tabWidth = newValue }
  }
  public var indentation: Indent {
    get { self.configuration.indentation }
    set { self.configuration.indentation = newValue }
  }
  public var respectsExistingLineBreaks: Bool {
    get { self.configuration.respectsExistingLineBreaks }
    set { self.configuration.respectsExistingLineBreaks = newValue }
  }
  public var lineBreakBeforeControlFlowKeywords: Bool {
    get { self.configuration.lineBreakBeforeControlFlowKeywords }
    set { self.configuration.lineBreakBeforeControlFlowKeywords = newValue }
  }
  public var lineBreakBeforeEachArgument: Bool {
    get { self.configuration.lineBreakBeforeEachArgument }
    set { self.configuration.lineBreakBeforeEachArgument = newValue }
  }
  public var lineBreakBeforeEachGenericRequirement: Bool {
    get { self.configuration.lineBreakBeforeEachGenericRequirement }
    set { self.configuration.lineBreakBeforeEachGenericRequirement = newValue }
  }
  public var prioritizeKeepingFunctionOutputTogether: Bool {
    get { self.configuration.prioritizeKeepingFunctionOutputTogether }
    set { self.configuration.prioritizeKeepingFunctionOutputTogether = newValue }
  }
  public var indentConditionalCompilationBlocks: Bool {
    get { self.configuration.indentConditionalCompilationBlocks }
    set { self.configuration.indentConditionalCompilationBlocks = newValue }
  }
  public var lineBreakAroundMultilineExpressionChainComponents: Bool {
    get { self.configuration.lineBreakAroundMultilineExpressionChainComponents }
    set { self.configuration.lineBreakAroundMultilineExpressionChainComponents = newValue }
  }
  public var indentSwitchCaseLabels: Bool {
    get { self.configuration.indentSwitchCaseLabels }
    set { self.configuration.indentSwitchCaseLabels = newValue }
  }
  public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration {
    get { self.configuration.fileScopedDeclarationPrivacy }
    set { self.configuration.fileScopedDeclarationPrivacy = newValue }
  }
  public var spacesAroundRangeFormationOperators: Bool {
    get { self.configuration.spacesAroundRangeFormationOperators }
    set { self.configuration.spacesAroundRangeFormationOperators = newValue }
  }
  public var noAssignmentInExpressions: NoAssignmentInExpressionsConfiguration {
    get { self.configuration.noAssignmentInExpressions }
    set { self.configuration.noAssignmentInExpressions = newValue }
  }
  public var multiElementCollectionTrailingCommas: Bool {
    get { self.configuration.multiElementCollectionTrailingCommas }
    set { self.configuration.multiElementCollectionTrailingCommas = newValue }
  }

  public struct Rules: Equatable {
    public var alwaysUseLiteralForEmptyCollectionInit: Bool
    public var doNotUseSemicolons: Bool
    public var fileScopedDeclarationPrivacy: Bool
    public var fullyIndirectEnum: Bool
    public var groupNumericLiterals: Bool
    public var noAccessLevelOnExtensionDeclaration: Bool
    public var noAssignmentInExpressions: Bool
    public var noCasesWithOnlyFallthrough: Bool
    public var noEmptyTrailingClosureParentheses: Bool
    public var noLabelsInCasePatterns: Bool
    public var noParensAroundConditions: Bool
    public var noVoidReturnOnFunctionSignature: Bool
    public var omitExplicitReturns: Bool
    public var oneCasePerLine: Bool
    public var oneVariableDeclarationPerLine: Bool
    public var orderedImports: Bool
    public var returnVoidInsteadOfEmptyTuple: Bool
    public var useEarlyExits: Bool
    public var useExplicitNilCheckInConditions: Bool
    public var useShorthandTypeNames: Bool
    public var useSingleLinePropertyGetter: Bool
    public var useTripleSlashForDocumentationComments: Bool
    public var useWhereClausesInForLoops: Bool

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

  private let defaultRules = Configuration().rules

  private enum RuleKey: String, CaseIterable {
    case alwaysUseLiteralForEmptyCollectionInit = "AlwaysUseLiteralForEmptyCollectionInit"
    case doNotUseSemicolons = "DoNotUseSemicolons"
    case fileScopedDeclarationPrivacy = "FileScopedDeclarationPrivacy"
    case fullyIndirectEnum = "FullyIndirectEnum"
    case groupNumericLiterals = "GroupNumericLiterals"
    case noAccessLevelOnExtensionDeclaration = "NoAccessLevelOnExtensionDeclaration"
    case noAssignmentInExpressions = "NoAssignmentInExpressions"
    case noCasesWithOnlyFallthrough = "NoCasesWithOnlyFallthrough"
    case noEmptyTrailingClosureParentheses = "NoEmptyTrailingClosureParentheses"
    case noLabelsInCasePatterns = "NoLabelsInCasePatterns"
    case noParensAroundConditions = "NoParensAroundConditions"
    case noVoidReturnOnFunctionSignature = "NoVoidReturnOnFunctionSignature"
    case omitExplicitReturns = "OmitExplicitReturns"
    case oneCasePerLine = "OneCasePerLine"
    case oneVariableDeclarationPerLine = "OneVariableDeclarationPerLine"
    case orderedImports = "OrderedImports"
    case returnVoidInsteadOfEmptyTuple = "ReturnVoidInsteadOfEmptyTuple"
    case useEarlyExits = "UseEarlyExits"
    case useExplicitNilCheckInConditions = "UseExplicitNilCheckInConditions"
    case useShorthandTypeNames = "UseShorthandTypeNames"
    case useSingleLinePropertyGetter = "UseSingleLinePropertyGetter"
    case useTripleSlashForDocumentationComments = "UseTripleSlashForDocumentationComments"
    case useWhereClausesInForLoops = "UseWhereClausesInForLoops"
  }

  public var rules: Rules {
    get {
      func getRuleValue(key: RuleKey) -> Bool {
        self.configuration.rules[key.rawValue] ?? self.defaultRules[key.rawValue]!
      }

      return Rules(
        alwaysUseLiteralForEmptyCollectionInit: getRuleValue(
          key: .alwaysUseLiteralForEmptyCollectionInit
        ),
        doNotUseSemicolons: getRuleValue(key: .doNotUseSemicolons),
        fileScopedDeclarationPrivacy: getRuleValue(key: .fileScopedDeclarationPrivacy),
        fullyIndirectEnum: getRuleValue(key: .fullyIndirectEnum),
        groupNumericLiterals: getRuleValue(key: .groupNumericLiterals),
        noAccessLevelOnExtensionDeclaration: getRuleValue(
          key: .noAccessLevelOnExtensionDeclaration
        ),
        noAssignmentInExpressions: getRuleValue(key: .noAssignmentInExpressions),
        noCasesWithOnlyFallthrough: getRuleValue(key: .noCasesWithOnlyFallthrough),
        noEmptyTrailingClosureParentheses: getRuleValue(key: .noEmptyTrailingClosureParentheses),
        noLabelsInCasePatterns: getRuleValue(key: .noLabelsInCasePatterns),
        noParensAroundConditions: getRuleValue(key: .noParensAroundConditions),
        noVoidReturnOnFunctionSignature: getRuleValue(key: .noVoidReturnOnFunctionSignature),
        omitExplicitReturns: getRuleValue(key: .omitExplicitReturns),
        oneCasePerLine: getRuleValue(key: .oneCasePerLine),
        oneVariableDeclarationPerLine: getRuleValue(key: .oneVariableDeclarationPerLine),
        orderedImports: getRuleValue(key: .orderedImports),
        returnVoidInsteadOfEmptyTuple: getRuleValue(key: .returnVoidInsteadOfEmptyTuple),
        useEarlyExits: getRuleValue(key: .useEarlyExits),
        useExplicitNilCheckInConditions: getRuleValue(key: .useExplicitNilCheckInConditions),
        useShorthandTypeNames: getRuleValue(key: .useShorthandTypeNames),
        useSingleLinePropertyGetter: getRuleValue(key: .useSingleLinePropertyGetter),
        useTripleSlashForDocumentationComments: getRuleValue(
          key: .useTripleSlashForDocumentationComments
        ),
        useWhereClausesInForLoops: getRuleValue(key: .useWhereClausesInForLoops)
      )
    }
    set {
      self.configuration.rules[RuleKey.alwaysUseLiteralForEmptyCollectionInit.rawValue] =
        newValue.alwaysUseLiteralForEmptyCollectionInit
      self.configuration.rules[RuleKey.doNotUseSemicolons.rawValue] = newValue.doNotUseSemicolons
      self.configuration.rules[RuleKey.fileScopedDeclarationPrivacy.rawValue] =
        newValue.fileScopedDeclarationPrivacy
      self.configuration.rules[RuleKey.fullyIndirectEnum.rawValue] = newValue.fullyIndirectEnum
      self.configuration.rules[RuleKey.groupNumericLiterals.rawValue] =
        newValue.groupNumericLiterals
      self.configuration.rules[RuleKey.noAccessLevelOnExtensionDeclaration.rawValue] =
        newValue.noAccessLevelOnExtensionDeclaration
      self.configuration.rules[RuleKey.noAssignmentInExpressions.rawValue] =
        newValue.noAssignmentInExpressions
      self.configuration.rules[RuleKey.noCasesWithOnlyFallthrough.rawValue] =
        newValue.noCasesWithOnlyFallthrough
      self.configuration.rules[RuleKey.noEmptyTrailingClosureParentheses.rawValue] =
        newValue.noEmptyTrailingClosureParentheses
      self.configuration.rules[RuleKey.noLabelsInCasePatterns.rawValue] =
        newValue.noLabelsInCasePatterns
      self.configuration.rules[RuleKey.noParensAroundConditions.rawValue] =
        newValue.noParensAroundConditions
      self.configuration.rules[RuleKey.noVoidReturnOnFunctionSignature.rawValue] =
        newValue.noVoidReturnOnFunctionSignature
      self.configuration.rules[RuleKey.oneCasePerLine.rawValue] = newValue.oneCasePerLine
      self.configuration.rules[RuleKey.oneVariableDeclarationPerLine.rawValue] =
        newValue.oneVariableDeclarationPerLine
      self.configuration.rules[RuleKey.orderedImports.rawValue] = newValue.orderedImports
      self.configuration.rules[RuleKey.returnVoidInsteadOfEmptyTuple.rawValue] =
        newValue.returnVoidInsteadOfEmptyTuple
      self.configuration.rules[RuleKey.omitExplicitReturns.rawValue] = newValue.omitExplicitReturns
      self.configuration.rules[RuleKey.useEarlyExits.rawValue] = newValue.useEarlyExits
      self.configuration.rules[RuleKey.useExplicitNilCheckInConditions.rawValue] =
        newValue.useExplicitNilCheckInConditions
      self.configuration.rules[RuleKey.useShorthandTypeNames.rawValue] =
        newValue.useShorthandTypeNames
      self.configuration.rules[RuleKey.useSingleLinePropertyGetter.rawValue] =
        newValue.useSingleLinePropertyGetter
      self.configuration.rules[RuleKey.useTripleSlashForDocumentationComments.rawValue] =
        newValue.useTripleSlashForDocumentationComments
      self.configuration.rules[RuleKey.useWhereClausesInForLoops.rawValue] =
        newValue.useWhereClausesInForLoops
    }
  }
}
