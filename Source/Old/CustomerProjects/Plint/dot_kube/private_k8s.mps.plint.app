apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lNRnNCUks5K2RaN2dNd2VSMk1BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1qRXhNakV4TVRJME5URXpXaGNOTXpFeE1qRXhNVEkwTlRFegpXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQXZzNmJzYTFRVFdmSkwrc1R0dGRUOTdzemxnRDZlVjIzeFVhclluWnFSTUdpNS9pWEg3aWQKdm80dlBJSjlvSnZSekZLZlZMVGFaU0RKRHFndHJ5dG55Q3pHYng0cWZ3VXpoQWI3M1ZkOVl1RTJacGg0SnVzbgpLWGYwMm5Yd3JCSXhDaFNyWGdFL1QzeDJXUGpISStpamhzcGRnZkRqNGlBTXRaWnlRUWNBUXFSeExlbXc2UllPCndGdWptUHB2UFpnZkVPUW1IeExCUnVNNWl6NUowemdJYytobGhtSU9BUUd6MEhXRjlKY3hHMzJKMmZBcG40cTkKaEV0RU1uNlJDM0JtVyt0M0o2b0ppN0Rhb0ZvNDk0Z0ZWVzVBZlIxL1JpT1JITjRLRTBRTTZ1MUdEQUg4K0VGQwpld2pVM00yMFpGQ3ZEbk41VUgwTFVqU1RxK1NJVjN5Q253SURBUUFCbzBJd1FEQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QWRCZ05WSFE0RUZnUVVyVFN0NS9FR29nekREbllOZDdtMEI1Q1gKd2Fnd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFJNUh3OXdOODBsRzh6MjJZQ3pPclF1UDlwNFJLNkpCOEpVbgpicy85YWQzcXNDaFpySlFvRGRjbzY2cys1WUJkdFBYY1NjOXNyYUlaazA0RXJ5bjJGRHhDS1RGWFpuVElnZWhuClMzK1I3TVdSeXp2Q2NFVEJ2ZDlYdVF6QzZwY2ZPM2tGK29IN0hpdHo4OWl0OGxWRUtEVjZXUWxoY0o1TWUyN2wKcEIwaWx2eUY2YUdtaWlvd05ESFQwSFhsTnB1TlBNZHNWS2M0d3VBMU1iSEgzSG1mZXVwWHFGR25sYXpoQlhRSwo5S1JuSEQ4dERkVjhxak5zK3FyOFk3eURuMGFKcnNsMXMya2Q5QjQ0a2p0T3VZMERHckIxYjZqTzVaR05aREJtClh1dGt6a3EvZGt1VG4vU0dCMlA2ZDEvUTIvdEdML2dCY29xZWxnb3BlVG51VVlzaVF1cz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      server: https://api.k8s.mps.plint.app
    name: k8s.mps.plint.app
contexts:
  - context:
      cluster: k8s.mps.plint.app
      user: k8s.mps.plint.app
    name: k8s.mps.plint.app
current-context: k8s.mps.plint.app
kind: Config
preferences: {}
users:
  - name: k8s.mps.plint.app
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - eks
          - get-token
          - --cluster-name
          - k8s.mps.plint.app
        env:
          - name: AWS_PROFILE
            value: mps-production
        command: aws
