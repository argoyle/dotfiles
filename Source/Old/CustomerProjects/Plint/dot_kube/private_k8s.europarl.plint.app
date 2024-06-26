apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lNRnI1NTB4cisyV2hHVlJTR01BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1qRXhNakExTVRJME56UXlXaGNOTXpFeE1qQTFNVEkwTnpReQpXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQXdqRExjaEt2S2FtNlQxM1pVM3FQUHNmVi83bFRVc1JhN0pYUHMrdjdGSnRXR0FjM2NreXAKK01jNnUvR0o1UXFFMXR3SnpYZUlIU2lZVnJCUStNYVdHRGlxTEdwN1JrYlFQRHpHbHo1NW40azBuSFA2dkwrSwpzZzlhZS9mTVVIdXlsR3VNUmV4amlzNHJ3Z3lsVGpNdFFkaVo2cmNnR3RoQ3lheDQrdFFwOHM0bUI5NDFsYzNwCkp6eG1qQVdLRGxmTy8zWHdnSFpLN1pOc0JBd2R0Nys2N2pOY3dHWUFPbGpteHFiRFNCb0I4clJPVzBESTdaY2IKbHgxdEN2RWNrMlYrYzVQRFFGUk9mYU4xblNadU9Cckp0R1BzekxVRWt1QVlDOWpPRUIwNk9NcHhRNzV1d0VEdwpFTW9zcGNudG9rVTVTRk1lcDFDMkdXNGFhWS9VN1A5bHVRSURBUUFCbzBJd1FEQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QWRCZ05WSFE0RUZnUVViZFB6dWl5ZXF2ZEZpWWxNalYwWnVBWkIKUlo4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFNSGRUeUxHR0hhdEJXMU5WUWVpeWhEd3FySUowYjRJWm9TLwpDK0o0NHN5aTNEOVZVczZtUHMvc2o2cmQyWXJwZ3hWcmZHQi9CRjExWndiYk42Z3c1QXRNN1R1bDdTdmZPMGJpCjNFVTBNTzEzYmdaaE0yQ01rQitoZUNScXVHc0JnNG50MStIeENKY2ZPbGNrdkZROUVkSzhaUHViRlBQdmtBQWgKdW1uVUhDTWI5Ri9kRUk4Nk9zNGpNL3BVb1lGWjBiTm5zeThVNjFRQzltbUVuM0MrRGpKQ014QTRQcTlPRFBqVgpzUDdhdjkvYmVTN3AyaVAvcHpjUU1FOHdYaDdRb0d2ZGs0SDhDbklycDdwWnNyeENDWkZWVlJQR1R3VTdDTDlkCmFhRlplQzVCQXdrdFdEOVRtQ0xsbEdUaXhpRTNheG5xMHJ2UlRHOWtPVTh5U2UraWJtYz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      server: https://api.k8s.europarl.plint.app
    name: k8s.europarl.plint.app
contexts:
  - context:
      cluster: k8s.europarl.plint.app
      user: k8s.europarl.plint.app
    name: k8s.europarl.plint.app
current-context: k8s.europarl.plint.app
kind: Config
preferences: {}
users:
  - name: k8s.europarl.plint.app
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - eks
          - get-token
          - --cluster-name
          - k8s.europarl.plint.app
        env:
          - name: AWS_PROFILE
            value: europarl-production
        command: aws
