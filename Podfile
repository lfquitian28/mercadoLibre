# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'
workspace 'mercadoLibre.xcworkspace'
project 'mercadoLibre.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def development_pod
  networking_pod
  products_search_pod
end

def products_search_pod
    pod 'ProductsSearch', :path => 'DevPods/ProductsSearch', :testspecs => ['Tests']
end
target 'mercadoLibre' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for mercadoLibre
  development_pod

  target 'mercadoLibreTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mercadoLibreUITests' do
    # Pods for testinga
  end
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
end

target 'ProductsSearch_Example' do
  use_frameworks!
  project 'DevPods/ProductsSearch/Example/ProductsSearch.xcodeproj'
  
  products_search_pod
end

