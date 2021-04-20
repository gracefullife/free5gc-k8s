set -o pipefail \
    && echo '[*] Build the Network Functions for Contorl Plane' \
    && git clone --recursive -b ${FREE5GC_VERSION} -j 4 --depth 1 ${FREE5GC_GIT} \
    && cd ./free5gc \
    && git checkout ${FREE5GC_COMMITID} \
    && cd ./src \
    && go mod download \
    && for d in * ; do if [ -f "$d/$d.go" ] ; then CGO_ENABLED=0 go build -a -installsuffix nocgo -o ../bin/"$d" -x "$d/$d.go" ; fi ; done \
    && echo '[*] Build the Network Function for User Plane' \
    && go get -u -v "github.com/sirupsen/logrus" \
    && cd ${GOPATH}/src/free5gc/src/upf \
    && mkdir -p build \
    && cd ./build \
    && cmake .. \
    && make -j `nproc` \
    && echo '[*] Build the Web Console for Free5GC Operation' \
    && cd ${GOPATH}/src/free5gc/webconsole \
    && CGO_ENABLED=0 go build -a -installsuffix nocgo -o webui -x server.go
