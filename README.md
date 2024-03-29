# securityonion-sublime

#### Triage Sublime email alerts inside of Security Onion
### NOTE: This integration is intended for use with Security Onion 2.3 and will soon be updated for Security Onion 2.4.
![image](https://user-images.githubusercontent.com/16829864/222842071-4f277c26-2ad7-4344-a9e8-a948c65910fa.png)

#### Pivot to Sublime for further investigation
![image](https://user-images.githubusercontent.com/16829864/223286167-e61dcad7-76da-48d7-8847-9eb32a8a9623.png)

#### Perform in-depth review of email that generated alert 
![image](https://user-images.githubusercontent.com/16829864/223286188-18a978c4-7571-40dd-91bd-0a2b6a47eeb7.png)

#### Submit an email to Sublime for analysis from an observable in SOC Cases using the Sublime SOC analyzer
![image](https://user-images.githubusercontent.com/16829864/224206024-b752b039-028a-4df8-bbb2-86817ea4ec14.png)
![image](https://user-images.githubusercontent.com/16829864/224206048-5f65bbd7-9e0b-457e-a5ab-75d4ae389057.png)



### NOTE: This script is NOT an officially supported Security Onion integration, and is not intended for production use. It is an example of how you can set up similar configuration in your environment. 

By default, traffic from the webhook to the Security Onion instance is not encrypted. This requires additional configuration within `/opt/so/saltstack/local/salt/logstash/pipelines/config/so/0001_input_sublime.conf`.

This script will set up the necessary components to ingest [Sublime Security](https://sublime.security/) alerts into Security Onion via webhooks, an Elasticsearch ingest pipeline, and an HTTP endpoint published by Logstash on `TCP` port `8228`. Firewall configuration is also configured as necessary, although, you may need to use `so-firewall` to create additional exceptions.

In addition to the data pipeline, a [SOC action](https://docs.securityonion.net/en/2.3/soc-customization.html#action-menu) is also pre-configured with the provided Sublime server IP address, to allow pivoting from a Sublime Security alert to the referenced email for analysis within the Sublime platform. The address used for pivoting can be changed as desired after installation, if necessary.

Last, an Sublime analyzer is configured, allowing analysts to paste the base64 content of an EML as the value of an observable, and provided the type of `eml` is chosen, the Sublime analyzer will submit a request to a local or remotely configured Sublime server.

### NOTE: This script should be run on a manager or standalone Security Onion node.

#### Requirements
 - Security Onion up and running (https://docs.securityonion.net/en/2.3/getting-started.html)
 - Externally managed Sublime server with a webhook action configured to point to `http://$securityonion:8228` (https://docs.sublimesecurity.com/docs/installation). Configuration of certificates is outside of the scope of this integration as it is simply demonstrational, but the webhook address can easily be adjusted if TLS is configured. 

#### Install

`git clone https://github.com/weslambert/securityonion-sublime && cd securityonion-sublime && sudo ./install_so-sublime`

#### Post-Install
If running a distributed deployment, run the command below after script completion, or wait 15 minutes for Salt to replicate changes to downstream nodes.

`sudo salt "*" state.highstate`

##### Configure the analyzer
To configure the analyzer, the following details should be provided in the sensoroni section of the minion pillar:

```
sensoroni:
  analyzers:
    sublime:
      api_key: $api_key
      base_url: $if-this-is-a-local-instance # If you are not using a local Sublime instance, this should not be configured. 
```

After the configuration details are provided, `sensoroni` can be restarted with the following commands:

```
sudo docker stop so-sensoroni
sudo docker rm so-sensoroni
sudo salt-call state.apply sensoroni queue=True
```

