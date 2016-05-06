Pod::Spec.new do |s|
  s.name                  = 'LXNSwipeableView'
  s.version               = '0.1.0'
  s.summary               = 'This is the repository LXNSwipeableView.'
  s.homepage         	    = "https://github.com/3nderapp/LXNSwipeableView"
  s.license          	    = 'MIT'
  s.author                = { 'Leszek Kaczor' => 'leszekducker@gmail.com' }
  s.source                = { :git => "https://github.com/3nderapp/LXNSwipeableView.git", :tag => s.version.to_s }
  s.source_files          = 'LXNSwipeableView/LXNSwipeableView/*'
  s.requires_arc	 	      = true
  s.ios.deployment_target = '6.0'
end
