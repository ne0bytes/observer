OBSERVER(1)                    User Commands                    OBSERVER(1)

# NAME
       observer manual - Reference guide for network debugging tools and aliases

# SYNOPSIS
       **help**, **h**
              Display this manual

       **ALIAS** [ARGUMENTS]
              Use any built-in alias (ports, listen, dns, http, etc.)

       **TOOL** [OPTIONS] [ARGUMENTS]
              Use any installed tool directly (nmap, curl, tcpdump, etc.)

# DESCRIPTION
       Observer  is  a  network debugging and reconnaissance environment with
       70+ specialized tools for diagnosing connectivity  issues,  analyzing
       network  traffic, testing APIs, and monitoring system resources. Built
       on Alpine Linux for minimal overhead with maximum capability.

       **Core Capabilities:**

       Network Diagnostics
              Trace routes, analyze DNS, inspect connections, measure bandwidth,
              capture packets. Tools include mtr, gping, dig, tcpdump, ngrep,
              iperf3, socat, iftop for real-time bandwidth monitoring.

       Security Testing
              Port scanning, SSL/TLS inspection, packet analysis, connection
              tracking. Tools include nmap, openssl, netcat, lsof, strace.

       API Development
              HTTP/HTTPS/gRPC testing with modern clients. Tools include httpie,
              curl, grpcurl with JSON/YAML processing via jq and yq.

       System Analysis
              Monitor processes, analyze disk usage, track resource consumption.
              Tools include btop, ncdu, ps, df, du with enhanced interfaces.

       The environment includes smart aliases for common operations  (ports,
       listen,  myip,  dns, bandwidth, etc.) and modern productivity tools
       (bat for syntax highlighting, ripgrep for fast search, fzf for fuzzy
       finding, eza for colorful  listings,  zoxide  for  smart  directory
       jumping, git-delta for beautiful diffs). All tools are documented
       below with syntax, options, and practical examples.

# QUICK START
       Essential commands and shortcuts to get started:

       **h** or **help**    Display this manual
       **Ctrl+R**           Search command history with fzf
       **Ctrl+O**           Launch lf file manager
       **Ctrl+E**           Edit command in vim (vi-mode enabled)
       **ESC**              Vi command mode (then use h/j/k/l navigation)
       **ports**            List all open ports
       **listen**           Show listening services
       **bandwidth**        Monitor bandwidth usage
       **myip**             Get your public IP address
       **interfaces**       Show network interfaces
       **dns** DOMAIN       Quick DNS lookup
       **sniff**            Capture packets (tcpdump)
       **http** URL         Check HTTP headers
       **nmap** HOST        Scan a host

# BUILT-IN ALIASES

## Network Connection Analysis

### ports
       **ports** - List all open TCP/UDP ports

       DESCRIPTION
              Shows all network ports that are listening or established.
              Uses netstat to display protocol, address, state, and PID.

       SYNOPSIS
              ports

       EXAMPLE
              $ ports
              Proto Recv-Q Send-Q Local Address    Foreign Address  State    PID/Program
              tcp        0      0 0.0.0.0:22       0.0.0.0:*        LISTEN   1234/sshd
              tcp        0      0 0.0.0.0:80       0.0.0.0:*        LISTEN   5678/nginx

       SEE ALSO
              listen, established, connections, ss(8), netstat(8)

---

### listen
       **listen** - Show only listening services

       DESCRIPTION
              Displays services waiting for incoming connections.
              Automatically falls back to 'ss -tlnp' if lsof is unavailable.

       SYNOPSIS
              listen

       EXAMPLE
              $ listen
              COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
              sshd      123 root    3u  IPv4  12345      0t0  TCP *:22 (LISTEN)
              nginx     456 www     6u  IPv4  67890      0t0  TCP *:80 (LISTEN)

       USE CASE
              Debugging "connection refused" errors - verify service is listening

       SEE ALSO
              ports, established, lsof(8), ss(8)

---

### established
       **established** - Show active TCP connections

       DESCRIPTION
              Lists all currently established TCP connections.
              Falls back to 'ss -tnp' if lsof unavailable.

       SYNOPSIS
              established

       EXAMPLE
              $ established
              COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
              chrome    1234 user   42u  IPv4 123456      0t0  TCP 192.168.1.5:54321->1.2.3.4:443 (ESTABLISHED)
              ssh       5678 user    3u  IPv4 234567      0t0  TCP 192.168.1.5:22->10.0.0.1:54123 (ESTABLISHED)

       USE CASE
              Verify if connection to remote server is active

       SEE ALSO
              ports, listen, connections, netstat(8)

---

### connections
       **connections** - Complete socket information

       DESCRIPTION
              Shows all sockets (TCP, UDP, Unix) with detailed information
              including state, send/receive queues, and process info.

       SYNOPSIS
              connections

       EXAMPLE
              $ connections
              Netid State   Recv-Q Send-Q Local Address:Port  Peer Address:Port
              tcp   LISTEN  0      128    0.0.0.0:22          0.0.0.0:*
              tcp   ESTAB   0      0      192.168.1.5:54321   1.2.3.4:443

       SEE ALSO
              ports, listen, established, ss(8)

---

## Network Configuration

### interfaces
       **interfaces** - Show network interfaces

       DESCRIPTION
              Displays all network interfaces with IP addresses in compact format.
              Shows link state (UP/DOWN) and assigned addresses.

       SYNOPSIS
              interfaces

       EXAMPLE
              $ interfaces
              lo      UNKNOWN   127.0.0.1/8 ::1/128
              eth0    UP        192.168.1.5/24 fe80::a00:27ff:fe4e:66a1/64
              wlan0   DOWN

       SEE ALSO
              routes, arp, ip(8), ifconfig(8)

---

### routes
       **routes** - Display routing table

       DESCRIPTION
              Shows the kernel IP routing table.

       SYNOPSIS
              routes

       EXAMPLE
              $ routes
              default via 192.168.1.1 dev eth0
              192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.5

       USE CASE
              Debugging why packets aren't reaching destination

       SEE ALSO
              interfaces, arp, traceroute(8), mtr(8)

---

### arp
       **arp** - Show ARP/neighbor table

       DESCRIPTION
              Displays IP to MAC address mappings (Address Resolution Protocol cache).

       SYNOPSIS
              arp

       EXAMPLE
              $ arp
              192.168.1.1 dev eth0 lladdr aa:bb:cc:dd:ee:ff REACHABLE
              192.168.1.10 dev eth0 lladdr 11:22:33:44:55:66 STALE

       USE CASE
              Investigating Layer 2 connectivity issues

       SEE ALSO
              interfaces, routes, ip-neighbour(8)

---

## Network Testing & Diagnostics

### myip
       **myip** - Get public IP address

       DESCRIPTION
              Fetches your public IP from ifconfig.me.
              Returns "offline" if no internet connectivity.

       SYNOPSIS
              myip

       EXAMPLE
              $ myip
              203.0.113.42

       SEE ALSO
              interfaces, curl(1)

---

### pingg
       **pingg** - Quick ping test

       DESCRIPTION
              Pings Cloudflare DNS (1.1.1.1) 4 times for quick connectivity check.

       SYNOPSIS
              pingg

       EXAMPLE
              $ pingg
              PING 1.1.1.1 (1.1.1.1): 56 data bytes
              64 bytes from 1.1.1.1: seq=0 ttl=57 time=12.4 ms
              64 bytes from 1.1.1.1: seq=1 ttl=57 time=11.8 ms

       SEE ALSO
              ping(8), trace, mtr(8)

---

### trace
       **trace** - Visual traceroute with ASN info

       DESCRIPTION
              Shows network path to destination with AS numbers.
              Combines ping + traceroute for continuous monitoring.

       SYNOPSIS
              trace HOST

       EXAMPLE
              $ trace google.com
              Start: 2024-01-11T10:30:00+0000
              HOST: observer            Loss%   Snt   Avg
                1. AS???    192.168.1.1    0.0%    10   1.2
                2. AS1234   10.0.0.1       0.0%    10   5.4
                3. AS15169  8.8.8.8        0.0%    10  12.8

       USE CASE
              Diagnosing routing issues or high latency paths

       SEE ALSO
              pingg, mtr(8), traceroute(8)

---

