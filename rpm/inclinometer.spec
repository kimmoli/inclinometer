
Name:       harbour-inclinometer


%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Sailfish inclinometer
Version:    0.1.0
Release:    1
Group:      Qt/Qt
License:    LICENSE
URL:        https://github.com/kimmoli/inclinometer
Source0:    %{name}-%{version}.tar.bz2
BuildArch:  noarch
Requires:   sailfishsilica-qt5
Requires:   libsailfishapp-launcher
Requires:   qt5-qtdeclarative-import-sensors
Requires:   qt5-qtdeclarative-import-multimedia
BuildRequires:  desktop-file-utils

%description
Yet another inclinometer for Sailfish

%prep
%setup -q -n %{name}-%{version}

%qtc_qmake5

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original        \
  --dir %{buildroot}%{_datadir}/applications  \
  %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(644,root,root,755)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
