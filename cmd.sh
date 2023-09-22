echo "configuring opencart"

# Rename the configuration files if they exist (config-dist.php -> config.php)
test -f config-dist.php &&  mv config-dist.php config.php ;
test -f admin/config-dist.php &&  mv admin/config-dist.php admin/config.php ;
# Set permissions for the configuration files
chmod 0777 config.php; \
chmod 0777 admin/config.php;

# Check if an "install" directory exists
if [ -d "install" ] 
then
  echo "Installing..."
  # Execute the OpenCart installation script with provided parameters
  php install/cli_install.php install --username    $ADMIN_USERNAME \
                                      --email       $ADMIN_EMAIL \
                                      --password    $ADMIN_PASSWORD \
                                      --http_server $HTTP_SERVER \
                                      --db_driver   $DB_DRIVER \
                                      --db_hostname $DB_HOSTNAME \
                                      --db_username $DB_USERNAME \
                                      --db_password $DB_PASSWORD \
                                      --db_database $DB_DATABASE \
			              --db_port     $DB_PORT \
                                      --db_prefix   $DB_PREFIX &&
  # Remove the "install" directory after installation is complete
  rm -rf install
else
  echo "No install directoty detected"
fi
# Start the Apache web server using the default foreground process
apache2-foreground