### webtest
       **webtest** - HTTP response time test

       DESCRIPTION
              Quick HTTP request with status code and timing information.
              Useful for testing web service response times.

       SYNOPSIS
              webtest URL

       EXAMPLE
              $ webtest https://example.com
              HTTP: 200
              Time: 0.234567s

              $ webtest https://api.example.com/health
              HTTP: 200
              Time: 0.123456s

       USE CASE
              Quick health checks, API response time testing

       NOTE
              Aliased to: curl -o /dev/null -s -w 'HTTP: %{http_code}\nTime: %{time_total}s\n'

       SEE ALSO
              curl(1), http, https

---

### dns
       **dns** - Quick DNS lookup

       DESCRIPTION
              Fast DNS resolution showing only IP addresses.

       SYNOPSIS
              dns DOMAIN

       EXAMPLE
              $ dns google.com
              142.250.185.46
              2607:f8b0:4004:c07::71

       SEE ALSO
              dnsall, dig(1), nslookup(1)

---

### dnsall
       **dnsall** - Detailed DNS query

       DESCRIPTION
              Shows complete DNS answer section with all records.

       SYNOPSIS
              dnsall DOMAIN

       EXAMPLE
              $ dnsall example.com
              example.com.    86400   IN  A       93.184.216.34
              example.com.    86400   IN  AAAA    2606:2800:220:1:248:1893:25c8:1946

       SEE ALSO
              dns, dig(1), host(1)

---

### sniff
       **sniff** - Capture network packets

       DESCRIPTION
              Captures packets on all interfaces using tcpdump.

       SYNOPSIS
              sniff

       EXAMPLE
              $ sniff
              tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
              listening on any, link-type LINUX_SLL (Linux cooked), capture size 262144 bytes
              10:30:01.123456 IP 192.168.1.5.54321 > 1.1.1.1.53: 12345+ A? google.com. (28)

       USE CASE
              Debugging network protocols at packet level

       SEE ALSO
              tcpdump(8), ngrep(8), wireshark(1)

---

### ngrep
       **ngrep** - Network grep for packet content

       DESCRIPTION
              Search packet payloads for patterns using regular expressions.
              Like grep but for network traffic. Essential for finding
              specific strings in network protocols.

       SYNOPSIS
              ngrep PATTERN [FILTER]

       EXAMPLES
              $ ngrep -q "HTTP"
              # Shows packets containing "HTTP"

              $ ngrep -q "password"
              # Find cleartext passwords (security audit)

              $ ngrep -q -W byline "GET|POST"
              # Search HTTP requests

              $ ngrep -q "error" port 3306
              # MySQL errors

       USE CASE
              Finding specific protocol messages, debugging API issues,
              security auditing for cleartext secrets

       NOTE
              Aliased to: ngrep -q (quiet mode)

       SEE ALSO
              ngrep(8), tcpdump(8), sniff

---

### bandwidth
       **bandwidth** - Monitor bandwidth usage by connection

       DESCRIPTION
              Real-time bandwidth monitoring showing current connections and
              their traffic rates. Displays source/destination hosts, ports,
              and cumulative transfer amounts per connection.

       SYNOPSIS
              bandwidth

       EXAMPLE
              $ bandwidth
              # Interactive display showing:
              # - Active connections with source/destination
              # - Current transfer rates per connection
              # - Cumulative sent/received per host
              # - Total bandwidth in/out

       KEYBOARD SHORTCUTS (Inside iftop)
              q           Quit
              h           Help
              n           Toggle name resolution
              s           Toggle source display
              d           Toggle destination display
              p           Toggle port display
              P           Pause display
              t           Toggle display mode
              l           Display filter

       USE CASE
              Identifying bandwidth usage per connection, finding heavy talkers

       NOTE
              Aliased to: iftop

       SEE ALSO
              iftop(8), nethogs(8), nload(1)

---

## Web & HTTP Shortcuts

### http
       **http** - Get HTTP headers

       DESCRIPTION
              Quickly fetch HTTP headers from a URL.

       SYNOPSIS
              http URL

       EXAMPLE
              $ http example.com
              HTTP/1.1 200 OK
              Content-Type: text/html; charset=UTF-8
              Server: nginx/1.18.0
              Content-Length: 1256

       SEE ALSO
              https, curl(1), httpie(1)

---

### https
       **https** - Get HTTPS headers (insecure)

       DESCRIPTION
              Fetch HTTPS headers without certificate verification.
              Useful for testing self-signed certificates.

       SYNOPSIS
              https URL

       EXAMPLE
              $ https self-signed.example.com
              HTTP/1.1 200 OK

       NOTE
              Uses -k flag to skip certificate validation

       SEE ALSO
              http, sslcheck, curl(1)

---

### curljson
       **curljson** - Curl with JSON header

       DESCRIPTION
              Curl with Content-Type: application/json header preset.

       SYNOPSIS
              curljson [CURL_OPTIONS] URL

       EXAMPLE
              $ curljson -X POST https://api.example.com/users -d '{"name":"john"}'

       SEE ALSO
              curl(1), httpie(1), jq(1)

---

## SSL/TLS Tools

### sslcheck
       **sslcheck** - Test SSL connection

       DESCRIPTION
              Opens SSL/TLS connection and shows handshake details.

       SYNOPSIS
              sslcheck HOST:PORT

       EXAMPLE
              $ sslcheck example.com:443
              CONNECTED(00000003)
              depth=2 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert Global Root CA
              verify return:1
              ---
              Certificate chain
               0 s:C = US, ST = California, L = Los Angeles, O = Example Inc, CN = example.com

       USE CASE
              Debugging SSL/TLS handshake failures

       SEE ALSO
              cert, certinfo, openssl(1)

---

### cert
       **cert** - View certificate file

       DESCRIPTION
              Display X.509 certificate details from file.

       SYNOPSIS
              cert CERTIFICATE_FILE

       EXAMPLE
              $ cert /path/to/cert.pem
              Certificate:
                  Data:
                      Issuer: CN=Example CA
                      Validity
                          Not Before: Jan  1 00:00:00 2024 GMT
                          Not After : Dec 31 23:59:59 2025 GMT
                      Subject: CN=example.com

       SEE ALSO
              certinfo, sslcheck, openssl(1)

---

### certinfo
       **certinfo** - Show certificate chain

       DESCRIPTION
              Displays complete certificate chain from server including
              intermediates and root CA.

       SYNOPSIS
              certinfo HOST:PORT

       EXAMPLE
              $ certinfo example.com:443
              ---
              Certificate chain
               0 s:CN = example.com
                 i:C = US, O = Let's Encrypt, CN = R3
               1 s:C = US, O = Let's Encrypt, CN = R3
                 i:C = US, O = Internet Security Research Group, CN = ISRG Root X1

       SEE ALSO
              cert, sslcheck, openssl(1)

---

## File & Text Utilities

### lf
       **lf** - Terminal file manager

       DESCRIPTION
              Interactive file manager with cd-on-exit functionality.
              Preview files with bat, navigate with vim-like keys.
              Quick access via Ctrl+O keyboard shortcut.

       SYNOPSIS
              lf [DIRECTORY]

       KEYBOARD SHORTCUTS
              Ctrl+O      Launch lf from anywhere (shell keybinding)

       KEY BINDINGS (Inside lf)
              j/k         Move down/up
              h/l         Parent/child directory
              Enter       Open file
              i           Preview with bat
              q           Quit (and cd to current dir)

       EXAMPLES
              # Launch from command line
              $ lf

              # Or press Ctrl+O from anywhere
              # Navigate, preview files, then quit
              # Shell automatically changes to the directory you're in

       TIP
              Use Ctrl+O for instant file navigation without typing 'lf'

       SEE ALSO
              lf(1), ranger(1), nnn(1)

---

### ls, ll, la, tree
       **ls**, **ll**, **la**, **tree** - Enhanced directory listings

       DESCRIPTION
              Modern directory listings with colors, icons, and git integration.
              Uses eza for better visual output than traditional ls.

       SYNOPSIS
              ls              Basic listing
              ll              Long format with details
              la              Show hidden files
              tree            Tree view of directory structure

       EXAMPLES
              $ ls
              # Colorized listing with file type indicators

              $ ll
              # Detailed view with permissions, size, date, git status

              $ la
              # Show all files including hidden (.dotfiles)

              $ tree
              # Display directory tree structure

       NOTE
              Aliased to: eza variants (tree uses eza --tree)

       SEE ALSO
              eza(1)

---

