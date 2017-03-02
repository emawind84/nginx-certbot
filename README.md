# Generate SSL Certificates With LetsEncrypt using Docker

## Configuration

Environment Variables required:

- **CERTBOT_CERTS_PATH** 
    
    The location where the certificates will be saved

- **CERTBOT_STANDALONE**
    
    Can have value `true` or `false`, if you don't have a web server running use the former otherwise the latter.

- **CERTBOT_WEBROOT**

    If `CERTBOT_STANDALONE` is `false` you need to specify a web folder that certbot can use for his job. 

- **CERTBOT_HOST**

    Domain to apply the certificates

- **CERTBOT_EMAIL**

    Email used for registration and recovery contact

Edit the file .bashrc inside the user home folder and add the following variables
and make sure you change the values accordingly:

    export CERTBOT_CERTS_PATH=/etc/letsencrypt
    export CERTBOT_STANDALONE=false
    export CERTBOT_HOST=dev.sangah.com
    export CERTBOT_EMAIL=pmis@sangah.com
    export CERTBOT_WEBROOT=/var/www

...or you can change the values inside the file `.env` inside this folder.

Run the service with the following command, replacing the host and email accordingly:

- Use this for no standalone version

        $ docker-compose up

- Use this for standalone version

        $ docker-compose -f docker-compose-standalone.yml up

After the process is terminated certificates will be generated inside the folder
configured with the variable `CERTBOT_CERTS_PATH`.
