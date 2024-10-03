Name:           script
Version:        1.0
Release:        1%{?dist}
Summary:        Скрипт для підрахунку файлів у /etc

License:        GPL
Source0:        count_files.sh

%description
Це простий bash-скрипт, який підраховує кількість файлів у директорії /etc, виключаючи символічні посилання та директорії.

%install
mkdir -p %{buildroot}/usr/local/bin
cp %{SOURCE0} %{buildroot}/usr/local/bin/count_files.sh

%files
/usr/local/bin/count_files.sh

%changelog
* Sun Sep 29 2024 Pavlo Derkach <pawel.a.derckach@gmail.com> 1.0-1
- Initial release