### z, zi
       **z**, **zi** - Smart directory jumping

       DESCRIPTION
              Jump to frequently-used directories with zoxide. Learns your
              navigation patterns and lets you jump to directories by partial
              name match. Much faster than cd for deep directory trees.

       SYNOPSIS
              z QUERY         Jump to best match
              zi QUERY        Interactive selection with fzf

       EXAMPLES
              $ z observ
              # Jumps to /path/to/observer if you've visited it before

              $ zi conf
              # Shows interactive menu of all dirs matching "conf"
              # Select with arrow keys

              # After using cd normally a few times:
              $ cd /very/deep/project/src/components
              $ cd ~
              $ z comp
              # Instantly back to /very/deep/project/src/components

       TIP
              Just navigate normally at first. After visiting directories,
              use 'z' to jump instantly. The more you use it, the smarter it gets.

       NOTE
              Provided by zoxide (no alias needed)

       SEE ALSO
              zoxide(1), cd, autojump, fasd

---

## System Utilities

### top
       **top** - Interactive process viewer

       DESCRIPTION
              Interactive process viewer with enhanced UI (btop).

       SYNOPSIS
              top

       KEY BINDINGS
              ESC         Show menu
              m           Show memory
              p           Show CPU
              n           Show network
              d           Show disks
              q           Quit

       NOTE
              Aliased to: btop

       SEE ALSO
              btop(1), ps(1), psg

---

### psg
       **psg** - Search processes

       DESCRIPTION
              Search running processes by name or pattern.

       SYNOPSIS
              psg PATTERN

       EXAMPLE
              $ psg nginx
              USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
              www-data  1234  0.0  0.1  12345  6789 ?        Ss   10:00   0:00 nginx: master
              www-data  5678  0.0  0.2  23456  7890 ?        S    10:00   0:00 nginx: worker

       SEE ALSO
              ps(1), top, grep(1)

---

### hist
       **hist** - Recent command history

       DESCRIPTION
              Shows last 20 commands from history.

       SYNOPSIS
              hist

       EXAMPLE
              $ hist
              501  cd /var/log
              502  tail -f messages
              503  grep error messages

       SEE ALSO
              history(1), Ctrl+R (search history with fzf)

---

### observer
       **observer** - Display ASCII art banner

       DESCRIPTION
              Shows the colorized observer ASCII art banner.

       SYNOPSIS
              observer

       EXAMPLE
              $ observer
              # Displays the observer ASCII art banner in color

       USE CASE
              Remind yourself of the tool name, display branding

       NOTE
              Aliased to: print -rP "$(< /etc/observer/banner.braille)"

       SEE ALSO
              help, h

---

### df, du, free
       **df** - Disk free space
       **du** - Disk usage
       **free** - Memory usage

       DESCRIPTION
              System resource monitoring with human-readable output.

       SYNOPSIS
              df
              du [PATH]
              free

       EXAMPLE
              $ df
              Filesystem      Size  Used Avail Use% Mounted on
              overlay          59G   42G   15G  74% /

              $ du /var/log
              124K    /var/log/nginx
              4.0K    /var/log/apt
              256K    /var/log

              $ free
                            total        used        free      shared  buff/cache   available
              Mem:           15Gi       8.2Gi       1.5Gi       432Mi       5.8Gi       6.5Gi

       SEE ALSO
              ncdu(1)

---

# FULL TOOL REFERENCE

       Comprehensive  documentation  for  all  installed tools. Each entry
       includes syntax, common options, practical examples,  and  tips  for
       effective  use.  Tools  are organized by category for easy reference.

## NETWORK TOOLS

### nmap - Network Scanner
       Port scanning and network discovery tool.

       SYNOPSIS
              nmap [OPTIONS] TARGET

       COMMON OPTIONS
              -F              Fast scan (100 common ports)
              -p PORT         Scan specific port(s)
              -p-             Scan all 65535 ports
              -sV             Service version detection
              -O              OS detection
              -A              Aggressive scan (OS, version, scripts)
              -sn             Ping scan (no port scan)
              -sU             UDP scan
              -sS             SYN stealth scan
              --script SCRIPT Run NSE script

       EXAMPLES
              # Quick scan of common ports
              nmap -F 192.168.1.1

              # Scan specific ports
              nmap -p 22,80,443 192.168.1.1

              # Service detection
              nmap -sV 192.168.1.1

              # Network discovery
              nmap -sn 192.168.1.0/24

              # Vulnerability scan
              nmap --script vuln 192.168.1.1

              # Scan from file
              nmap -iL targets.txt

       TIP
              Use -F for quick scans, -A for comprehensive info

       SEE ALSO
              nmap(1), /usr/share/nmap/scripts/ (NSE scripts)

---

### tcpdump - Packet Analyzer
       Command-line packet sniffer.

       SYNOPSIS
              tcpdump [OPTIONS] [FILTER]

       COMMON OPTIONS
              -i INTERFACE    Capture on specific interface
              -w FILE         Write to pcap file
              -r FILE         Read from pcap file
              -n              Don't resolve hostnames
              -A              Print packets in ASCII
              -X              Print packets in hex and ASCII
              -c COUNT        Capture N packets then stop
              -v, -vv, -vvv   Verbose output

       FILTER SYNTAX
              host HOST       Specific host
              port PORT       Specific port
              tcp/udp         Protocol
              src/dst         Source/destination

       EXAMPLES
              # Capture on all interfaces
              tcpdump -i any

              # Capture HTTP traffic
              tcpdump -i any 'tcp port 80'

              # Save to file
              tcpdump -i any -w capture.pcap

              # Read from file
              tcpdump -r capture.pcap

              # Filter by host
              tcpdump -i any host 192.168.1.1

              # Show ASCII content
              tcpdump -i any -A 'tcp port 80'

              # Capture DNS queries
              tcpdump -i any 'udp port 53'

       TIP
              Use -w to save, analyze later with Wireshark

       SEE ALSO
              tcpdump(8), wireshark(1), ngrep(8), sniff

---

### curl - Transfer Data with URLs
       Swiss army knife for HTTP/HTTPS requests.

       SYNOPSIS
              curl [OPTIONS] URL

       COMMON OPTIONS
              -X METHOD       HTTP method (GET, POST, PUT, DELETE)
              -H "Header"     Custom header
              -d DATA         Request body
              -o FILE         Save output to file
              -O              Save with remote filename
              -L              Follow redirects
              -i              Include response headers
              -I              Head request only
              -v              Verbose output
              -k              Insecure (skip SSL verification)
              -u USER:PASS    Basic authentication
              -F "field=val"  Multipart form data

       EXAMPLES
              # Simple GET
              curl https://example.com

              # Download file
              curl -O https://example.com/file.zip

              # POST JSON
              curl -X POST https://api.example.com/users \
                -H "Content-Type: application/json" \
                -d '{"name":"john","email":"john@example.com"}'

              # With authentication
              curl -u username:password https://api.example.com

              # Upload file
              curl -F "file=@/path/to/file" https://example.com/upload

              # Follow redirects
              curl -L https://short.url

              # Show only headers
              curl -I https://example.com

              # Measure request time
              curl -w "@-" -o /dev/null -s https://example.com <<'EOF'
                  time_namelookup:  %{time_namelookup}s\n
                     time_connect:  %{time_connect}s\n
                        time_total:  %{time_total}s\n
              EOF

       TIP
              Use -v for debugging, -L to handle redirects

       SEE ALSO
              curl(1), httpie(1)

---

### httpie - User-Friendly HTTP Client
       Modern HTTP client with intuitive syntax.

       SYNOPSIS
              http [METHOD] URL [ITEMS]

       ITEMS SYNTAX
              key=value       Query parameter or data field
              key==value      Query parameter
              Header:value    Request header
              key:=value      JSON literal
              key@file        File upload

       COMMON OPTIONS
              --print=FLAGS   What to print (H=request headers, h=response headers, b=body)
              --download      Download mode
              --form          Form mode (instead of JSON)
              --json          JSON mode (default)
              --stream        Stream response
              -a USER:PASS    Authentication

       EXAMPLES
              # GET request
              http GET https://api.example.com/users

              # Query parameters
              http GET https://api.example.com/users page==2 limit==10

              # POST JSON (default)
              http POST https://api.example.com/users name=john email=john@example.com

              # Custom headers
              http GET https://api.example.com/users Authorization:"Bearer token123"

              # Form POST
              http --form POST https://example.com/form field1=value1 file@/path/to/file

              # Download file
              http --download https://example.com/file.zip

              # JSON literal
              http POST https://api.example.com/data items:='[1,2,3]' active:=true

              # Print request and response
              http --print=HhBb GET https://api.example.com/users

       TIP
              No need for -X, -H, or -d flags - httpie figures it out

       SEE ALSO
              httpie(1), curl(1), http, https

