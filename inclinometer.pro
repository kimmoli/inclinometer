TARGET = harbour-inclinometer

TEMPLATE = aux

qml.files = qml/
qml.path = /usr/share/$${TARGET}/

desktop.files = $${TARGET}.desktop
desktop.path = /usr/share/applications

icon.files = $${TARGET}.png
icon.path = /usr/share/icons/hicolor/86x86/apps

INSTALLS = qml desktop icon

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/Inclinometer.qml \
    rpm/inclinometer.spec \
    harbour-inclinometer.desktop \
    harbour-inclinometer.png \
    qml/harbour-inclinometer.qml
