# securityonion-sublime
## Ingest Sublime Security email alerts into Security Onion

![image](https://user-images.githubusercontent.com/16829864/222842071-4f277c26-2ad7-4344-a9e8-a948c65910fa.png)

### NOTE: This script is NOT an officially supported Security Onion integration, and is not intended for production use. It is an example of how you can set up similar configuration in your environment. 

By default, traffic from the webhook to the Security Onion instance is not encrypted. This requires additional configuration within `/opt/so/saltstack/local/salt/logstash/pipelines/config/so/0001_input_sublime.conf`.

This script will set up the necessary components to ingest [Sublime Security](https://sublime.security/) alerts into Security Onion via webhooks, an Elasticsearch ingest pipeline, and an HTTP endpoint published by Logstash on `TCP` port `8228`. Firewall configuration is also configured as necessary, although, you may need to use `so-firewall` to create additional exceptions.

In addition to the data pipeline, a [SOC action](https://docs.securityonion.net/en/2.3/soc-customization.html#action-menu) is also pre-configured with the provided Sublime server IP address, to allow pivoting from a Sublime Security alert to the referenced email for analysis within the Sublime platform. The address used for pivoting can be changed as desired after installation, if necessary.

### NOTE: This script should be run on a manager or standalone Security Onion node.

#### Requirements:
 - Externally managed Sublime server with a webhook action configured to point to http://$securityonion:8228

#### Install:

`git clone https://github.com/weslambert/securityonion-sublime && cd securityonion-sublime && sudo ./install_so-sublime`

#### Post-Install
If running a distributed deployment, run the command below after script completion, or wait 15 minutes for Salt to replicate changes to downstream nodes.

`sudo salt "*" state.highstate`

