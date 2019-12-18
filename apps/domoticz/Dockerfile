FROM domoticz

RUN ln -s /domoticz/server_cert.pem /server_cert.pem

VOLUME /config

EXPOSE 8080

ENTRYPOINT ["/domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log"]
CMD ["-www", "8080"]
