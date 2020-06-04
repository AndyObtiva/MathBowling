require 'glimmer/rake_task'

Glimmer::Package.javapackager_extra_args =
  # General Options
  " -native #{ENV['NATIVE']}" +
  " -name 'Math Bowling 2'" +
  " -title 'Math Bowling 2'" +
  " -Bicon='images/math-bowling-logo.png'" +
  # Linux Options 
  " -BlicenseType=MIT" +
  " -Bcopyright='Copyright (c) 2019-2020 Andy Maleh.'" +
  " -Bcategory='Game'" +
  " -Bvendor='Andy Maleh'" +
  # Mac Options
  " -Bmac.CFBundleName='Math Bowling 2'" +
  " -Bmac.CFBundleIdentifier=org.andymaleh.application.MathBowling2" +
  " -Bmac.category=public.app-category.educational-games" +
  " -Bmac.signing-key-developer-id-app='Andy Maleh'"      
