
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
import QtMultimedia 5.0

Page
{
    id: page

    anchors.fill: parent

    Accelerometer
    {
        id: accelerometer
        dataRate: 25
        active: applicationActive && page.status === PageStatus.Active

        property double angle: 0.0
        property double rawangle: 0.0
        property double offset: 0.0
        property double x: 0.0
        property double y: 0.0

        Behavior on x { NumberAnimation { duration: 175 } }
        Behavior on y { NumberAnimation { duration: 175 } }

        function reset()
        {
            offset = rawangle
        }

        onReadingChanged:
        {
            x = reading.x
            y = reading.y
            var a

            if ( (Math.atan(y / Math.sqrt(y * y + x * x))) >= 0 )
                a = -(Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )
            else
                a = Math.PI + (Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )

            rawangle = a * (180/Math.PI)
            angle = rawangle - offset
        }
    }

    Label
    {
        id: angleLabel
        anchors.centerIn: parent
        rotation: accelerometer.rawangle
        text: accelerometer.angle.toFixed(1)
        font.pixelSize: Math.min(parent.height, parent.width) / 3
        font.bold: true
        MouseArea
        {
            anchors.fill: parent
            onPressAndHold: accelerometer.reset()
        }
        Label
        {
            id: offsetLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: Theme.paddingSmall
            text: "Offset " + accelerometer.offset.toFixed(1)
            visible: accelerometer.offset.toFixed(1) != 0.0
        }
    }

    Timer
    {
        id: tickTimer
        interval: 600
        running: (((accelerometer.angle > 85.0) && (accelerometer.angle < 95.0)) ||
                  ((accelerometer.angle > -5.0) && (accelerometer.angle < 5.0)) ||
                  ((accelerometer.angle > 175.0) && (accelerometer.angle < 185.0))) &&
                        applicationActive && page.status === PageStatus.Active
        triggeredOnStart: true
        repeat: true
        onTriggered:
        {
            tick.play()
            if ((accelerometer.angle > 85.0) && (accelerometer.angle < 95.0))
                interval = 100.0 * Math.abs(90.0 - accelerometer.angle) + 50.0
            else if ((accelerometer.angle > -5.0) && (accelerometer.angle < 5.0))
                interval = 100.0 * Math.abs(accelerometer.angle) + 50.0
            else if ((accelerometer.angle > 175.0) && (accelerometer.angle < 185.0))
                interval = 100.0 * Math.abs(180.0 - accelerometer.angle) + 50.0
        }
    }

    SoundEffect
    {
        id: tick
        source: (angleLabel.text == "90.0") ||
                (angleLabel.text == "0.0") ||
                (angleLabel.text == "180.0") ||
                (angleLabel.text == "270.0") ? "/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav" :
                        "/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav"
    }
}


