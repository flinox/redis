FROM redis
COPY redis_start.sh /usr/local/bin/redis_start.sh
RUN chmod +x /usr/local/bin/redis_start.sh
RUN echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
RUN ulimit -n 10032
EXPOSE 6379
CMD ["redis_start.sh"]