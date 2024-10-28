import ssl
import socket
from datetime import datetime

def check_ssl_expiry(domain):
    port = 443
    context = ssl.create_default_context()
    
    with socket.create_connection((domain, port)) as sock:
        with context.wrap_socket(sock, server_hostname=domain) as ssock:
            cert = ssock.getpeercert()
            expiry_date = cert['notAfter']
            expiry_timestamp = datetime.strptime(expiry_date, '%b %d %H:%M:%S %Y %Z')
            days_left = (expiry_timestamp - datetime.utcnow()).days
            
            if days_left <= 30:
                print(f"Certificate for {domain} is expiring in {days_left} days on {expiry_date}.")
            else:
                print(f"Certificate for {domain} is valid for {days_left} more days.")

# Example usage
check_ssl_expiry('yourdomain.com')