---

### grpcurl - gRPC Client
       Like curl but for gRPC.

       SYNOPSIS
              grpcurl [OPTIONS] HOST[:PORT] METHOD

       COMMON OPTIONS
              -plaintext      Use plain HTTP/2 (no TLS)
              -d DATA         Request data (JSON)
              -H "Header"     Metadata (headers)
              -cacert FILE    CA certificate
              -cert FILE      Client certificate
              -key FILE       Client key
              -import-path    Path to .proto files
              -proto FILE     .proto file to use

       COMMANDS
              list            List services
              list SERVICE    List methods
              describe METHOD Describe method

       EXAMPLES
              # List all services
              grpcurl -plaintext localhost:50051 list

              # List methods of a service
              grpcurl -plaintext localhost:50051 list my.service.Greeter

              # Describe method
              grpcurl -plaintext localhost:50051 describe my.service.Greeter.SayHello

              # Call method
              grpcurl -plaintext \
                -d '{"name": "world"}' \
                localhost:50051 my.service.Greeter/SayHello

              # With metadata (headers)
              grpcurl -plaintext \
                -H "authorization: Bearer token123" \
                -d '{"name": "world"}' \
                localhost:50051 my.service.Greeter/SayHello

              # With TLS
              grpcurl \
                -cacert ca.pem \
                -cert client.pem \
                -key client-key.pem \
                example.com:443 list

       TIP
              Always start with 'list' to discover available services

       SEE ALSO
              grpcurl(1), protoc(1)

---

### dig - DNS Lookup
       Flexible DNS query tool.

       SYNOPSIS
              dig [@SERVER] [DOMAIN] [TYPE]

       COMMON OPTIONS
              +short          Short output (answer only)
              +trace          Trace DNS delegation path
              +noall +answer  Only show answer section
              -x ADDRESS      Reverse lookup
              @SERVER         Query specific nameserver

       RECORD TYPES
              A               IPv4 address
              AAAA            IPv6 address
              MX              Mail exchange
              NS              Name server
              TXT             Text records
              CNAME           Canonical name
              SOA             Start of authority
              ANY             All records

       EXAMPLES
              # Basic lookup
              dig example.com

              # Specific record type
              dig example.com MX

              # Short output
              dig +short example.com

              # Query specific nameserver
              dig @8.8.8.8 example.com

              # Trace delegation
              dig +trace example.com

              # Reverse lookup
              dig -x 8.8.8.8

              # Only answer section
              dig +noall +answer example.com

              # Multiple queries
              dig example.com A example.com AAAA

       TIP
              Use +short for scripts, +trace for delegation debugging

       SEE ALSO
              dig(1), nslookup(1), host(1), dns, dnsall

---

### mtr - Network Diagnostic Tool
       Combines ping and traceroute with real-time stats.

       SYNOPSIS
              mtr [OPTIONS] HOST

       COMMON OPTIONS
              -r              Report mode
              -c COUNT        Number of pings
              -z              Show AS numbers
              -n              No DNS resolution
              -b              Show both hostnames and IPs
              -i SECONDS      Interval between pings
              --tcp           Use TCP instead of ICMP
              --port PORT     TCP/UDP port number

       EXAMPLES
              # Interactive mode
              mtr google.com

              # With ASN info
              mtr -z google.com

              # Report mode (non-interactive)
              mtr -r -c 100 google.com

              # TCP mode (port 80)
              mtr --tcp --port 80 google.com

              # No DNS resolution (faster)
              mtr -n 8.8.8.8

       KEY BINDINGS (Interactive)
              p               Pause
              d               Display mode
              n               Toggle DNS resolution
              q               Quit

       TIP
              Use -r for scripts, interactive for continuous monitoring

       SEE ALSO
              mtr(8), traceroute(8), ping(8), trace

---

### socat - Multipurpose Relay
       Establishes connections between various endpoints.

       SYNOPSIS
              socat [OPTIONS] ADDRESS ADDRESS

       COMMON ADDRESSES
              TCP:host:port           TCP connection
              TCP-LISTEN:port         TCP server
              UDP:host:port           UDP connection
              UDP-LISTEN:port         UDP server
              UNIX-CONNECT:path       Unix socket client
              UNIX-LISTEN:path        Unix socket server
              EXEC:command            Execute command
              SYSTEM:command          Execute via shell
              STDIO                   Standard I/O
              -                       Standard I/O (shorthand)

       COMMON OPTIONS
              fork                Create child for each connection
              reuseaddr           Reuse address

       EXAMPLES
              # TCP port forward
              socat TCP-LISTEN:8080,fork TCP:backend:80

              # UDP relay
              socat UDP-LISTEN:514,fork UDP:logserver:514

              # Unix socket to TCP
              socat UNIX-LISTEN:/tmp/socket,fork TCP:remote:8080

              # Connect to Docker socket
              socat - UNIX-CONNECT:/var/run/docker.sock

              # TCP server that echoes
              socat TCP-LISTEN:9999,fork EXEC:cat

              # Proxy HTTPS to HTTP
              socat TCP-LISTEN:443,fork,reuseaddr TCP:localhost:80

              # File transfer
              # Receiver: socat TCP-LISTEN:9999 OPEN:received.dat,creat
              # Sender:   socat TCP:receiver:9999 OPEN:file.dat

       TIP
              Use 'fork' for multi-client servers

       SEE ALSO
              socat(1), netcat(1), nc(1)

---

### netcat (nc) - Network Swiss Army Knife
       Simple utility for TCP/UDP connections.

       SYNOPSIS
              nc [OPTIONS] HOST PORT
              nc -l [OPTIONS] PORT

       COMMON OPTIONS
              -l              Listen mode
              -p PORT         Local port
              -v              Verbose
              -z              Zero-I/O mode (scan)
              -u              UDP mode
              -w SECONDS      Timeout
              -n              No DNS resolution

       EXAMPLES
              # Check if port is open
              nc -zv example.com 443

              # Listen on port
              nc -l -p 9999

              # Transfer file
              # Receiver: nc -l -p 9999 > received.txt
              # Sender:   nc receiver.host 9999 < file.txt

              # Port scan
              nc -zv example.com 20-100

              # Chat between hosts
              # Server: nc -l -p 9999
              # Client: nc server.host 9999

              # Simple HTTP request
              echo -e "GET / HTTP/1.0\n\n" | nc example.com 80

              # UDP test
              nc -u example.com 53

       TIP
              Use -z for port checking, -l for listening

       SEE ALSO
              netcat(1), socat(1), nmap(1)

---

### iperf3 - Network Performance
       Measure network bandwidth between two hosts.

       SYNOPSIS
              iperf3 -s                    (server mode)
              iperf3 -c SERVER [OPTIONS]   (client mode)

       COMMON OPTIONS
              -s              Server mode
              -c SERVER       Client mode
              -p PORT         Port (default 5201)
              -u              UDP mode
              -b BANDWIDTH    Target bandwidth (UDP)
              -t SECONDS      Time to transmit
              -P NUM          Number of parallel streams
              -R              Reverse (download) test
              -i SECONDS      Report interval
              -J              JSON output

       EXAMPLES
              # Start server
              iperf3 -s

              # Test upload bandwidth
              iperf3 -c server.example.com

              # Test download bandwidth
              iperf3 -c server.example.com -R

              # UDP test at 100Mbps
              iperf3 -c server.example.com -u -b 100M

              # 10 parallel streams
              iperf3 -c server.example.com -P 10

              # Test for 30 seconds
              iperf3 -c server.example.com -t 30

              # JSON output
              iperf3 -c server.example.com -J

       TIP
              Run server in background: iperf3 -s -D

       SEE ALSO
              iperf3(1), mtr(8), wrk(1)

---

