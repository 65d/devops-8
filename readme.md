
# Lab 8

The scripts allow you to launch an EC2 instance, set up a basic Apache HTTP and HTTPS server, and terminate the instance.

## Files

1. **Launch Script** (`launch.sh`)
   - Launches an EC2 instance with a specified tag name.
   - Sets up security group ingress rules for HTTP and HTTPS.
   - Retrieves and outputs the public IP of the launched instance.
   - Connects to the instance via SSH.

2. **User Data Script** (`user_data.sh`)
   - Configures an Apache HTTP and HTTPS server on the EC2 instance.
   - Sets up SSL certificates for HTTPS.
   - Configures virtual hosts for HTTP and HTTPS.

3. **Terminate Script** (`terminate.sh`)
   - Terminates the specified EC2 instance.

## Usage

### Launch an EC2 Instance
```bash
./launch.sh <tag-name>
```
- `<tag-name>`: The name tag for the instance. Required.

### Terminate an EC2 Instance
```bash
./terminate.sh <instance-id>
```
- `<instance-id>`: The ID of the instance to terminate. Required.


## Notes
- Replace placeholders like `SECURITY_GROUP_ID`, `SUBNET_ID`, and `key` in the scripts with appropriate values before use.
- Ensure AWS CLI is configured with the necessary credentials and permissions.
- The user data script sets up an Apache server with SSL certificates for HTTPS.

---
