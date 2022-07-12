Install-WindowsFeature AD-Certificate, ADCS-Cert-Authority -IncludeManagementTools
Install-WindowsFeature ADCS-Web-Enrollment -IncludeManagementTools
Install-AdcsCertificationAuthority -CACommonName "RootCA" `
    -CADistinguishedNameSuffix "CN=RootCA" `
    -CAType StandaloneRootCA `
    -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
    -KeyLength 2048 `
    -HashAlgorithmName SHA256 `
    -ValidityPeriod "years" `
    -ValidityPeriodUnits 20 `
    -DatabaseDirectory $(Join-Path $env:SystemRoot "System32\CertLog") -Confirm:$False
Install-AdcsWebEnrollment -Confirm:$False
certutil -setreg CA\CRLPublicationURLs "65:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n14:http://vg-av-dc-01.corp.local/CertEnroll/%3%8%9.crl"
certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://vg-av-dc-01.corp.local/CertEnroll/%1_%3%4.crt"
certutil -setreg CA\ValidityPeriodUnits 15
certutil -setreg CA\ValidityPeriod "Years"
net stop certsvc 
net start certsvc

Copy-Item "C:\Windows\System32\certsrv\CertEnroll\vg-av-root_RootCA.crt" -Destination "C:\"
Copy-Item "C:\Windows\System32\certsrv\CertEnroll\RootCA.crl" -Destination "C:\"