### ngrep - Network Grep
       Grep for network packets - search packet payloads.

       SYNOPSIS
              ngrep [OPTIONS] PATTERN [FILTER]

       COMMON OPTIONS
              -q              Quiet (suppress header)
              -i              Case insensitive
              -W              Line buffered (with byline)
              -x              Print hex dump
              -t              Print timestamp
              -I FILE         Read from pcap file
              -O FILE         Write to pcap file
              -d INTERFACE    Capture interface

       BPF FILTER
              port 80         HTTP traffic
              host 1.1.1.1    Specific host
              tcp             TCP only
              udp             UDP only

       EXAMPLES
              # Search all traffic for "password"
              ngrep -q "password"

              # HTTP GET/POST requests
              ngrep -q "GET|POST" port 80

              # MySQL protocol errors
              ngrep -q "error" port 3306

              # Redis commands
              ngrep -q "SET|GET" port 6379

              # Case insensitive search
              ngrep -q -i "error"

              # With hex dump
              ngrep -q -x "HTTP/1.1"

              # From pcap file
              ngrep -I capture.pcap "password"

              # Specific interface
              ngrep -d eth0 -q "ssh"

       USE CASES
              - Find API keys in cleartext protocols
              - Debug application protocols
              - Search database queries
              - Audit for sensitive data leaks

       TIP
              Combine with BPF filters for targeted search

       SEE ALSO
              ngrep(8), tcpdump(8), sniff

---

### arping - ARP Ping
       Send ARP requests to discover hosts on local network (Layer 2).

       SYNOPSIS
              arping [OPTIONS] TARGET

       COMMON OPTIONS
              -c COUNT        Number of requests
              -I INTERFACE    Network interface
              -D              Duplicate address detection
              -U              Unsolicited ARP (gratuitous)
              -A              ARP reply mode
              -w TIMEOUT      Timeout in seconds

       EXAMPLES
              # Ping host via ARP
              arping -c 4 -I eth0 192.168.1.1

              # Check if IP is in use (DAD)
              arping -D -I eth0 192.168.1.100

              # Send gratuitous ARP
              arping -U -I eth0 192.168.1.50

              # Continuous ARP ping
              arping -I eth0 192.168.1.1

       USE CASES
              - Test Layer 2 connectivity (bypasses IP layer)
              - Detect IP conflicts
              - Find MAC address of device
              - Test ARP cache updates
              - Network discovery without IP

       TIP
              Works when ping doesn't (IP stack issues, firewall)

       SEE ALSO
              arping(8), ping(8), ip-neighbour(8)

---

### ipcalc - IP Calculator
       Calculate subnet information from IP address and netmask.

       SYNOPSIS
              ipcalc [OPTIONS] IP[/MASK]

       COMMON OPTIONS
              -n              Display network address
              -b              Display broadcast address
              -m              Display netmask
              -p              Display prefix
              -h              Display hostmin and hostmax
              -c              Colorized output

       EXAMPLES
              # Full subnet info
              ipcalc 192.168.1.0/24
              # Network:   192.168.1.0/24
              # Netmask:   255.255.255.0
              # Broadcast: 192.168.1.255
              # HostMin:   192.168.1.1
              # HostMax:   192.168.1.254
              # Hosts/Net: 254

              # Large network
              ipcalc 10.0.0.0/8

              # Small subnet
              ipcalc 192.168.1.32/28

              # Check if IP is in subnet
              ipcalc 192.168.1.50 -n 192.168.1.0/24

       USE CASES
              - Subnet planning
              - IP address allocation
              - Verify routing configurations
              - Calculate CIDR ranges

       TIP
              Essential for network engineering calculations

       SEE ALSO
              ipcalc(1), ip(8)

---

### hping3 - Packet Crafting Tool
       Advanced TCP/IP packet assembler and analyzer.

       SYNOPSIS
              hping3 [OPTIONS] TARGET

       MODE OPTIONS
              -0              RAW IP mode
              -1              ICMP mode
              -2              UDP mode
              -8              Scan mode
              -9              Listen mode
              (default)       TCP mode

       COMMON OPTIONS
              -c COUNT        Packet count
              -i INTERVAL     Interval (uX for microseconds)
              -p PORT         Destination port
              -S              Set SYN flag
              -A              Set ACK flag
              -F              Set FIN flag
              -R              Set RST flag
              -P              Set PUSH flag
              -U              Set URG flag
              --flood         Send packets as fast as possible
              --rand-source   Random source address
              -d SIZE         Data size
              -E FILE         Use file as data
              --scan PORT     Port range scan

       EXAMPLES
              # TCP SYN flood test (testing purposes only)
              hping3 -S -p 80 -c 1000 example.com

              # Check firewall response (SYN/ACK)
              hping3 -S -p 443 example.com

              # UDP packet to specific port
              hping3 -2 -p 53 8.8.8.8

              # ICMP ping
              hping3 -1 example.com

              # Traceroute with TCP
              hping3 -S -p 80 --ttl 1 --tr-keep-ttl example.com

              # Port scan (SYN scan)
              hping3 -S -p ++0 example.com

              # Fast scan mode
              hping3 --scan 1-1000 -S example.com

              # Idle scan
              hping3 -S -a ZOMBIE_IP target.com

       USE CASES
              - Firewall testing
              - Path MTU discovery
              - Advanced traceroute
              - TCP/IP stack fingerprinting
              - Load testing
              - Security research

       WARNING
              Powerful tool - only use on authorized systems

       SEE ALSO
              hping3(8), nmap(1), tcpdump(8)

---

### wrk - HTTP Benchmarking
       Modern HTTP benchmarking tool for load testing.

       SYNOPSIS
              wrk [OPTIONS] URL

       COMMON OPTIONS
              -c CONNECTIONS  Number of connections
              -t THREADS      Number of threads
              -d DURATION     Duration (e.g., 30s, 1m, 1h)
              -s SCRIPT       Lua script for complex scenarios
              --latency       Print latency statistics
              --timeout TIME  Socket timeout
              -H HEADER       Add HTTP header

       EXAMPLES
              # Basic benchmark (10 connections, 10s)
              wrk -c 10 -d 10s http://localhost:8080

              # Heavy load (100 connections, 4 threads, 30s)
              wrk -c 100 -t 4 -d 30s http://example.com/api

              # With latency details
              wrk -c 50 -d 20s --latency http://api.example.com

              # Custom headers
              wrk -c 10 -d 10s -H "Authorization: Bearer TOKEN" http://api.example.com

              # POST request (with script)
              wrk -c 10 -d 10s -s post.lua http://api.example.com

       SCRIPT EXAMPLE (post.lua)
              wrk.method = "POST"
              wrk.body   = '{"key":"value"}'
              wrk.headers["Content-Type"] = "application/json"

       OUTPUT
              Running 10s test @ http://example.com
                2 threads and 10 connections
                Thread Stats   Avg      Stdev     Max   +/- Stdev
                  Latency    10.15ms    3.17ms  50.05ms   71.43%
                  Req/Sec   495.87     52.34   600.00     68.00%
                9856 requests in 10.00s, 1.47MB read
              Requests/sec:    985.25
              Transfer/sec:    150.37KB

       USE CASES
              - API load testing
              - Performance benchmarking
              - Stress testing
              - Capacity planning

       TIP
              Use Lua scripts for complex scenarios (auth, dynamic payloads)

       SEE ALSO
              wrk(1), ab(1), hey(1)

---

### ethtool - Network Interface Tool
       Query and control network device driver and hardware settings.

       SYNOPSIS
              ethtool [OPTIONS] INTERFACE

       COMMON OPTIONS
              (no options)    Show settings for interface
              -i              Driver information
              -S              Statistics (packet counts, errors)
              -k              Offload settings
              -g              Ring buffer parameters
              -a              Pause parameters
              -s              Change settings

       EXAMPLES
              # Show interface settings
              ethtool eth0

              # Driver information
              ethtool -i eth0

              # Statistics (errors, dropped packets)
              ethtool -S eth0 | grep error
              ethtool -S eth0 | grep drop

              # Check link status
              ethtool eth0 | grep "Link detected"

              # Check speed and duplex
              ethtool eth0 | grep Speed
              ethtool eth0 | grep Duplex

       USE CASES
              - Troubleshoot network interface issues
              - Check for packet errors or drops
              - Verify link speed and duplex settings
              - Diagnose hardware problems

       SEE ALSO
              ethtool(8), ip(8), interfaces

---

