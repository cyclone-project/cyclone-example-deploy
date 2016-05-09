#wordpress installation script, adds the necessary config for wp and its plugins to the db
require 'json'
require 'fileutils'

puts %x{bash /opt/wp-parent-entrypoint.sh apache2}
#info on wp cli installation
puts %x{wp --info --allow-root}

#install wp - just add the entries in the database no wp.zip extraction
puts 'initializing the database'
puts %x{wp core install --allow-root}

#install and activate generic-openid-connect plugin
puts %x{wp plugin install /etc/wordpress-config/generic-openid-connect.1.0.zip --activate --allow-root --force}

class FileReader
  def read
    file = File.open("/etc/wordpress-config/openidConfig.json", "rb")
    #file = File.open("openidConfig.json", "rb")
    file.read
  end
end

fileReader = FileReader.new
fileContents = fileReader.read
openIdConfig = JSON.parse(fileContents)


# Replace the base URL if we have it set as an ENV variable
if !ENV["CYCLONE_KEYCLOAK_PORT_8080_TCP_ADDR"].nil?
  openIdConfig["gen_openid_con_ep_login"] = openIdConfig["gen_openid_con_ep_login"].sub! 'cyclone-samlbridge', ENV["CYCLONE_KEYCLOAK_PORT_8080_TCP_ADDR"]
  openIdConfig["gen_openid_con_ep_token"] = openIdConfig["gen_openid_con_ep_token"].sub! 'cyclone-samlbridge', ENV["CYCLONE_KEYCLOAK_PORT_8080_TCP_ADDR"]
  openIdConfig["gen_openid_con_ep_userinfo"] = openIdConfig["gen_openid_con_ep_userinfo"].sub! 'cyclone-samlbridge', ENV["CYCLONE_KEYCLOAK_PORT_8080_TCP_ADDR"]
end


openIdConfig.each do |key,value|
puts %x{wp option update #{key} '#{value}' --allow-root}
end

openIdConfig.each do |key,value|
puts %x{wp option get #{key} --allow-root}
end

#copy .htaccess
FileUtils.cp('/etc/wordpress-config/.htaccess', '/var/www/html')

#copy pre configured wp-config.php TODO change if the parent image works now

%x{apachectl -k start && tail -f /dev/null}
