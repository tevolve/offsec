#!/usr/share/python
import socket
import sys

def whois_query(domain):
    soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    soc.connect(("whois.iana.org", 43))
    soc.send((domain + "\r\n").encode())
    response = soc.recv(1024).split()
    whois_server = response[19].decode()
    soc.close()

    soc1 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    soc1.connect((whois_server, 43))
    soc1.send((domain + "\r\n").encode())

    response1 = b""
    while True:
        data = soc1.recv(4096)
        if not data:
            break
        response1 += data

    soc1.close()

    return response1.decode("utf-8", errors="ignore")

if len(sys.argv) < 2:
    print("Usage: python script.py <domain>")
    sys.exit(1)

domain = sys.argv[1]
result = whois_query(domain)
print(result)
