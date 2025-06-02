//
//  Domain.swift
//  Templates
//
//  Created by Jiyeon on 5/31/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("feature")
fileprivate let author: Template.Attribute = .required("author")

/// 파일 경로
fileprivate let DomainPath: String = "Projects/Domain/\(name)"

let domainTemplate = Template(
  description: "Domain Project Template",
  attributes: [
    name,
    author
  ],
  items: [
    // interface project
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Project.swift",
      templatePath: "domain_project_interface.stencil"
    ),
    // repository
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/\(name)Repository.swift",
      templatePath: "domain_repository.stencil"
    ),
    // usecase interface
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/UseCases/\(name)UseCase.swift",
      templatePath: "domain_usecase_interface.stencil"
    ),
    // entity
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/Entity/\(name)Entity.swift",
      templatePath: "domain_entity.stencil"
    ),
    // dependency key
    .file(
      path: "\(DomainPath)/\(name)DomainInterface/Sources/DependencyKey/\(name)UseCaseKey.swift",
      templatePath: "domain_dependencyKey.stencil"
    ),
    // implement project
    .file(
      path: "\(DomainPath)/\(name)Domain/Project.swift",
      templatePath: "domain_usecase_implement.stencil"
    ),
    // usecase implement
    .file(
      path: "\(DomainPath)/\(name)Domain/Sources/\(name)UseCaseImpl.swift",
      templatePath: "domain_usecase_implement.stencil"
    ),
    // test
    .file(
      path: "\(DomainPath)/\(name)DomainTesting/Sources/\(name)UseCaseTests.swift",
      templatePath: "domain_usecase_test.stencil"
    )
  ]
)
