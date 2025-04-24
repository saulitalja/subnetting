import ipaddress

def laske_verkko(ip_cidr):
    verkko = ipaddress.ip_network(ip_cidr, strict=False)
    osoitteet = list(verkko.hosts())

    print(f"\nVerkkolaskenta IP:lle {ip_cidr}")
    print(f"⛓️  Aliverkon maski: {verkko.netmask}")
    print(f"🌐 Verkko-osoite:   {verkko.network_address}")
    print(f"📣 Broadcast:       {verkko.broadcast_address}")

    if osoitteet:
        print(f"🚪 Oletusreititin:  {osoitteet[0]}")
        print(f"💻 Laitteiden IP:t: {osoitteet[1]} – {osoitteet[-1]}")
    else:
        print("⚠️  Ei käytettävissä olevia osoitteita.")

# Esimerkki
ip_cidr = input("Anna IP/CIDR (esim. 172.10.10.73/29): ")
laske_verkko(ip_cidr)