### conntrack - Connection Tracking
       View and manage kernel connection tracking table.

       SYNOPSIS
              conntrack [OPTIONS]

       COMMON OPTIONS
              -L              List connections
              -D              Delete connection
              -E              Event viewer (real-time)
              -C              Show count
              -p PROTO        Filter by protocol (tcp, udp, icmp)
              -s IP           Filter by source IP
              -d IP           Filter by destination IP
              --sport PORT    Source port
              --dport PORT    Destination port

       EXAMPLES
              # List all connections
              conntrack -L

              # Count active connections
              conntrack -C

              # Show TCP connections only
              conntrack -L -p tcp

              # Filter by destination IP
              conntrack -L -d 8.8.8.8

              # Watch connections in real-time
              conntrack -E

              # Show connections to specific port
              conntrack -L -p tcp --dport 443

              # Delete specific connection
              conntrack -D -p tcp --dport 80

       USE CASES
              - Monitor NAT translations
              - Troubleshoot connection tracking issues
              - Verify firewall connection state
              - Debug connection limits

       SEE ALSO
              conntrack(8), iptables(8), netfilter

---

### whois - Domain Information
       Query domain registration and IP address information.

       SYNOPSIS
              whois [OPTIONS] QUERY

       COMMON OPTIONS
              -h HOST         Use specific whois server
              -p PORT         Port to connect to
              -H              Hide legal disclaimers

       EXAMPLES
              # Domain lookup
              whois example.com

              # IP address lookup
              whois 8.8.8.8

              # Use specific server
              whois -h whois.arin.net 8.8.8.8

              # ASN lookup
              whois AS15169

       INFORMATION PROVIDED
              - Domain registration details
              - Registrar information
              - Name servers
              - Registration/expiry dates
              - IP address allocation
              - ASN information
              - Contact information

       USE CASES
              - Check domain ownership
              - Find IP address allocation
              - Investigate network abuse
              - DNS troubleshooting

       SEE ALSO
              whois(1), dig(1), host(1)

---

### telnet - Interactive TCP Client
       User interface to TELNET protocol for TCP connection testing.

       SYNOPSIS
              telnet [HOST] [PORT]

       EXAMPLES
              # Connect to host on port 23 (default)
              telnet example.com

              # Test HTTP server
              telnet example.com 80
              GET / HTTP/1.1
              Host: example.com
              (press Enter twice)

              # Test SMTP server
              telnet mail.example.com 25

              # Test port connectivity
              telnet 192.168.1.1 3306

              # Escape character: Ctrl+]
              # Then type 'quit' to exit

       USE CASES
              - Test TCP port connectivity
              - Debug application protocols (HTTP, SMTP, etc)
              - Manual protocol interaction
              - Verify service responses

       TIP
              For simple port checks, use: nc -zv HOST PORT

       SEE ALSO
              telnet(1), nc(1), netcat(1), curl(1)

---

### rsync - Fast File Transfer
       Fast, versatile file copying tool for local and remote transfers.

       SYNOPSIS
              rsync [OPTIONS] SOURCE DESTINATION

       COMMON OPTIONS
              -a              Archive mode (preserve permissions, times, etc)
              -v              Verbose
              -z              Compress during transfer
              -P              Show progress and keep partial files
              -n, --dry-run   Show what would be transferred
              -r              Recursive
              -h              Human-readable sizes
              --delete        Delete files in dest not in source
              --exclude PAT   Exclude pattern
              -e ssh          Use ssh for transport

       EXAMPLES
              # Copy directory to remote host
              rsync -avz /local/dir/ user@remote:/remote/dir/

              # Download from remote
              rsync -avzP user@remote:/remote/file /local/dir/

              # Sync directories (delete extra files)
              rsync -av --delete /source/ /dest/

              # Dry run (preview changes)
              rsync -avn --delete /source/ /dest/

              # Exclude files
              rsync -av --exclude '*.log' /source/ /dest/

              # Copy via ssh with custom port
              rsync -av -e 'ssh -p 2222' /local/ user@host:/remote/

              # Show progress for large transfers
              rsync -avP large-file.tar.gz user@host:/backup/

       USE CASES
              - Efficient file synchronization
              - Remote backups
              - Large file transfers with resume capability
              - Directory mirroring

       TIP
              Always use trailing slash on source dir for consistent behavior:
              /source/ copies contents, /source copies directory itself

       SEE ALSO
              rsync(1), scp(1), cp(1)

---

## TEXT & DATA TOOLS

### bat - Better Cat
       Cat clone with syntax highlighting and Git integration.

       SYNOPSIS
              bat [OPTIONS] FILE...

       COMMON OPTIONS
              -l LANGUAGE     Set language for syntax highlighting
              -p, --plain     Disable paging and decorations
              --style=STYLE   Set style (full, plain, numbers, etc)
              -n              Show line numbers
              -A              Show non-printable characters
              --paging=MODE   When to use pager (auto, always, never)

       EXAMPLES
              # View file with syntax highlighting
              bat script.py

              # Multiple files
              bat file1.js file2.js

              # Plain output (like cat)
              bat --style=plain file.txt

              # Force language
              bat -l json data.txt

              # Show all characters
              bat -A file.txt

              # Disable paging
              bat --paging=never long-file.txt

       TIP
              Set BAT_THEME env var for custom themes

       SEE ALSO
              bat(1), cat(1), less(1)

---

### ripgrep (rg) - Fast Search
       Recursively search directories for regex patterns.

       SYNOPSIS
              rg [OPTIONS] PATTERN [PATH...]

       COMMON OPTIONS
              -i              Case insensitive
              -w              Word boundary
              -v              Invert match
              -c              Count matches
              -l              Files with matches
              -L              Files without matches
              -n              Show line numbers
              -C NUM          Context lines
              -A NUM          After context
              -B NUM          Before context
              -t TYPE         File type (js, py, etc)
              -T TYPE         Exclude file type
              --hidden        Search hidden files
              -g GLOB         Glob pattern
              -F              Fixed string (no regex)

       EXAMPLES
              # Search in current directory
              rg "function"

              # Case insensitive
              rg -i "error"

              # Search JavaScript files only
              rg -t js "console.log"

              # Exclude Python files
              rg -T py "import"

              # Show 3 lines of context
              rg -C 3 "TODO"

              # Count matches per file
              rg -c "error"

              # List files containing pattern
              rg -l "config"

              # Search hidden files
              rg --hidden "secret"

              # Fixed string search
              rg -F "192.168.1.1"

       TIP
              Use -t for faster searches on specific file types

       SEE ALSO
              rg(1), grep(1), ack(1), ag(1)

---

### jq - JSON Processor
       Command-line JSON processor.

       SYNOPSIS
              jq [OPTIONS] FILTER [FILES...]

       COMMON FILTERS
              .               Identity (pretty print)
              .key            Extract field
              .[index]        Array access
              .[]             Array elements
              .[].key         Each element's key
              .key1.key2      Nested access
              |               Pipe

       COMMON OPTIONS
              -r              Raw output (no quotes)
              -c              Compact output
              -S              Sort keys
              -e              Exit with error if false/null
              -n              Use null input
              --arg NAME VAL  Pass variable

       EXAMPLES
              # Pretty print
              echo '{"name":"john","age":30}' | jq .

              # Extract field
              echo '{"name":"john","age":30}' | jq .name

              # Array access
              echo '[1,2,3]' | jq .[1]

              # Filter array
              echo '[{"name":"john"},{"name":"jane"}]' | jq '.[] | select(.name=="john")'

              # Map transformation
              echo '[1,2,3]' | jq 'map(. * 2)'

              # Multiple fields
              curl -s https://api.github.com/users/github | jq '{name, location, followers}'

              # Raw output
              echo '{"name":"john"}' | jq -r .name

              # Compact JSON
              jq -c . large.json

              # Sort keys
              jq -S . unsorted.json

              # With variable
              jq --arg name "john" '.[] | select(.name == $name)' data.json

       TIP
              Use jq '.' to validate JSON syntax

       SEE ALSO
              jq(1), json, yq(1)

---

### yq - YAML Processor
       jq wrapper for YAML files.

       SYNOPSIS
              yq [OPTIONS] EXPRESSION [FILES...]

       COMMON OPTIONS
              -o FORMAT       Output format (yaml, json, xml)
              -i              In-place edit
              -P              Colorize output
              eval            Evaluate expression
              eval-all        Merge multiple files

       EXAMPLES
              # Pretty print YAML
              yq . file.yaml

              # Extract field
              yq .metadata.name deployment.yaml

              # Convert to JSON
              yq -o=json . file.yaml

              # Multiple files
              yq eval-all '. as $item ireduce ({}; . * $item)' file1.yaml file2.yaml

              # Edit in place
              yq -i '.spec.replicas = 5' deployment.yaml

              # Extract nested value
              yq .spec.template.spec.containers[0].image pod.yaml

       TIP
              Use -o=json to convert YAML to JSON for jq processing

       SEE ALSO
              yq(1), jq(1), yaml

