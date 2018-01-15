//
//  IULIACodeGenerator.swift
//  IRGen
//
//  Created by Franklin Schrans on 12/28/17.
//

import AST

public struct IULIACodeGenerator {
  var topLevelModule: TopLevelModule
  var context: Context

  public init(topLevelModule: TopLevelModule, context: Context) {
    self.topLevelModule = topLevelModule
    self.context = context
  }

  public func generateCode() -> String {
    var contracts = [IULIAContract]()
    var interfaces = [IULIAInterface]()

    for case .contractDeclaration(let contractDeclaration) in topLevelModule.declarations {
      let behaviorDeclarations: [ContractBehaviorDeclaration] = topLevelModule.declarations.flatMap { declaration in
        guard case .contractBehaviorDeclaration(let contractBehaviorDeclaration) = declaration else {
          return nil
        }

        guard contractBehaviorDeclaration.contractIdentifier == contractDeclaration.identifier else {
          return nil
        }

        return contractBehaviorDeclaration
      }
      let contract = IULIAContract(contractDeclaration: contractDeclaration, contractBehaviorDeclarations: behaviorDeclarations, context: context)
      contracts.append(contract)
      interfaces.append(IULIAInterface(contract: contract, context: context))
    }

    let renderedContracts = contracts.map({ $0.rendered() }).joined(separator: "\n")
    let renderedInterfaces = interfaces.map({ $0.rendered() }).joined(separator: "\n")

    return renderedContracts + "\n" + renderedInterfaces
  }
}

struct Statement {
  var content: String
}
