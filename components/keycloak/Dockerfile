FROM java

ENV KEYCLOAK_VERSION=1.8.1.Final \
    JBOSS_HOME=/opt/keycloak

WORKDIR /opt

RUN wget http://search.maven.org/remotecontent?filepath=org/keycloak/keycloak-server-dist/$KEYCLOAK_VERSION/keycloak-server-dist-$KEYCLOAK_VERSION.zip -O keycloak.zip \
 && unzip keycloak.zip \
 && rm keycloak.zip \
 && mv keycloak-$KEYCLOAK_VERSION keycloak

COPY config/keycloak-server.json /opt/keycloak/standalone/configuration/keycloak-server.json
COPY config/standalone.xml       /opt/keycloak/standalone/configuration/standalone.xml
COPY theme/cyclone               /opt/keycloak/standalone/configuration/themes/cyclone

RUN keycloak/bin/add-user.sh -r master -u test1 -p test1
ENTRYPOINT ["/opt/keycloak/bin/standalone.sh"]

EXPOSE 8080
