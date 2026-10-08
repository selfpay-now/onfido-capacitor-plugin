# The Entrust IDV iOS SDK is distributed only through Swift Package Manager, and a podspec cannot
# declare an SPM dependency. Call this from the app's Podfile post_install to add the package:
#   - to the SelfpaynowOnfido pod target, so the plugin can import and link the SDK;
#   - to the app target, so Xcode embeds the SDK's dynamic frameworks in the app bundle.
#
#   require_relative '../../node_modules/selfpaynow-onfido/ios/spm_dependency'
#   post_install do |installer|
#     selfpaynow_onfido_spm_post_install(installer)
#   end

# Keep in sync with Package.swift
ENTRUST_IDV_SPM_URL = 'https://github.com/entrustCorporation/IdvSdk-iOS'.freeze
ENTRUST_IDV_SPM_VERSION = '100.17.0'.freeze
# Studio workflows resolve their tasks at runtime, so every task module the workflow may use is needed.
ENTRUST_IDV_SPM_PRODUCTS = %w[EntrustIdv Welcome Consent Document NFC FacePhoto FaceMotion Retry].freeze

def selfpaynow_onfido_spm_post_install(installer, app_target_name: 'App')
  pod_target = installer.pods_project.targets.find { |target| target.name == 'SelfpaynowOnfido' }
  raise '[selfpaynow-onfido] SelfpaynowOnfido pod target not found' if pod_target.nil?

  # The Pods project is written by CocoaPods after post_install.
  selfpaynow_onfido_add_entrust_idv_package(installer.pods_project, pod_target)

  installer.aggregate_targets.map(&:user_project).uniq.each do |user_project|
    app_target = user_project.targets.find { |target| target.name == app_target_name }
    next if app_target.nil?

    selfpaynow_onfido_add_entrust_idv_package(user_project, app_target)
    user_project.save
  end
end

def selfpaynow_onfido_add_entrust_idv_package(project, target)
  package = project.root_object.package_references.find do |reference|
    reference.respond_to?(:repositoryURL) && reference.repositoryURL == ENTRUST_IDV_SPM_URL
  end

  if package.nil?
    package = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
    package.repositoryURL = ENTRUST_IDV_SPM_URL
    project.root_object.package_references << package
  end
  package.requirement = { 'kind' => 'exactVersion', 'version' => ENTRUST_IDV_SPM_VERSION }

  ENTRUST_IDV_SPM_PRODUCTS.each do |product_name|
    next if target.package_product_dependencies.any? { |dependency| dependency.product_name == product_name }

    dependency = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
    dependency.package = package
    dependency.product_name = product_name
    target.package_product_dependencies << dependency

    build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
    build_file.product_ref = dependency
    target.frameworks_build_phase.files << build_file
  end
end
