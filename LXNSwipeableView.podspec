Pod::Spec.new do |s|
  s.name                  = 'LXNSwipeableView'
  s.version               = '0.1.0'
  s.summary               = ''
  s.author                = { 'Leszek Kaczor' => 'leszekducker@gmail.com' }
  s.source                = { :git => 'https://bitbucket.org/ducker/responseparser.git' }
  s.source_files          = 'LXNSwipeableView/LXNSwipeableView/*'
  s.requires_arc	  = true
  s.ios.deployment_target = '6.0'
end
