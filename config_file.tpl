Run the following command:
aws --profile=${profile} ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id=${vpn_endpoint_id} --output=text > "${path}/aws-client-vpn-config.ovpn"

Then copy and paste content beneath at the end of downloaded file:

<cert>
${cert}
</cert>

<key>
${key}
</key>