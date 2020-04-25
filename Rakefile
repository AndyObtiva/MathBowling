require 'glimmer/rake_task'

VERSION = File.read(File.expand_path('../VERSION',__FILE__)).split("\n").first
 
Glimmer::Package.javapackager_extra_args =
  " -native dmg" +
  " -name 'Math Bowling'" +
  " -srcfiles LICENSE.txt" +
#   " -BmainJar=MathBowling.jar" +
  " -BappVersion=#{VERSION}" +
  " -BlicenseFile=LICENSE.txt" +
  " -BlicenseType=MIT" +
  " -Bmac.CFBundleVersion=#{VERSION}" +
  " -Bmac.CFBundleIdentifier=org.andymaleh.application.MathBowling" +
  " -Bmac.category=arithmetic" +
  " -Bmac.signing-key-developer-id-app='Andy Maleh'"
