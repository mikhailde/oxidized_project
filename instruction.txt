git clone https://github.com/ytti/oxidized.git
docker build -t oxidized/oxidized:latest oxidized/
mkdir oxidized_config
cp oxidized/examples/podman-compose/oxidized-config/{config,router.db} oxidized_config/
nano oxidized_config/{config,router.db}
git clone git@github.com:<name>/<project>.git oxidized_config/
cp ~/.ssh/id_rsa oxidized_config/id_rsa
chown 30000:30000 oxidized_config/id_rsa
docker run -v oxidized_config:/home/oxidized/.config/oxidized/ -p 8888:8888/tcp -t oxidized:oxidized:latest
