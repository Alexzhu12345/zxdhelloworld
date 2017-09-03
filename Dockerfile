FROM 127.0.0.1:5000/tomcat
RUN rm -rf /usr/local/tomcat/webapps
ADD ./target/hw.war /usr/local/tomcat/webapps/hw.war