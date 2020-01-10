# BloodHound Docker Ready to Use
![bloodhound](https://user-images.githubusercontent.com/17031267/48985201-6f587a00-f105-11e8-8355-98e38e08cc5e.png)

Bloodhound version: 2.2.1

## Build Image
### Build
`docker build . -t bloodhound`

## Run (with autorestart)
```
docker run -it \
  -p 7687:7687 \
  -e DISPLAY=unix$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device=/dev/dri:/dev/dri \
  -v ~/bloodhound/data:/data \
  --restart=always --name bloodhound bloodhound
```

### Start container
```
docker start bloodhound
```

## Use
Default login:
- **Database URL:** bolt://localhost:7687
- **DB Username:** neo4j
- **DB Password:** blood

There is a `bloodhound/data` folder in your "Home" directory with the Ingestors.
data folder is also mounted as volume, use it to drop your data and load it in  BloodHound GUI.

## Documentation
https://github.com/BloodHoundAD/BloodHound/wiki

## Tested
Ubuntu 18.04 Server