---

### eza - Modern ls
       Modern replacement for ls with colors, icons, and git integration.

       SYNOPSIS
              eza [OPTIONS] [FILES...]

       COMMON OPTIONS
              -l              Long format
              -a              Show hidden files
              -F              Add file type indicators
              -T              Tree view
              -L DEPTH        Tree depth
              --git           Show git status
              --color=MODE    When to use color (auto, always, never)
              --icons         Show file type icons
              --group-directories-first

       EXAMPLES
              # Basic listing (colorized)
              eza

              # Long format with details
              eza -l

              # Show all including hidden
              eza -a

              # Long format with git status
              eza -l --git

              # Tree view 2 levels deep
              eza -T -L 2

              # Sort by modification time
              eza -l --sort=modified

              # Group directories first
              eza -l --group-directories-first

       TIP
              Already aliased: ls, ll, la, tree

       SEE ALSO
              ls, ll, la, tree

---

### fd - Fast Find
       Fast and user-friendly alternative to find.

       SYNOPSIS
              fd [OPTIONS] PATTERN [PATH...]

       COMMON OPTIONS
              -t TYPE         Type: f(file), d(dir), l(link), x(executable)
              -e EXTENSION    Filter by extension
              -E PATTERN      Exclude pattern
              -H              Search hidden files
              -I              No ignore (.gitignore, etc)
              -a              Show hidden and ignored
              -d DEPTH        Max depth
              -x COMMAND      Execute command on results
              -X COMMAND      Execute command on all results at once

       EXAMPLES
              # Find all Python files
              fd -e py

              # Find directories
              fd -t d config

              # Search in /var
              fd error /var/log

              # Include hidden files
              fd -H secret

              # Ignore .gitignore rules
              fd -I node_modules

              # Max depth 2
              fd -d 2 README

              # Execute command
              fd -e jpg -x convert {} {.}.png

              # Case insensitive
              fd -i readme

       TIP
              Much faster than find, respects .gitignore by default

       SEE ALSO
              fd(1), find(1), rg(1)

---

## SYSTEM TOOLS

### btop - Process Viewer
       Interactive process and system monitor with modern UI.

       SYNOPSIS
              btop [OPTIONS]

       KEY BINDINGS
              ↑ ↓             Navigate processes
              ESC             Show menu
              m               Show/hide memory box
              n               Show/hide network box
              p               Show/hide CPU box
              d               Show/hide disk box
              f               Filter processes
              t               Tree view
              k               Kill process
              +/-             Adjust update interval
              q               Quit

       COMMON OPTIONS
              -v              Verbose logging
              -lc             Low color mode
              -t              TTY mode
              --utf-force     Force UTF-8

       EXAMPLES
              # Default view
              btop

              # Low color mode (compatibility)
              btop -lc

              # TTY mode (no mouse)
              btop -t

       TIP
              Use 'f' to filter processes by name in real-time

       SEE ALSO
              btop(1), top(1), ps(1)

---

### ncdu - Disk Usage Analyzer
       NCurses Disk Usage analyzer.

       SYNOPSIS
              ncdu [OPTIONS] [DIRECTORY]

       COMMON OPTIONS
              -x              Same filesystem
              -e              Extended info
              -r              Read-only mode
              -o FILE         Export to file
              -f FILE         Import from file

       KEY BINDINGS
              ↑ ↓             Navigate
              Enter           Enter directory
              d               Delete file/directory
              n               Sort by name
              s               Sort by size
              g               Show graph
              i               Show file info
              r               Refresh
              q               Quit

       EXAMPLES
              # Scan current directory
              ncdu

              # Scan specific directory
              ncdu /var

              # Export scan
              ncdu -o scan.json /var

              # Import scan
              ncdu -f scan.json

       TIP
              Export scan results to analyze on another machine

       SEE ALSO
              ncdu(1), du(1), df(1)

---

### lsof - List Open Files
       List open files and processes.

       SYNOPSIS
              lsof [OPTIONS]

       COMMON OPTIONS
              -i [ADDR]       Network connections
              -i TCP          TCP connections
              -i :PORT        Specific port
              -u USER         Files opened by user
              -c COMMAND      Files opened by command
              -p PID          Files opened by PID
              +D DIR          Files in directory
              -t              Terse (PIDs only)

       EXAMPLES
              # All network connections
              lsof -i

              # TCP connections
              lsof -iTCP

              # Specific port
              lsof -i :80

              # Listening ports
              lsof -i -sTCP:LISTEN

              # Established connections
              lsof -i -sTCP:ESTABLISHED

              # Files opened by user
              lsof -u root

              # Files opened by process
              lsof -c nginx

              # What's using a directory
              lsof +D /var/log

              # Kill all processes using port 8080
              lsof -ti :8080 | xargs kill

       TIP
              Use -t to get PIDs only, pipe to kill

       SEE ALSO
              lsof(8), fuser(1), listen, established

---

### strace - System Call Tracer
       Trace system calls and signals.

       SYNOPSIS
              strace [OPTIONS] COMMAND
              strace [OPTIONS] -p PID

       COMMON OPTIONS
              -p PID          Attach to process
              -e SYSCALL      Trace specific syscall
              -c              Count syscalls
              -t              Print timestamps
              -T              Show syscall duration
              -f              Follow forks
              -o FILE         Write to file
              -s SIZE         String size limit

       EXAMPLES
              # Trace a command
              strace ls /tmp

              # Attach to running process
              strace -p 1234

              # Count system calls
              strace -c ls

              # Trace specific syscalls
              strace -e open,read,write cat file.txt

              # Trace with timestamps
              strace -t ls

              # Follow child processes
              strace -f nginx

              # Output to file
              strace -o trace.log ls

              # File operations only
              strace -e trace=file ls

       TIP
              Use -c for performance analysis, -e to focus on specific calls

       SEE ALSO
              strace(1), ltrace(1), gdb(1)

---

### zoxide - Smarter cd
       Fast directory jumper that learns your habits.

       SYNOPSIS
              z QUERY              Jump to best match
              zi QUERY             Interactive selection
              zoxide query QUERY   Query without jumping
              zoxide add PATH      Add path to database
              zoxide remove PATH   Remove path from database

       COMMON OPTIONS
              --help          Show help
              --version       Show version

       EXAMPLES
              # Jump to frequently-used directory
              z observ
              # Jumps to /path/to/observer

              # Interactive search
              zi conf
              # Shows fzf menu of all matching directories

              # After visiting directories normally:
              cd /var/log/nginx
              cd /etc/nginx
              cd ~
              z nginx
              # Jumps to most frequently used nginx directory

              # Query without jumping
              zoxide query conf
              # /home/user/.config

       HOW IT WORKS
              Zoxide tracks directories you visit and assigns scores based on
              frequency and recency. Just navigate normally, then jump to
              frequently-used directories. The more you use it, the smarter it gets.

       TIP
              Navigate normally at first, zoxide learns your patterns

       SEE ALSO
              zoxide(1), cd, autojump, fasd, z, zi

---

### git with delta - Better Diffs
       Git is pre-configured with delta for enhanced diff viewing.

       SYNOPSIS
              git diff [OPTIONS]      View changes with delta pager
              git log -p [OPTIONS]    View commit history with diffs
              git show [COMMIT]       Show commit with delta

       DELTA FEATURES
              - Syntax highlighting for diffs
              - Side-by-side view
              - Line numbers
              - Git blame integration
              - Navigate between files with n/N

       EXAMPLES
              # View uncommitted changes
              git diff
              # Displays with syntax highlighting and side-by-side view

              # Compare branches
              git diff main..feature

              # Show specific commit
              git show HEAD~1

              # View commit history with diffs
              git log -p --oneline

       NAVIGATION (Inside delta)
              n               Next file
              N               Previous file
              q               Quit

       CONFIGURATION
              Delta is configured in ~/.gitconfig:
              - Side-by-side diffs
              - Line numbers enabled
              - Syntax highlighting
              - Dark theme

       SEE ALSO
              git(1), delta(1), diff(1)

---

