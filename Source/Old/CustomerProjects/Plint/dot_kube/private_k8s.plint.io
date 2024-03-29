apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lNRnEwOE5EQlFteWlpcEp3WU1BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1qRXhNREV3TURnME56RTBXaGNOTXpFeE1ERXdNRGcwTnpFMApXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQTZkRGFVMDAvQW1rdG9lMXFQc0NPL24ydGFxdktSaE0xeDRxdVJjbG8yUVFGZ28ydEsrZ2YKdkVhRndYYlpRNGRZMFJEU21LVkwwbm1PeE5USWc4WmpxV1ZFaVBNVHY1bTM0WGdiUHJMd2FlRHJVZWh3NldYagpGR1dLKzcxN1JabmRQcUhGQTVFSi8wZkJSZmZFcEZFVXdnd2hmTGdaRHF2bTBTRFZPZm5Qb3NQaTl3a2ZFUzQvCjBTZlgwT3hac09ZU1ArZnR0MDh1b3BJN2x5Skd6WGovbXZoSHgwZEJxdEFkMVR2bVpUNHNReEwxWHY1WGFXR04KM0pWNnRKdi9GMXlIbERKWVJ1NWRUVXYyeFJ5U0lzb254NHV6YVMzcVljNCtIeDkrTWtURlpyVmJyT3lYNzQyTwpEUVVaaXFoY3JNZzNtQzUzem5GeHRsNFNwMlkyNVVQeFZRSURBUUFCbzBJd1FEQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QWRCZ05WSFE0RUZnUVV5a0FMeEY0L1U2NVZqNXlOMkN6TmU0ZnEKK1E4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFFcU1LcFg1T0w2MnZOdkZTaHlNcy9aL1RJZmdKSmlwTUkydQozV253cmJjSkJ5MWd2d3MvNXd1QWw5RmtnMjltOG5LUlNrbTFIenQyRVpNc2pUQmtvN2ZyUUFBdzNrTlRnWEdwCmFGVStXT2lSdVFlN0lYeVNudmFWZENDZ0tQQnk0dDRHWld1bXF0K01nZEJ3eGttM09CVGc3bkt0bFFRQmNQNnQKVHFaUUNQdlVFeS8yM0ZFVEVzTDE3SExhbjk4YlBLTVNZVFNNS2p0empSSTJJd3QrYXd5ejBHd2dUN3Z0aHhldQpWNXNHRWxMOGZSQ3RETitIOC8zdk5KTkYxR1h1SmovN0JicVhDbmxocGRnZ3QzU3JDdTluSUhNOS9pbnU0bnRzClFJTVZaWFFkQzdWa1BFWEJ6UzBBaWRRVWtiRkk5NzV3empHbElqRUNsb1owVGtVWlpPMD0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      server: https://api.k8s.plint.io
    name: k8s.plint.io
contexts:
  - context:
      cluster: k8s.plint.io
      user: k8s.plint.io
    name: k8s.plint.io
current-context: k8s.plint.io
kind: Config
preferences: {}
users:
  - name: k8s.plint.io
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - eks
          - get-token
          - --cluster-name
          - k8s.plint.io
        env:
          - name: AWS_PROFILE
            value: plint-production
        command: aws
