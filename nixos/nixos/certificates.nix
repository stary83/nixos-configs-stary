{ ... }:

{
  security.pki.certificates = [
    # Paste the contents of your ca/ca.crt file here
    # certificate used by MasterHttpRelayVpn
    ''
    -----BEGIN CERTIFICATE-----
    MIIDKDCCAhCgAwIBAgIUMsLRC+7NqmSb+CeSTb/OTUqkmhwwDQYJKoZIhvcNAQEL
    BQAwOjEbMBkGA1UEAwwSTWFzdGVySHR0cFJlbGF5VlBOMRswGQYDVQQKDBJNYXN0
    ZXJIdHRwUmVsYXlWUE4wHhcNMjYwNDIyMDQ1MjA4WhcNMzYwNDE5MDQ1MjA4WjA6
    MRswGQYDVQQDDBJNYXN0ZXJIdHRwUmVsYXlWUE4xGzAZBgNVBAoMEk1hc3Rlckh0
    dHBSZWxheVZQTjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALC37r4O
    r+Wfg/j4ah+pdrdRVtJoVPQV8nSJIC4k7Yu1NnmA3FfVcj9qaTg5+88ynqpA1otw
    Lh8qnEed4lMes9U++4GXAB5GMry5aC7OhLedsXPanIobwxKM6J1DlQOf0me7jsIH
    oA0qhIw6Ix/Pn/HsM6+OTLkE2/+7lyXkdnhKS53d6N/GWuT+M5LyhIah6moZFAMj
    vGFe5PWLk9gKVEc7KA97E0n40uF+PNAFIppvwEiZRpWyf5QOTbmCMbIJXMBQ38D8
    l2YA2ltk8l07WJbn4K+ROEwCxXFi1o1DEgPMkCV2O258yjUC9pRx1LlCLX5kD68d
    w2eVejzbFckNRFsCAwEAAaMmMCQwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8B
    Af8EBAMCAYYwDQYJKoZIhvcNAQELBQADggEBAHNW38xPvAzb5L+fKhzsbBpjQveh
    BKxQVCWA4l8Xz8YqSGqDjRFRvccffo+eraH7jxRHaFEP+Do3YtMFDwoRYO/6Xr1+
    kRyaasoQzCDJQdaplFdyKOlSGpQv5ya7K9xqXa6mBDFz/5q2FPW/bgHLidSqoXiZ
    8dRW6P3iIQzpafR2FrLddnVWbjkk9wQEG5/iLGaDubfvoprQbw1XTalLnc2Of4o/
    XSUXq1OADLnF+Ca4xnK3bTKvai/jyIrtjjdzKaBkwRv6F7c+QrZCpMJzzz/vcYXv
    euQnk184vFqDGZKXl6+DbQ53Uuhvn4Eynt4qRAUHbO5H9Z1tSc01xOg94uo=
    -----END CERTIFICATE-----
    ''
  ];
  environment.variables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };
}
