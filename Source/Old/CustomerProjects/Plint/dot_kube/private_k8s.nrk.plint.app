apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lNRnI5dGNKSUwrY2hvWU1DWU1BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1qRXhNakE0TVRVeE1UVTVXaGNOTXpFeE1qQTRNVFV4TVRVNQpXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQXpBM2JBQUZRMW5HekUybWY1RnpUZWpoZ2JzcWRMSlFXN2NXdUZkRVhEdVQvbHVGaS9xM0UKajNHKys5dXV0N1Q5cEx0ei9Wc1JSUjlUaWQ5dGNNTXRrZGtUUllKaVEzenJFS2hxUmU1MEJwWFFKQ2NHTGJQegpabWJmQUwydDg2WWZsQjh2b3NkU2UweHQ3K2ZyOVFoL2FlazJQQXpoUkNWZDIxNXdxamNEcEdhNGZUVjJsR1dRClRaemEyR1Bpa2pLVEVnZ1lIcXpYNzh6dkJXOElXWFBybDMrRHJsd3U0MFc5bVBoVS9iZFY0MjlqSXhIckFkZzIKZytJaWhTZ2YzcTkxVkdvUlNyZ1ZkdjlTSmZwT2w4K1Z6S1JGUUdzbUUyM2lCRXlzcWFtelppd0hIUFZUZ0RVWQovdzRDK084NjBadWswNHI0a2xRNUNydTg0L3p3cGhDNWRRSURBUUFCbzBJd1FEQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QWRCZ05WSFE0RUZnUVVnZUNVSWMxbkZ0cSt6QzM3UjZLOUFiZkQKcWtvd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFJaWFGU25Kc2c5dmdjREN3Qnl4Wkk5R2R4TldQZlphNHRrcAoxRVRCU1ZKanZQZmJwOXp3VUZYRSsyZGpXQS9DZ3g0cHhWRFlIdkl5M3piZnJmb29KMjRLZlUrU1NYQ25MNFhwCnlBM3krMk5uM01vZFVFM21IK3hVNUZ3cnBDY2p6Y3pLTnZjOUNaRzVuc1ZsYW9PSEY5N21mM0JiL28vOGNWYnQKR09NTzRLcm5rZk8zMWE4bWdrK3FqeUVvbTRYU0k4RnJJOVVJVVphT2Z6K2VIczUxUGNpcnJoV1FzdzdZOWdOcwozMkIvNnN1azRKY0NTUWlqc2RnU0ZWRzNkUkpaNW5la2ZpaE8zaDBiUGJJWCtnc0VMUld2bmJSTXdQbWZEZG1KCkU1Q29PVDJsYUwySXpnbVdSNTA3M2MrNzhLYVhLZHY0OXNtaUdUekxGTFhQWC9yK2Y2TT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      server: https://api.k8s.nrk.plint.app
    name: k8s.nrk.plint.app
contexts:
  - context:
      cluster: k8s.nrk.plint.app
      user: k8s.nrk.plint.app
    name: k8s.nrk.plint.app
current-context: k8s.nrk.plint.app
kind: Config
preferences: {}
users:
  - name: k8s.nrk.plint.app
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - eks
          - get-token
          - --cluster-name
          - k8s.nrk.plint.app
        env:
          - name: AWS_PROFILE
            value: nrk-production
        command: aws