### iftop - Bandwidth Monitor
       Real-time bandwidth monitoring showing connections and transfer rates.

       SYNOPSIS
              iftop [OPTIONS]

       COMMON OPTIONS
              -i INTERFACE    Monitor specific interface
              -n              No DNS resolution
              -N              No port resolution
              -p              Promiscuous mode
              -P              Show ports
              -b              Display bandwidth in bytes
              -B              Display bandwidth in bits
              -F NET/MASK     Filter traffic
              -c CONFIG       Config file

       KEY BINDINGS
              q               Quit
              h               Help
              n               Toggle DNS resolution
              s               Toggle source display
              d               Toggle destination display
              p               Toggle port display
              P               Pause display
              t               Cycle display modes (2/10/40 lines)
              l               Set display filter
              j/k             Scroll connection list
              1/2/3           Sort by column (1=TX, 2=RX, 3=Total)

       EXAMPLES
              # Monitor default interface
              iftop

              # Specific interface
              iftop -i eth0

              # No DNS lookups (faster)
              iftop -n

              # Show ports
              iftop -P

              # Filter by subnet
              iftop -F 192.168.1.0/24

              # Display in bits (not bytes)
              iftop -B

       DISPLAY
              Top Section         Bar graphs showing traffic rates
              Connection List     Source/Dest with TX/RX/Total rates
              Bottom Section      Cumulative totals and peak rates

       USE CASES
              - Find bandwidth usage per connection
              - Identify heavy talkers (top bandwidth consumers)
              - Monitor specific network interface traffic
              - Troubleshoot network saturation
              - Verify traffic patterns

       TIP
              Press 't' to cycle display modes for different time averages
              Already aliased: bandwidth

       SEE ALSO
              iftop(8), nethogs(8), nload(1), bandwidth

---

### gping - Visual Ping
       Ping with a graph showing latency over time.

       SYNOPSIS
              gping [OPTIONS] HOST...

       COMMON OPTIONS
              -n COUNT        Number of pings (default: infinite)
              -i INTERVAL     Interval between pings (seconds)
              --simple-graphics   Use simpler graphics
              --color COLOR   Graph color

       EXAMPLES
              # Ping single host
              gping google.com

              # Ping multiple hosts
              gping 1.1.1.1 8.8.8.8

              # Limit to 50 pings
              gping -n 50 example.com

              # Faster pings (0.2s interval)
              gping -i 0.2 localhost

              # Simple graphics (compatibility mode)
              gping --simple-graphics google.com

       FEATURES
              - Real-time latency graph
              - Multiple hosts simultaneously
              - Color-coded results
              - Min/max/avg statistics
              - Terminal-based visualization

       USE CASES
              - Monitor connection stability
              - Compare latency to multiple servers
              - Visualize network quality over time
              - Troubleshoot intermittent connectivity

       SEE ALSO
              gping(1), ping(8), mtr(8), pingg

---

# TIPS & TRICKS

       Common shortcuts and power-user techniques for  efficient  workflows.
       Combine  tools,  use shell features, and leverage fzf integration for
       maximum productivity.

## Keyboard Shortcuts
       Essential keybindings for fast navigation:

       **Ctrl+R**      Search command history with fzf
              Type Ctrl+R, then start typing to filter your history
              interactively. Press Enter to execute, Ctrl+C to cancel.

       **Ctrl+O**      Launch lf file manager
              Opens lf instantly from anywhere. Navigate files, preview
              with bat, then quit to return to that directory.

       **Ctrl+E**      Edit command in vim
              Opens current command line in vim for complex editing.
              Works in both insert and command mode.

       **ESC**         Vi command mode
              Zsh uses vi-mode by default. Press ESC to enter command mode,
              then use vi keys: h(left), j(down), k(up), l(right), w(word),
              b(back), 0(start), $(end), dd(delete line), etc.

       **Ctrl+C**      Cancel current command or stop process
       **Ctrl+D**      Exit shell (logout)
       **Ctrl+L**      Clear screen (same as 'clear' command)
       **Ctrl+Z**      Suspend current process (use 'bg' or 'fg' after)

## Quick Navigation
       Directory name auto-completion:

              /var          # Just type directory, auto-cd enabled
              ..            # Up one level
              ...           # Up two levels
              ....          # Up three levels

## Powerful Pipelines
       Combine tools for powerful workflows:

              # Find large files
              du -ah | sort -rh | head -20

              # Active connections per IP
              netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n

              # Monitor HTTP status codes
              tail -f access.log | grep -o 'HTTP/[0-9.]* [0-9]*' | cut -d' ' -f2 | sort | uniq -c

              # JSON API to CSV
              curl -s https://api.example.com/users | jq -r '.[] | [.name, .email] | @csv'

## Quick Tests
       One-liners for common checks:

              # Port open check
              nc -zv example.com 443 && echo "Open" || echo "Closed"

              # HTTP response time
              time curl -so /dev/null https://example.com

              # DNS timing
              time dig +short google.com

## Background Jobs
       Run commands in background:

              # Start background job
              long-running-command &

              # List jobs
              jobs

              # Bring to foreground
              fg %1

              # Send to background
              Ctrl+Z, then: bg

# TROUBLESHOOTING GUIDE

       Step-by-step solutions for common network debugging  scenarios.  Each
       problem  includes  diagnostic commands and resolution steps. Use these
       workflows as templates for investigating similar issues.

## Connection Refused
       1. Check if service is listening:
              listen | grep :PORT

       2. Try from localhost first:
              nc -zv 127.0.0.1 PORT

       3. Check firewall rules:
              iptables -L -n

## DNS Problems
       1. Check /etc/resolv.conf:
              cat /etc/resolv.conf

       2. Test specific nameserver:
              dig @8.8.8.8 example.com

       3. Trace delegation:
              dig +trace example.com

## Slow Network
       1. Check interface errors:
              ethtool -S eth0 | grep error

       2. Test bandwidth:
              iperf3 -c server.example.com

       3. Check packet loss:
              mtr -r -c 100 example.com

## SSL/TLS Issues
       1. Check certificate:
              certinfo example.com:443

       2. Test connection:
              sslcheck example.com:443

       3. Verify expiry:
              echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates

# PERMISSIONS & CAPABILITIES

       Some network operations require elevated capabilities. If you encounter
       "permission denied" or "operation not permitted" errors:

       **Packet Capture** (tcpdump, sniff)
              Requires: NET_ADMIN, NET_RAW capabilities
              Symptom: "socket: Operation not permitted"

       **Raw Sockets** (ping, traceroute, nmap SYN scan)
              Requires: NET_RAW capability or setuid
              Symptom: "socket: Operation not permitted"

       **Network Configuration** (ip, ifconfig, route changes)
              Requires: NET_ADMIN capability
              Symptom: "RTNETLINK answers: Operation not permitted"

       **Port Binding < 1024**
              Requires: CAP_NET_BIND_SERVICE or root
              Symptom: "Permission denied" when binding to privileged ports

       If experiencing permission issues, the container may need to be
       restarted with additional capabilities or host networking mode.

# FILES
       /etc/observer/MANUAL.md         This manual
       /etc/observer/banner.braille    ASCII art banner
       /root/.zshrc                    Zsh configuration
       /root/.zshrc.d/*.zsh            Modular zsh config files
       /root/.config/lf/lfrc           LF file manager config
       /root/.config/eza/theme.yml     Eza color theme
       /root/.gitconfig                Git configuration with delta

# ENVIRONMENT
       TZ                      Timezone (default: UTC)
       SHELL                   Default shell (/bin/zsh)
       TERM                    Terminal type (xterm-256color)
       LANG, LC_ALL            UTF-8 locale

# SEE ALSO
       Tool documentation available via:
              man TOOL       - Full manual pages (e.g., man nmap, man curl)
              TOOL --help    - Quick help summary
              TOOL -h        - Short help (most tools)

       Online resources:
              https://explainshell.com - Explain shell commands
              https://regex101.com - Test regex patterns
              https://jqplay.org - Test jq filters

# VERSION
       Observer version and build information is available in environment
       labels. To view the container version from outside, inspect the image.

# AUTHOR
       Created by ne0bytes
       Part of the ne0bytes tooling collection - https://gitlab.com/ne0bytes/tooling

# BUGS
       Report  issues  and  suggestions  at the project repository. Include
       relevant command output, error messages, and steps to reproduce.

---

**Observer(1)** - Network Debugging Environment - **January 2026**
