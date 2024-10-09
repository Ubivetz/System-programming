# Використовуємо офіційний образ Jenkins LTS як базовий
FROM jenkins/jenkins:lts

# Перемикаємось на користувача root для встановлення додаткових пакетів
USER root

# Встановлюємо необхідні пакети, включаючи Tini та Docker
RUN apt-get update && \
 apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common tini && \
 mkdir -p /etc/apt/keyrings && \
 curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
 echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
 apt-get update && \
 apt-get install -y docker-ce docker-ce-cli containerd.io && \
 usermod -aG docker jenkins

# Встановлюємо необхідні утиліти
RUN apt-get install -y git sudo

# Налаштовуємо sudo для користувача Jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Експонуємо порт Jenkins
EXPOSE 8080

# Встановлюємо змінні оточення
ENV JENKINS_HOME=/var/jenkins_home

# Повертаємося до користувача Jenkins
USER jenkins

# Запускаємо Jenkins за допомогою Tini
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]