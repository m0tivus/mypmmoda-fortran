<div align="center">

  <h1>mypmmoda on Motivus</h1>

  <h3>
    <a href="https://motivus.cl/documentation/">Learn more</a>
    <span> | </span>
    <a href="https://discord.gg/t8f5xNhTJW">Join us on Discord</a>
  </h3>
</div>

## 🛠️ Development Environment Requirements
* Docker
   * Your user must belong to the `docker` group.
* Python = 3.7 | 3.8 | 3.9
   * We recommend using a `conda` environment.
* [*Motivus CLI tool* and *Motivus Client library*](https://pypi.org/project/motivus/): `$ pip install motivus`

### 🛠️ Build with `motivus build`

```
$ motivus build
```

### 🔬 Test locally with `motivus loopback`

```
$ motivus loopback
```
```
$ WEBSOCKET_URI=ws://localhost:7070/client_socket/websocket python driver.py
```

### 🎁 Publish to Motivus Marketplace with `motivus push`

```
$ motivus push
```

