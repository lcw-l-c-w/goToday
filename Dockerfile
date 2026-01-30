FROM tomcat:9.0-jdk11

# 기본 예제 앱 제거
RUN rm -rf /usr/local/tomcat/webapps/*

# 빌드된 WAR 배포 (ROOT 컨텍스트)
COPY target/gotoday.war /usr/local/tomcat/webapps/ROOT.war

# 업로드 디렉토리 생성 (볼륨 마운트 포인트)
RUN mkdir -p /app/upload /app/upload/poster /app/upload/inquiry

EXPOSE 8080
CMD ["catalina.sh", "run"]